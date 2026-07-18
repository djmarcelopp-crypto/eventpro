import 'package:eventpro/features/billing/models/invoice.dart';
import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:eventpro/features/billing/models/invoice_type.dart';
import 'package:eventpro/features/billing/utils/invoice_financial_summary_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_invoice_repository.dart';

void main() {
  test('InvoiceFinancialSummaryService loads by quoteId', () async {
    final now = DateTime(2026, 7, 17);
    final repository = FakeInvoiceRepository(
      initialInvoices: [
        Invoice(
          id: 'inv-1',
          quoteId: 'quote-1',
          invoiceNumber: 'INV-1',
          type: InvoiceType.service,
          status: InvoiceStatus.issued,
          subtotalCents: 1000,
          taxCents: 0,
          discountCents: 0,
          totalCents: 1000,
          createdAt: now,
          updatedAt: now,
        ),
        Invoice(
          id: 'inv-2',
          quoteId: 'quote-2',
          invoiceNumber: 'INV-2',
          type: InvoiceType.service,
          status: InvoiceStatus.paid,
          subtotalCents: 500,
          taxCents: 0,
          discountCents: 0,
          totalCents: 500,
          createdAt: now,
          updatedAt: now,
        ),
      ],
    );

    final service = InvoiceFinancialSummaryService(
      invoiceRepository: repository,
    );
    final summary = await service.forQuote('quote-1');

    expect(summary.quoteId, 'quote-1');
    expect(summary.invoiceCount, 1);
    expect(summary.totalPendingCents, 1000);
    expect(summary.totalPaidCents, 0);
  });
}
