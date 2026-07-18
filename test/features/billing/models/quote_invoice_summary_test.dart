import 'package:eventpro/features/billing/models/invoice.dart';
import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:eventpro/features/billing/models/invoice_type.dart';
import 'package:eventpro/features/billing/models/quote_invoice_summary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuoteInvoiceSummary', () {
    final now = DateTime(2026, 7, 17);

    Invoice buildInvoice({
      required String id,
      required InvoiceStatus status,
      required int totalCents,
      DateTime? createdAt,
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
        createdAt: createdAt ?? now,
        updatedAt: now,
      );
    }

    test('aggregates latest status and paid/cancellable flags', () {
      final summary = QuoteInvoiceSummary(
        quoteId: 'quote-1',
        invoices: [
          buildInvoice(
            id: 'inv-2',
            status: InvoiceStatus.issued,
            totalCents: 2000,
            createdAt: now.add(const Duration(hours: 1)),
          ),
          buildInvoice(
            id: 'inv-1',
            status: InvoiceStatus.paid,
            totalCents: 1000,
          ),
        ],
      );

      expect(summary.invoiceCount, 2);
      expect(summary.latestStatus, InvoiceStatus.issued);
      expect(summary.hasPaid, isTrue);
      expect(summary.hasCancellable, isTrue);
      expect(summary.totalBilledCents, 3000);
      expect(summary.totalPaidCents, 1000);
    });

    test('empty quote has null status', () {
      final summary = QuoteInvoiceSummary(quoteId: 'quote-1', invoices: const []);
      expect(summary.hasInvoices, isFalse);
      expect(summary.latestStatus, isNull);
    });
  });
}
