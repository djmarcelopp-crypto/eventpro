import 'package:eventpro/features/billing/models/invoice_list_summary.dart';
import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:flutter_test/flutter_test.dart';

import '../billing_test_helpers.dart';

void main() {
  test('InvoiceListSummary aggregates statuses and money totals', () {
    final summary = InvoiceListSummary.fromInvoices([
      buildTestInvoice(
        id: 'd',
        status: InvoiceStatus.draft,
        totalCents: 1000,
      ),
      buildTestInvoice(
        id: 'i',
        status: InvoiceStatus.issued,
        totalCents: 2000,
      ),
      buildTestInvoice(
        id: 'p',
        status: InvoiceStatus.paid,
        totalCents: 3000,
      ),
      buildTestInvoice(
        id: 'c',
        status: InvoiceStatus.cancelled,
        totalCents: 4000,
      ),
    ]);

    expect(summary.draft, 1);
    expect(summary.issued, 1);
    expect(summary.paid, 1);
    expect(summary.cancelled, 1);
    expect(summary.totalBilledCents, 6000);
    expect(summary.totalPaidCents, 3000);
    expect(summary.totalPendingCents, 2000);
  });
}
