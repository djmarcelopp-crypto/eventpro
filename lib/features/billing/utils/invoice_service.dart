import 'package:eventpro/features/quotes/data/repositories/quote_repository.dart';
import 'package:uuid/uuid.dart';

import '../data/repositories/invoice_item_repository.dart';
import '../data/repositories/invoice_repository.dart';
import '../models/invoice.dart';
import '../models/invoice_item.dart';
import '../models/invoice_item_input.dart';
import '../models/invoice_operation_result.dart';
import '../models/invoice_status.dart';
import '../models/invoice_type.dart';
import 'invoice_item_validator.dart';
import 'invoice_status_transitions.dart';
import 'invoice_totals.dart';
import 'invoice_validator.dart';

/// Coordinates invoice lifecycle, numbering and totals.
///
/// **Numbering:** [invoiceNumber] may be omitted by the caller; when omitted
/// (null/blank), generates `INV-YYYY-####`. When provided, the trimmed value
/// is required and must be unique (case-insensitive). Uniqueness uses
/// [InvoiceRepository.listAll] — sufficient for the local SQLite MVP.
///
/// **Totals:** always recomputed from items + tax/discount — never trusted
/// from the caller. [InvoiceStatusTransitions] is the sole status matrix.
///
/// **Consistency:** items are validated before any write; if item persistence
/// fails after the invoice insert, the invoice is deleted (CASCADE removes
/// any partial items).
///
/// No fiscal emission, PDF generation or bank integrations.
class InvoiceService {
  InvoiceService({
    required InvoiceRepository invoiceRepository,
    required InvoiceItemRepository itemRepository,
    required QuoteRepository quoteRepository,
    DateTime Function()? clock,
  })  : _invoiceRepository = invoiceRepository,
        _itemRepository = itemRepository,
        _quoteRepository = quoteRepository,
        _clock = clock ?? DateTime.now;

  static const _uuid = Uuid();

  final InvoiceRepository _invoiceRepository;
  final InvoiceItemRepository _itemRepository;
  final QuoteRepository _quoteRepository;
  final DateTime Function() _clock;

  Future<InvoiceOperationResult> create({
    required String quoteId,
    required InvoiceType type,
    required List<InvoiceItemInput> items,
    String? invoiceNumber,
    int taxCents = 0,
    int discountCents = 0,
    String notes = '',
    DateTime? dueDate,
  }) async {
    final quote = await _quoteRepository.findById(quoteId);
    if (quote == null) {
      return InvoiceOperationResult.quoteNotFound();
    }

    final resolvedNumber = await _resolveInvoiceNumber(invoiceNumber);
    if (resolvedNumber == null) {
      return InvoiceOperationResult.validationFailed([
        InvoiceValidator.invoiceNumberRequiredError,
      ]);
    }

    final itemErrors = _validateItemInputs(items);
    if (itemErrors != null) {
      return InvoiceOperationResult.validationFailed(itemErrors);
    }

    final totalsError = _validateTotals(
      items: items,
      taxCents: taxCents,
      discountCents: discountCents,
    );
    if (totalsError != null) {
      return InvoiceOperationResult.validationFailed(totalsError);
    }

    final subtotal = InvoiceTotals.subtotalFromInputs(items);
    final total = InvoiceTotals.totalCents(
      subtotalCents: subtotal,
      taxCents: taxCents,
      discountCents: discountCents,
    );

    final fieldsResult = InvoiceValidator.validateFields(
      quoteId: quoteId,
      invoiceNumber: resolvedNumber,
      type: type,
      status: InvoiceStatus.draft,
      subtotalCents: subtotal,
      taxCents: taxCents,
      discountCents: discountCents,
      totalCents: total,
    );
    if (!fieldsResult.isValid) {
      return InvoiceOperationResult.validationFailed(fieldsResult.errors);
    }

    if (await _hasDuplicateNumber(resolvedNumber)) {
      return InvoiceOperationResult.duplicateNumber();
    }

    final now = _clock();
    final invoiceId = _uuid.v7();
    final invoice = Invoice(
      id: invoiceId,
      quoteId: quoteId,
      invoiceNumber: resolvedNumber,
      type: type,
      status: InvoiceStatus.draft,
      dueDate: dueDate,
      subtotalCents: subtotal,
      taxCents: taxCents,
      discountCents: discountCents,
      totalCents: total,
      notes: notes.trim(),
      createdAt: now,
      updatedAt: now,
    );

    try {
      await _invoiceRepository.insert(invoice);
    } catch (_) {
      return InvoiceOperationResult.failure();
    }

    try {
      for (final input in items) {
        final lineTotal = InvoiceTotals.lineTotalCents(
          quantity: input.quantity,
          unitPriceCents: input.unitPriceCents,
        );
        final item = InvoiceItem(
          id: _uuid.v7(),
          invoiceId: invoiceId,
          description: input.description.trim(),
          quantity: input.quantity,
          unitPriceCents: input.unitPriceCents,
          totalPriceCents: lineTotal,
        );
        await _itemRepository.insert(item);
      }
      return InvoiceOperationResult.success(invoice);
    } catch (_) {
      // Compensate: CASCADE on invoice_items removes any partial lines.
      try {
        await _invoiceRepository.delete(invoiceId);
      } catch (_) {
        // Best-effort cleanup; surface the original failure.
      }
      return InvoiceOperationResult.failure();
    }
  }

  Future<InvoiceOperationResult> issue(String id) {
    return _transition(
      id: id,
      to: InvoiceStatus.issued,
      apply: (existing, now) => existing.copyWith(
        status: InvoiceStatus.issued,
        issueDate: now,
        updatedAt: now,
        createdAt: existing.createdAt,
      ),
    );
  }

  Future<InvoiceOperationResult> markPaid(String id) {
    return _transition(
      id: id,
      to: InvoiceStatus.paid,
      apply: (existing, now) => existing.copyWith(
        status: InvoiceStatus.paid,
        paidAt: now,
        updatedAt: now,
        createdAt: existing.createdAt,
      ),
    );
  }

  Future<InvoiceOperationResult> cancel(String id) {
    return _transition(
      id: id,
      to: InvoiceStatus.cancelled,
      apply: (existing, now) => existing.copyWith(
        status: InvoiceStatus.cancelled,
        updatedAt: now,
        createdAt: existing.createdAt,
      ),
    );
  }

  Future<Invoice?> findById(String id) => _invoiceRepository.findById(id);

  Future<List<Invoice>> listByQuoteId(String quoteId) =>
      _invoiceRepository.listByQuoteId(quoteId);

  Future<List<InvoiceItem>> listItems(String invoiceId) =>
      _itemRepository.listByInvoiceId(invoiceId);

  Future<InvoiceOperationResult> _transition({
    required String id,
    required InvoiceStatus to,
    required Invoice Function(Invoice existing, DateTime now) apply,
  }) async {
    final existing = await _invoiceRepository.findById(id);
    if (existing == null) {
      return InvoiceOperationResult.notFound();
    }

    if (InvoiceStatusTransitions.wouldRegress(existing.status, to)) {
      return InvoiceOperationResult.invalidTransition();
    }

    if (!InvoiceStatusTransitions.canTransition(existing.status, to)) {
      if (to == InvoiceStatus.paid &&
          existing.status == InvoiceStatus.cancelled) {
        return InvoiceOperationResult.cannotPayCancelled();
      }
      if (to == InvoiceStatus.cancelled &&
          existing.status == InvoiceStatus.paid) {
        return InvoiceOperationResult.cannotCancelPaid();
      }
      return InvoiceOperationResult.invalidTransition();
    }

    final now = _clock();
    final updated = apply(existing, now);

    try {
      await _invoiceRepository.update(updated);
      return InvoiceOperationResult.success(updated);
    } catch (_) {
      return InvoiceOperationResult.failure();
    }
  }

  /// Resolves caller input: omit/blank → auto `INV-YYYY-####`; else trimmed.
  /// Returns null only if a non-null input trims to empty after an unexpected
  /// path — blank/null always auto-generates.
  Future<String?> _resolveInvoiceNumber(String? invoiceNumber) async {
    final trimmed = invoiceNumber?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return _nextInvoiceNumber();
    }
    return trimmed;
  }

  List<String>? _validateItemInputs(List<InvoiceItemInput> items) {
    if (items.isEmpty) {
      return const ['Informe ao menos um item da fatura'];
    }
    final errors = <String>[];
    for (final input in items) {
      final lineTotal = InvoiceTotals.lineTotalCents(
        quantity: input.quantity,
        unitPriceCents: input.unitPriceCents,
      );
      final result = InvoiceItemValidator.validateFields(
        invoiceId: 'pending',
        description: input.description,
        quantity: input.quantity,
        unitPriceCents: input.unitPriceCents,
        totalPriceCents: lineTotal,
      );
      errors.addAll(result.errors);
    }
    if (errors.isEmpty) return null;
    return List.unmodifiable(errors.toSet().toList());
  }

  List<String>? _validateTotals({
    required List<InvoiceItemInput> items,
    required int taxCents,
    required int discountCents,
  }) {
    if (taxCents < 0) {
      return [InvoiceValidator.taxNegativeError];
    }
    if (discountCents < 0) {
      return [InvoiceValidator.discountNegativeError];
    }
    final subtotal = InvoiceTotals.subtotalFromInputs(items);
    final total = InvoiceTotals.totalCents(
      subtotalCents: subtotal,
      taxCents: taxCents,
      discountCents: discountCents,
    );
    if (total < 0) {
      return [InvoiceValidator.totalNegativeError];
    }
    return null;
  }

  Future<String> _nextInvoiceNumber() async {
    final now = _clock();
    final year = now.year;
    final prefix = 'INV-$year-';
    final all = await _invoiceRepository.listAll();
    var maxSequence = 0;
    for (final invoice in all) {
      final number = invoice.invoiceNumber.trim().toUpperCase();
      if (!number.startsWith(prefix)) continue;
      final suffix = number.substring(prefix.length);
      final sequence = int.tryParse(suffix);
      if (sequence != null && sequence > maxSequence) {
        maxSequence = sequence;
      }
    }
    final next = (maxSequence + 1).toString().padLeft(4, '0');
    return '$prefix$next';
  }

  Future<bool> _hasDuplicateNumber(String number, {String? excludingId}) async {
    final all = await _invoiceRepository.listAll();
    final needle = number.trim().toLowerCase();
    return all.any(
      (invoice) =>
          invoice.id != excludingId &&
          invoice.invoiceNumber.trim().toLowerCase() == needle,
    );
  }
}
