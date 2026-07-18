import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:eventpro/features/billing/providers/invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'billing_test_helpers.dart';

void main() {
  testWidgets('issues draft invoice from detail actions', (tester) async {
    final container = await pumpBillingApp(
      tester,
      invoices: [
        buildTestInvoice(
          id: 'i-1',
          invoiceNumber: 'INV-2026-0001',
          status: InvoiceStatus.draft,
        ),
      ],
      items: [buildTestInvoiceItem(invoiceId: 'i-1')],
      initialLocation: '/invoices/i-1',
    );

    expect(find.byKey(const Key('invoice_detail_issue')), findsOneWidget);
    expect(find.byKey(const Key('invoice_detail_mark_paid')), findsNothing);

    await tester.tap(find.byKey(const Key('invoice_detail_issue')));
    await tester.pumpAndSettle();

    final invoices = container.read(invoiceProvider).value!;
    expect(invoices.single.status, InvoiceStatus.issued);
  });

  testWidgets('cancels issued invoice from detail', (tester) async {
    final container = await pumpBillingApp(
      tester,
      invoices: [
        buildTestInvoice(
          id: 'i-1',
          invoiceNumber: 'INV-2026-0001',
          status: InvoiceStatus.issued,
          issueDate: DateTime(2026, 7, 16),
        ),
      ],
      items: [buildTestInvoiceItem(invoiceId: 'i-1')],
      initialLocation: '/invoices/i-1',
    );

    await tester.tap(find.byKey(const Key('invoice_detail_cancel')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('invoice_cancel_confirm')));
    await tester.pumpAndSettle();

    final invoices = container.read(invoiceProvider).value!;
    expect(invoices.single.status, InvoiceStatus.cancelled);
  });
}
