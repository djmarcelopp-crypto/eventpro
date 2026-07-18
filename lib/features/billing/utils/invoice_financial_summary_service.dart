import '../data/repositories/invoice_repository.dart';
import '../models/invoice_financial_summary.dart';

/// Builds [InvoiceFinancialSummary] from persisted invoices.
///
/// Decoupled financial integration for billing ↔ Financeiro (shared quoteId),
/// without creating or mutating FinancialEntry records.
class InvoiceFinancialSummaryService {
  InvoiceFinancialSummaryService({required InvoiceRepository invoiceRepository})
      : _invoiceRepository = invoiceRepository;

  final InvoiceRepository _invoiceRepository;

  Future<InvoiceFinancialSummary> forQuote(String quoteId) async {
    final invoices = await _invoiceRepository.listByQuoteId(quoteId);
    return InvoiceFinancialSummary.fromInvoices(
      quoteId: quoteId,
      invoices: invoices,
    );
  }
}
