import 'invoice.dart';
import 'invoice_status.dart';

/// Operational invoice list for a quote (latest status / cancellability).
///
/// For Financeiro-oriented totals use [InvoiceFinancialSummary] instead.
class QuoteInvoiceSummary {
  QuoteInvoiceSummary({
    required this.quoteId,
    required List<Invoice> invoices,
  }) : invoices = List.unmodifiable(invoices);

  final String quoteId;
  final List<Invoice> invoices;

  int get invoiceCount => invoices.length;

  bool get hasInvoices => invoices.isNotEmpty;

  /// Most recently created invoice, if any.
  Invoice? get latestInvoice => invoices.isEmpty ? null : invoices.first;

  InvoiceStatus? get latestStatus => latestInvoice?.status;

  bool get hasPaid =>
      invoices.any((invoice) => invoice.status == InvoiceStatus.paid);

  bool get hasCancellable => invoices.any(
        (invoice) =>
            invoice.status != InvoiceStatus.paid &&
            invoice.status != InvoiceStatus.cancelled,
      );

  int get totalBilledCents => invoices
      .where((invoice) => invoice.status != InvoiceStatus.cancelled)
      .fold<int>(0, (sum, invoice) => sum + invoice.totalCents);

  int get totalPaidCents => invoices
      .where((invoice) => invoice.status == InvoiceStatus.paid)
      .fold<int>(0, (sum, invoice) => sum + invoice.totalCents);
}
