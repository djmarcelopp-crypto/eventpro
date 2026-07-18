import 'package:eventpro/features/billing/models/invoice_item_input.dart';
import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:eventpro/features/billing/models/invoice_type.dart';
import 'package:eventpro/features/billing/providers/filtered_invoices_provider.dart';
import 'package:eventpro/features/billing/providers/invoice_filters_provider.dart';
import 'package:eventpro/features/billing/providers/invoice_list_summary_provider.dart';
import 'package:eventpro/features/billing/providers/invoice_provider.dart';
import 'package:eventpro/features/billing/providers/invoice_workflow_provider.dart';
import 'package:eventpro/features/billing/providers/quote_invoice_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../quotes/fakes/fake_quote_repository.dart';
import '../billing_test_helpers.dart';
import '../fakes/billing_repository_test_overrides.dart';
import '../fakes/fake_invoice_item_repository.dart';
import '../fakes/fake_invoice_repository.dart';

void main() {
  group('invoice providers', () {
    final now = DateTime(2026, 7, 17, 12);

    test('loads invoices and action summary flags', () async {
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
          clock: () => now,
        ),
      );
      addTearDown(container.dispose);

      final invoices = await container.read(invoiceProvider.future);
      expect(invoices, hasLength(1));

      final workflow =
          container.read(invoiceWorkflowSummaryProvider('invoice-1')).value!;
      expect(workflow.canIssue, isTrue);
      expect(workflow.canMarkPaid, isFalse);
      expect(workflow.canCancel, isTrue);
      expect(workflow.nextStatus, InvoiceStatus.issued);
    });

    test('creates, issues, pays and filters invoices', () async {
      final container = ProviderContainer(
        overrides: billingRepositoryOverrides(
          invoiceRepository: FakeInvoiceRepository(),
          itemRepository: FakeInvoiceItemRepository(),
          quoteRepository: FakeQuoteRepository(
            initialQuotes: [buildTestQuote()],
          ),
          clock: () => now,
        ),
      );
      addTearDown(container.dispose);

      await container.read(invoiceProvider.future);

      final created = await container.read(invoiceProvider.notifier).createInvoice(
            quoteId: 'quote-1',
            type: InvoiceType.service,
            items: const [
              InvoiceItemInput(
                description: 'Som',
                quantity: 1,
                unitPriceCents: 10000,
              ),
            ],
          );
      expect(created.isSuccess, isTrue);
      expect(created.invoice!.status, InvoiceStatus.draft);

      final issued = await container
          .read(invoiceProvider.notifier)
          .issueInvoice(created.invoice!.id);
      expect(issued.isSuccess, isTrue);
      expect(issued.invoice!.status, InvoiceStatus.issued);

      final paid = await container
          .read(invoiceProvider.notifier)
          .markPaid(created.invoice!.id);
      expect(paid.isSuccess, isTrue);
      expect(paid.invoice!.status, InvoiceStatus.paid);

      container.read(invoiceFiltersProvider.notifier).setStatus(
            InvoiceStatus.paid,
          );
      final filtered = container.read(filteredInvoicesProvider).value!;
      expect(filtered, hasLength(1));
      expect(filtered.single.status, InvoiceStatus.paid);

      final summary = container.read(invoiceListSummaryProvider).value!;
      expect(summary.paid, 1);
      expect(summary.totalPaidCents, paid.invoice!.totalCents);
    });

    test('quoteInvoiceProvider generates issued invoice', () async {
      final container = ProviderContainer(
        overrides: billingRepositoryOverrides(
          invoiceRepository: FakeInvoiceRepository(),
          itemRepository: FakeInvoiceItemRepository(),
          quoteRepository: FakeQuoteRepository(
            initialQuotes: [buildTestQuote()],
          ),
          clock: () => now,
        ),
      );
      addTearDown(container.dispose);

      await container.read(quoteInvoiceProvider('quote-1').future);

      final generated =
          await container.read(quoteInvoiceProvider('quote-1').notifier).generate(
                items: const [
                  InvoiceItemInput(
                    description: 'DJ',
                    quantity: 1,
                    unitPriceCents: 20000,
                  ),
                ],
              );
      expect(generated.isSuccess, isTrue);
      expect(generated.invoice!.status, InvoiceStatus.issued);

      final summary =
          container.read(quoteInvoiceSummaryProvider('quote-1')).value!;
      expect(summary.invoices, hasLength(1));
      expect(summary.latestStatus, InvoiceStatus.issued);
    });
  });
}
