import 'package:eventpro/features/billing/models/invoice_item_input.dart';
import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:eventpro/features/billing/models/invoice_type.dart';
import 'package:eventpro/features/billing/utils/invoice_service.dart';
import 'package:eventpro/features/billing/utils/invoice_status_transitions.dart';
import 'package:eventpro/features/billing/utils/invoice_workflow_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../quotes/fakes/fake_quote_repository.dart';
import '../billing_test_helpers.dart';
import '../fakes/fake_invoice_item_repository.dart';
import '../fakes/fake_invoice_repository.dart';

void main() {
  late FakeInvoiceRepository invoiceRepository;
  late FakeInvoiceItemRepository itemRepository;
  late FakeQuoteRepository quoteRepository;
  late InvoiceService invoiceService;
  late InvoiceWorkflowService workflow;
  final now = DateTime(2026, 7, 17, 12);

  setUp(() {
    invoiceRepository = FakeInvoiceRepository();
    itemRepository = FakeInvoiceItemRepository();
    quoteRepository = FakeQuoteRepository(initialQuotes: [buildTestQuote()]);
    invoiceService = InvoiceService(
      invoiceRepository: invoiceRepository,
      itemRepository: itemRepository,
      quoteRepository: quoteRepository,
      clock: () => now,
    );
    workflow = InvoiceWorkflowService(
      invoiceService: invoiceService,
      invoiceRepository: invoiceRepository,
    );
  });

  group('delegates matrix to InvoiceStatusTransitions', () {
    test('mirrors canTransition and wouldRegress', () {
      for (final from in InvoiceStatus.values) {
        for (final to in InvoiceStatus.values) {
          expect(
            workflow.canTransition(from, to),
            InvoiceStatusTransitions.canTransition(from, to),
          );
          expect(
            workflow.wouldRegress(from, to),
            InvoiceStatusTransitions.wouldRegress(from, to),
          );
        }
      }
    });
  });

  group('summarize', () {
    test('draft can issue and cancel', () {
      final summary = workflow.summarize(
        buildTestInvoice(status: InvoiceStatus.draft),
      );
      expect(summary.canIssue, isTrue);
      expect(summary.canMarkPaid, isFalse);
      expect(summary.canCancel, isTrue);
      expect(summary.isFinal, isFalse);
      expect(summary.nextStatus, InvoiceStatus.issued);
      expect(summary.blockReason, 'Emissão necessária antes do pagamento');
    });

    test('issued can pay and cancel', () {
      final summary = workflow.summarize(
        buildTestInvoice(status: InvoiceStatus.issued),
      );
      expect(summary.canIssue, isFalse);
      expect(summary.canMarkPaid, isTrue);
      expect(summary.canCancel, isTrue);
      expect(summary.nextStatus, InvoiceStatus.paid);
    });

    test('paid and cancelled are final', () {
      final paid = workflow.summarize(
        buildTestInvoice(status: InvoiceStatus.paid),
      );
      expect(paid.isFinal, isTrue);
      expect(paid.canIssue, isFalse);
      expect(paid.canMarkPaid, isFalse);
      expect(paid.canCancel, isFalse);
      expect(paid.blockReason, 'Faturamento já está pago');

      final cancelled = workflow.summarize(
        buildTestInvoice(status: InvoiceStatus.cancelled),
      );
      expect(cancelled.isFinal, isTrue);
      expect(cancelled.blockReason, 'Faturamento cancelado');
    });
  });

  group('advance coordination', () {
    test('coordinates draft → issued → paid', () async {
      final created = await invoiceService.create(
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

      final issued = await workflow.issue(created.invoice!.id);
      expect(issued.isSuccess, isTrue);
      expect(issued.invoice!.status, InvoiceStatus.issued);

      final paid = await workflow.markPaid(created.invoice!.id);
      expect(paid.isSuccess, isTrue);
      expect(paid.invoice!.status, InvoiceStatus.paid);
    });

    test('blocks repeated and regressive transitions', () async {
      final created = await invoiceService.create(
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
      final issued = await workflow.issue(created.invoice!.id);
      expect(issued.isSuccess, isTrue);

      final again = await workflow.issue(created.invoice!.id);
      expect(again.isSuccess, isFalse);

      final regress = await workflow.advance(
        created.invoice!.id,
        InvoiceStatus.draft,
      );
      expect(regress.isSuccess, isFalse);
    });

    test('cancels from draft and blocks pay on cancelled', () async {
      final created = await invoiceService.create(
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
      final cancelled = await workflow.cancel(created.invoice!.id);
      expect(cancelled.isSuccess, isTrue);
      expect(cancelled.invoice!.status, InvoiceStatus.cancelled);

      final pay = await workflow.markPaid(created.invoice!.id);
      expect(pay.isSuccess, isFalse);
    });
  });
}
