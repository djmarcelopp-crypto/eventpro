import 'package:eventpro/features/billing/models/invoice.dart';
import 'package:eventpro/features/billing/models/invoice_financial_summary.dart';
import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:eventpro/features/billing/models/invoice_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InvoiceFinancialSummary', () {
    final now = DateTime(2026, 7, 17);

    Invoice build({
      required String id,
      required InvoiceStatus status,
      required int totalCents,
    }) {
      return Invoice(
        id: id,
        quoteId: 'quote-1',
        invoiceNumber: id,
        type: InvoiceType.service,
        status: status,
        subtotalCents: totalCents,
        taxCents: 0,
        discountCents: 0,
        totalCents: totalCents,
        createdAt: now,
        updatedAt: now,
      );
    }

    test('aggregates billed, paid, pending, cancelled and counts', () {
      final summary = InvoiceFinancialSummary.fromInvoices(
        quoteId: 'quote-1',
        invoices: [
          build(id: 'd', status: InvoiceStatus.draft, totalCents: 100),
          build(id: 'i', status: InvoiceStatus.issued, totalCents: 200),
          build(id: 'p', status: InvoiceStatus.paid, totalCents: 300),
          build(id: 'c', status: InvoiceStatus.cancelled, totalCents: 400),
        ],
      );

      expect(summary.invoiceCount, 4);
      expect(summary.draftCount, 1);
      expect(summary.issuedCount, 1);
      expect(summary.paidCount, 1);
      expect(summary.cancelledCount, 1);
      expect(summary.totalDraftCents, 100);
      expect(summary.totalPendingCents, 200);
      expect(summary.totalPaidCents, 300);
      expect(summary.totalCancelledCents, 400);
      expect(summary.totalBilledCents, 600);
    });
  });
}
