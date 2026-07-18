import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:eventpro/features/billing/models/invoice_type.dart';
import 'package:eventpro/features/billing/providers/invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'billing_test_helpers.dart';

void main() {
  testWidgets('shows empty state when there are no invoices', (tester) async {
    await pumpBillingApp(tester);

    expect(find.text('Nenhum faturamento encontrado'), findsOneWidget);
    expect(find.byKey(const Key('invoice_summary_draft')), findsOneWidget);
  });

  testWidgets('shows summary cards and invoice list', (tester) async {
    await pumpBillingApp(
      tester,
      invoices: [
        buildTestInvoice(
          id: 'i-1',
          invoiceNumber: 'INV-2026-0001',
          status: InvoiceStatus.draft,
        ),
        buildTestInvoice(
          id: 'i-2',
          invoiceNumber: 'INV-2026-0002',
          status: InvoiceStatus.issued,
          issueDate: DateTime(2026, 7, 16),
        ),
      ],
    );

    expect(find.byKey(const Key('invoice_summary_draft')), findsOneWidget);
    expect(find.byKey(const Key('invoice_summary_issued')), findsOneWidget);
    expect(find.byKey(const Key('invoices_scroll')), findsOneWidget);
    expect(find.text('INV-2026-0001'), findsOneWidget);
    expect(find.text('INV-2026-0002'), findsOneWidget);
  });

  testWidgets('filters invoices by number query', (tester) async {
    await pumpBillingApp(
      tester,
      invoices: [
        buildTestInvoice(id: 'i-1', invoiceNumber: 'INV-2026-0001'),
        buildTestInvoice(id: 'i-2', invoiceNumber: 'INV-2026-0099'),
      ],
    );

    await tester.enterText(
      find.byKey(const Key('invoice_filter_number')),
      '0099',
    );
    await tester.pumpAndSettle();

    expect(find.text('INV-2026-0099'), findsOneWidget);
    expect(find.text('INV-2026-0001'), findsNothing);
  });

  testWidgets('opens invoice detail from list item', (tester) async {
    await pumpBillingApp(
      tester,
      invoices: [
        buildTestInvoice(
          id: 'i-1',
          invoiceNumber: 'INV-2026-0001',
          status: InvoiceStatus.issued,
          issueDate: DateTime(2026, 7, 16),
        ),
      ],
      items: [
        buildTestInvoiceItem(invoiceId: 'i-1'),
      ],
    );

    await tester.tap(find.byKey(const Key('invoice_list_item_i-1')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('invoice_detail_card')), findsOneWidget);
    expect(find.text('INV-2026-0001'), findsWidgets);
  });

  testWidgets('creates invoice from new screen', (tester) async {
    final container = await pumpBillingApp(
      tester,
      quotes: [buildTestQuote()],
      initialLocation: '/invoices/new',
    );

    await tester.enterText(
      find.byKey(const Key('invoice_form_quote_id')),
      'quote-1',
    );
    await tester.enterText(
      find.byKey(const Key('invoice_form_description')),
      'Som',
    );
    await tester.enterText(
      find.byKey(const Key('invoice_form_quantity')),
      '1',
    );
    await tester.enterText(
      find.byKey(const Key('invoice_form_unit_price')),
      '100,00',
    );
    await tester.tap(find.byKey(const Key('invoice_form_save')));
    await tester.pumpAndSettle();

    final invoices = container.read(invoiceProvider).value!;
    expect(invoices, hasLength(1));
    expect(invoices.single.status, InvoiceStatus.draft);
    expect(invoices.single.type, InvoiceType.service);
  });
}
