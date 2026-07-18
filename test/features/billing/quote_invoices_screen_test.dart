import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:eventpro/features/billing/providers/quote_invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'billing_test_helpers.dart';

void main() {
  testWidgets('shows empty quote invoices and generates one', (tester) async {
    final container = await pumpBillingApp(
      tester,
      initialLocation: '/quotes/quote-1/invoices',
      quotes: [buildTestQuote()],
      invoices: const [],
    );

    expect(find.textContaining('Nenhum faturamento'), findsOneWidget);

    await tester.tap(find.byKey(const Key('quote_invoice_generate')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('quote_invoice_form_description')),
      'Som',
    );
    await tester.enterText(
      find.byKey(const Key('quote_invoice_form_quantity')),
      '1',
    );
    await tester.enterText(
      find.byKey(const Key('quote_invoice_form_price')),
      '150,00',
    );
    await tester.tap(find.byKey(const Key('quote_invoice_form_save')));
    await tester.pumpAndSettle();

    final items = container.read(quoteInvoiceProvider('quote-1')).value!;
    expect(items, hasLength(1));
    expect(items.single.status, InvoiceStatus.issued);
    expect(
      find.byKey(const Key('quote_invoice_summary_status')),
      findsOneWidget,
    );
  });

  testWidgets('registers payment via quote invoices', (tester) async {
    final container = await pumpBillingApp(
      tester,
      initialLocation: '/quotes/quote-1/invoices',
      quotes: [buildTestQuote()],
      invoices: [
        buildTestInvoice(
          id: 'i-1',
          quoteId: 'quote-1',
          status: InvoiceStatus.issued,
          issueDate: DateTime(2026, 7, 16),
        ),
      ],
    );

    await tester.tap(find.byKey(const Key('quote_invoice_pay_i-1')));
    await tester.pumpAndSettle();

    final items = container.read(quoteInvoiceProvider('quote-1')).value!;
    expect(items.single.status, InvoiceStatus.paid);
  });

  testWidgets('cancels via quote invoices', (tester) async {
    final container = await pumpBillingApp(
      tester,
      initialLocation: '/quotes/quote-1/invoices',
      quotes: [buildTestQuote()],
      invoices: [
        buildTestInvoice(
          id: 'i-2',
          quoteId: 'quote-1',
          invoiceNumber: 'INV-2026-0002',
          status: InvoiceStatus.issued,
          issueDate: DateTime(2026, 7, 16),
        ),
      ],
    );

    await tester.tap(find.byKey(const Key('quote_invoice_cancel_i-2')));
    await tester.pumpAndSettle();

    final items = container.read(quoteInvoiceProvider('quote-1')).value!;
    expect(items.single.status, InvoiceStatus.cancelled);
  });
}
