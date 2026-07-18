import '../models/invoice_item_input.dart';
import '../models/invoice_operation_result.dart';
import '../models/invoice_status.dart';
import '../models/invoice_type.dart';
import '../models/quote_invoice_summary.dart';
import 'invoice_service.dart';

/// Quote-scoped invoice operations (generate / status / pay / cancel).
///
/// Delegates all status transitions to [InvoiceService] /
/// [InvoiceStatusTransitions] — does not maintain its own matrix.
/// Financial aggregation for Financeiro lives in
/// [InvoiceFinancialSummaryService].
class QuoteInvoiceService {
  QuoteInvoiceService({required InvoiceService invoiceService})
      : _invoiceService = invoiceService;

  final InvoiceService _invoiceService;

  Future<QuoteInvoiceSummary> summaryForQuote(String quoteId) async {
    final invoices = await _invoiceService.listByQuoteId(quoteId);
    final newestFirst = [...invoices]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return QuoteInvoiceSummary(quoteId: quoteId, invoices: newestFirst);
  }

  Future<InvoiceStatus?> statusForQuote(String quoteId) async {
    final summary = await summaryForQuote(quoteId);
    return summary.latestStatus;
  }

  /// Creates a draft invoice for the quote and immediately issues it.
  Future<InvoiceOperationResult> generateForQuote({
    required String quoteId,
    required List<InvoiceItemInput> items,
    InvoiceType type = InvoiceType.service,
    String? invoiceNumber,
    int taxCents = 0,
    int discountCents = 0,
    String notes = '',
    DateTime? dueDate,
  }) async {
    final created = await _invoiceService.create(
      quoteId: quoteId,
      type: type,
      items: items,
      invoiceNumber: invoiceNumber,
      taxCents: taxCents,
      discountCents: discountCents,
      notes: notes,
      dueDate: dueDate,
    );
    if (!created.isSuccess || created.invoice == null) {
      return created;
    }
    return _invoiceService.issue(created.invoice!.id);
  }

  Future<InvoiceOperationResult> registerPayment(String invoiceId) {
    return _invoiceService.markPaid(invoiceId);
  }

  Future<InvoiceOperationResult> cancelInvoice(String invoiceId) {
    return _invoiceService.cancel(invoiceId);
  }
}
