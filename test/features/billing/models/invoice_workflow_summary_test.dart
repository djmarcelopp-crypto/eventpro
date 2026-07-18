import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:eventpro/features/billing/models/invoice_workflow_summary.dart';
import 'package:flutter_test/flutter_test.dart';

import '../billing_test_helpers.dart';

void main() {
  test('exposes helpers for allowed and final states', () {
    final invoice = buildTestInvoice(status: InvoiceStatus.issued);
    final summary = InvoiceWorkflowSummary(
      invoice: invoice,
      allowedNextStatuses: {
        InvoiceStatus.paid,
        InvoiceStatus.cancelled,
      },
      canIssue: false,
      canMarkPaid: true,
      canCancel: true,
      isFinal: false,
      nextStatus: InvoiceStatus.paid,
    );

    expect(summary.currentStatus, InvoiceStatus.issued);
    expect(summary.allows(InvoiceStatus.paid), isTrue);
    expect(summary.allows(InvoiceStatus.draft), isFalse);
    expect(summary.isFinal, isFalse);
    expect(summary.nextStatus, InvoiceStatus.paid);
  });

  test('final when paid or cancelled', () {
    for (final status in [InvoiceStatus.paid, InvoiceStatus.cancelled]) {
      final summary = InvoiceWorkflowSummary(
        invoice: buildTestInvoice(status: status),
        allowedNextStatuses: const {},
        canIssue: false,
        canMarkPaid: false,
        canCancel: false,
        isFinal: true,
        blockReason: status == InvoiceStatus.paid
            ? 'Faturamento já está pago'
            : 'Faturamento cancelado',
      );
      expect(summary.isFinal, isTrue);
      expect(summary.blockReason, isNotNull);
    }
  });
}
