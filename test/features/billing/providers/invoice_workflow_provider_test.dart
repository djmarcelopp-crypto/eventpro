import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:eventpro/features/billing/providers/invoice_provider.dart';
import 'package:eventpro/features/billing/providers/invoice_workflow_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../quotes/fakes/fake_quote_repository.dart';
import '../billing_test_helpers.dart';
import '../fakes/billing_repository_test_overrides.dart';
import '../fakes/fake_invoice_item_repository.dart';
import '../fakes/fake_invoice_repository.dart';

void main() {
  test('invoiceWorkflowSummaryProvider reflects transitions via notifier',
      () async {
    final container = ProviderContainer(
      overrides: billingRepositoryOverrides(
        invoiceRepository: FakeInvoiceRepository(
          initialInvoices: [
            buildTestInvoice(status: InvoiceStatus.draft),
          ],
        ),
        itemRepository: FakeInvoiceItemRepository(),
        quoteRepository: FakeQuoteRepository(
          initialQuotes: [buildTestQuote()],
        ),
        clock: () => DateTime(2026, 7, 17, 12),
      ),
    );
    addTearDown(container.dispose);

    await container.read(invoiceProvider.future);

    var summary =
        container.read(invoiceWorkflowSummaryProvider('invoice-1')).value!;
    expect(summary.canIssue, isTrue);
    expect(summary.canMarkPaid, isFalse);

    final issued =
        await container.read(invoiceProvider.notifier).issueInvoice('invoice-1');
    expect(issued.isSuccess, isTrue);

    summary =
        container.read(invoiceWorkflowSummaryProvider('invoice-1')).value!;
    expect(summary.canIssue, isFalse);
    expect(summary.canMarkPaid, isTrue);
    expect(summary.canCancel, isTrue);
    expect(summary.nextStatus, InvoiceStatus.paid);
  });
}
