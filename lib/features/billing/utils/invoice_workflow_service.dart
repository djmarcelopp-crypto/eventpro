import '../data/repositories/invoice_repository.dart';
import '../models/invoice.dart';
import '../models/invoice_operation_result.dart';
import '../models/invoice_status.dart';
import '../models/invoice_workflow_summary.dart';
import 'invoice_service.dart';
import 'invoice_status_transitions.dart';

/// Coordinates invoice status workflow for UI and callers.
///
/// **Does not own a transition matrix.** All transition checks delegate to
/// [InvoiceStatusTransitions]. Persistence is delegated to [InvoiceService].
///
/// No fiscal emission, PDF, boleto, PIX or bank integrations.
class InvoiceWorkflowService {
  InvoiceWorkflowService({
    required InvoiceService invoiceService,
    required InvoiceRepository invoiceRepository,
  })  : _invoiceService = invoiceService,
        _invoiceRepository = invoiceRepository;

  final InvoiceService _invoiceService;
  final InvoiceRepository _invoiceRepository;

  bool canTransition(InvoiceStatus from, InvoiceStatus to) {
    return InvoiceStatusTransitions.canTransition(from, to);
  }

  bool wouldRegress(InvoiceStatus from, InvoiceStatus to) {
    return InvoiceStatusTransitions.wouldRegress(from, to);
  }

  InvoiceWorkflowSummary summarize(Invoice invoice) {
    final allowed = <InvoiceStatus>{
      for (final candidate in InvoiceStatus.values)
        if (canTransition(invoice.status, candidate)) candidate,
    };

    final canIssue = allowed.contains(InvoiceStatus.issued);
    final canMarkPaid = allowed.contains(InvoiceStatus.paid);
    final canCancel = allowed.contains(InvoiceStatus.cancelled);
    final isFinal = invoice.status == InvoiceStatus.paid ||
        invoice.status == InvoiceStatus.cancelled;

    final nextStatus = _preferredNextStatus(invoice.status, allowed);
    final blockReason = _blockReason(
      status: invoice.status,
      canIssue: canIssue,
      canMarkPaid: canMarkPaid,
      canCancel: canCancel,
      isFinal: isFinal,
    );

    return InvoiceWorkflowSummary(
      invoice: invoice,
      allowedNextStatuses: Set.unmodifiable(allowed),
      canIssue: canIssue,
      canMarkPaid: canMarkPaid,
      canCancel: canCancel,
      isFinal: isFinal,
      nextStatus: nextStatus,
      blockReason: blockReason,
    );
  }

  Future<InvoiceWorkflowSummary?> summarizeById(String id) async {
    final invoice = await _invoiceRepository.findById(id);
    if (invoice == null) return null;
    return summarize(invoice);
  }

  Future<InvoiceOperationResult> advance(String id, InvoiceStatus to) async {
    final existing = await _invoiceRepository.findById(id);
    if (existing == null) {
      return InvoiceOperationResult.notFound();
    }

    if (existing.status == to) {
      return InvoiceOperationResult.invalidTransition();
    }

    if (wouldRegress(existing.status, to)) {
      return InvoiceOperationResult.invalidTransition();
    }

    if (!canTransition(existing.status, to)) {
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

    return switch (to) {
      InvoiceStatus.issued => _invoiceService.issue(id),
      InvoiceStatus.paid => _invoiceService.markPaid(id),
      InvoiceStatus.cancelled => _invoiceService.cancel(id),
      InvoiceStatus.draft => InvoiceOperationResult.invalidTransition(),
    };
  }

  Future<InvoiceOperationResult> issue(String id) =>
      advance(id, InvoiceStatus.issued);

  Future<InvoiceOperationResult> markPaid(String id) =>
      advance(id, InvoiceStatus.paid);

  Future<InvoiceOperationResult> cancel(String id) =>
      advance(id, InvoiceStatus.cancelled);

  InvoiceStatus? _preferredNextStatus(
    InvoiceStatus current,
    Set<InvoiceStatus> allowed,
  ) {
    final forward =
        InvoiceStatusTransitions.forwardTransitions[current] ?? const {};
    for (final candidate in forward) {
      if (allowed.contains(candidate)) return candidate;
    }
    return null;
  }

  String? _blockReason({
    required InvoiceStatus status,
    required bool canIssue,
    required bool canMarkPaid,
    required bool canCancel,
    required bool isFinal,
  }) {
    if (status == InvoiceStatus.paid) {
      return 'Faturamento já está pago';
    }
    if (status == InvoiceStatus.cancelled) {
      return 'Faturamento cancelado';
    }
    if (status == InvoiceStatus.draft && !canMarkPaid) {
      return 'Emissão necessária antes do pagamento';
    }
    if (status == InvoiceStatus.issued && !canIssue && canMarkPaid) {
      return null;
    }
    if (!canIssue && !canMarkPaid && !canCancel && isFinal) {
      return 'Estado final — nenhuma transição disponível';
    }
    return null;
  }
}
