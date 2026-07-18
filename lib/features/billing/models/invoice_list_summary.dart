import 'invoice.dart';
import 'invoice_status.dart';

/// Aggregate counters for the invoices list / dashboard.
class InvoiceListSummary {
  const InvoiceListSummary({
    required this.total,
    required this.draft,
    required this.issued,
    required this.paid,
    required this.cancelled,
    required this.totalBilledCents,
    required this.totalPaidCents,
    required this.totalPendingCents,
  });

  factory InvoiceListSummary.fromInvoices(List<Invoice> invoices) {
    var draft = 0;
    var issued = 0;
    var paid = 0;
    var cancelled = 0;
    var totalBilledCents = 0;
    var totalPaidCents = 0;
    var totalPendingCents = 0;

    for (final invoice in invoices) {
      switch (invoice.status) {
        case InvoiceStatus.draft:
          draft++;
          totalBilledCents += invoice.totalCents;
        case InvoiceStatus.issued:
          issued++;
          totalBilledCents += invoice.totalCents;
          totalPendingCents += invoice.totalCents;
        case InvoiceStatus.paid:
          paid++;
          totalBilledCents += invoice.totalCents;
          totalPaidCents += invoice.totalCents;
        case InvoiceStatus.cancelled:
          cancelled++;
      }
    }

    return InvoiceListSummary(
      total: invoices.length,
      draft: draft,
      issued: issued,
      paid: paid,
      cancelled: cancelled,
      totalBilledCents: totalBilledCents,
      totalPaidCents: totalPaidCents,
      totalPendingCents: totalPendingCents,
    );
  }

  static const empty = InvoiceListSummary(
    total: 0,
    draft: 0,
    issued: 0,
    paid: 0,
    cancelled: 0,
    totalBilledCents: 0,
    totalPaidCents: 0,
    totalPendingCents: 0,
  );

  final int total;
  final int draft;
  final int issued;
  final int paid;
  final int cancelled;
  final int totalBilledCents;
  final int totalPaidCents;
  final int totalPendingCents;
}
