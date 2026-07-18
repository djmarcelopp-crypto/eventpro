import 'invoice.dart';
import 'invoice_status.dart';

/// Explicit, read-only financial view of invoices for a quote.
///
/// Derived solely from [Invoice] rows — does not read or write
/// [FinancialEntry], and does not duplicate persisted financial totals.
/// Prepared for a future reconciliation between billing and Financeiro.
class InvoiceFinancialSummary {
  const InvoiceFinancialSummary({
    required this.quoteId,
    required this.invoiceCount,
    required this.draftCount,
    required this.issuedCount,
    required this.paidCount,
    required this.cancelledCount,
    required this.totalBilledCents,
    required this.totalPaidCents,
    required this.totalPendingCents,
    required this.totalCancelledCents,
    required this.totalDraftCents,
  });

  factory InvoiceFinancialSummary.fromInvoices({
    required String quoteId,
    required List<Invoice> invoices,
  }) {
    var draftCount = 0;
    var issuedCount = 0;
    var paidCount = 0;
    var cancelledCount = 0;
    var totalBilledCents = 0;
    var totalPaidCents = 0;
    var totalPendingCents = 0;
    var totalCancelledCents = 0;
    var totalDraftCents = 0;

    for (final invoice in invoices) {
      switch (invoice.status) {
        case InvoiceStatus.draft:
          draftCount++;
          totalDraftCents += invoice.totalCents;
          totalBilledCents += invoice.totalCents;
        case InvoiceStatus.issued:
          issuedCount++;
          totalPendingCents += invoice.totalCents;
          totalBilledCents += invoice.totalCents;
        case InvoiceStatus.paid:
          paidCount++;
          totalPaidCents += invoice.totalCents;
          totalBilledCents += invoice.totalCents;
        case InvoiceStatus.cancelled:
          cancelledCount++;
          totalCancelledCents += invoice.totalCents;
      }
    }

    return InvoiceFinancialSummary(
      quoteId: quoteId,
      invoiceCount: invoices.length,
      draftCount: draftCount,
      issuedCount: issuedCount,
      paidCount: paidCount,
      cancelledCount: cancelledCount,
      totalBilledCents: totalBilledCents,
      totalPaidCents: totalPaidCents,
      totalPendingCents: totalPendingCents,
      totalCancelledCents: totalCancelledCents,
      totalDraftCents: totalDraftCents,
    );
  }

  static const empty = InvoiceFinancialSummary(
    quoteId: '',
    invoiceCount: 0,
    draftCount: 0,
    issuedCount: 0,
    paidCount: 0,
    cancelledCount: 0,
    totalBilledCents: 0,
    totalPaidCents: 0,
    totalPendingCents: 0,
    totalCancelledCents: 0,
    totalDraftCents: 0,
  );

  final String quoteId;
  final int invoiceCount;
  final int draftCount;
  final int issuedCount;
  final int paidCount;
  final int cancelledCount;

  /// Sum of totals for non-cancelled invoices (draft + issued + paid).
  final int totalBilledCents;

  /// Sum of totals for paid invoices.
  final int totalPaidCents;

  /// Sum of totals for issued (awaiting payment) invoices.
  final int totalPendingCents;

  /// Sum of totals for cancelled invoices (excluded from billed).
  final int totalCancelledCents;

  /// Sum of totals for draft invoices.
  final int totalDraftCents;
}
