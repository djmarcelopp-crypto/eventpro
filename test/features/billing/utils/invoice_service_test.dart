import 'package:eventpro/features/billing/models/invoice_item_input.dart';
import 'package:eventpro/features/billing/models/invoice_operation_result.dart';
import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:eventpro/features/billing/models/invoice_type.dart';
import 'package:eventpro/features/billing/utils/invoice_service.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../quotes/fakes/fake_quote_repository.dart';
import '../fakes/fake_invoice_item_repository.dart';
import '../fakes/fake_invoice_repository.dart';

void main() {
  group('InvoiceService', () {
    late FakeInvoiceRepository invoiceRepository;
    late FakeInvoiceItemRepository itemRepository;
    late FakeQuoteRepository quoteRepository;
    late InvoiceService service;
    final now = DateTime(2026, 7, 17, 12);

    Quote buildQuote({String id = 'quote-1'}) {
      return Quote(
        id: id,
        number: 'ORC-2026-0001',
        status: QuoteStatus.approved,
        clientSnapshot: const QuoteClientSnapshot(
          sourceClientId: 'c1',
          type: QuoteClientType.individual,
          displayName: 'Cliente',
          phone: '67999990000',
        ),
        eventSnapshot: const QuoteEventSnapshot(name: 'Evento'),
        items: const [],
        subtotalCents: 0,
        discountCents: 0,
        freightCents: 0,
        totalCents: 0,
        statusHistory: [
          QuoteStatusHistoryEntry(
            previousStatus: null,
            newStatus: QuoteStatus.approved,
            changedAt: now,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      );
    }

    setUp(() {
      invoiceRepository = FakeInvoiceRepository();
      itemRepository = FakeInvoiceItemRepository();
      quoteRepository = FakeQuoteRepository(initialQuotes: [buildQuote()]);
      service = InvoiceService(
        invoiceRepository: invoiceRepository,
        itemRepository: itemRepository,
        quoteRepository: quoteRepository,
        clock: () => now,
      );
    });

    const items = [
      InvoiceItemInput(
        description: 'Som',
        quantity: 2,
        unitPriceCents: 5_000,
      ),
    ];

    test('creates draft with computed totals and generated number', () async {
      final result = await service.create(
        quoteId: 'quote-1',
        type: InvoiceType.service,
        items: items,
        taxCents: 1_000,
        discountCents: 500,
      );

      expect(result.isSuccess, isTrue);
      expect(result.invoice!.status, InvoiceStatus.draft);
      expect(result.invoice!.invoiceNumber, 'INV-2026-0001');
      expect(result.invoice!.subtotalCents, 10_000);
      expect(result.invoice!.totalCents, 10_500);
      expect(result.invoice!.createdAt, now);
      expect(await itemRepository.listByInvoiceId(result.invoice!.id), hasLength(1));
    });

    test('rejects missing quote', () async {
      final result = await service.create(
        quoteId: 'missing',
        type: InvoiceType.service,
        items: items,
      );
      expect(result.status, InvoiceOperationStatus.quoteNotFound);
    });

    test('issue / pay happy path preserves createdAt', () async {
      final created = await service.create(
        quoteId: 'quote-1',
        type: InvoiceType.service,
        items: items,
      );
      final issued = await service.issue(created.invoice!.id);
      expect(issued.invoice!.status, InvoiceStatus.issued);
      expect(issued.invoice!.issueDate, now);
      expect(issued.invoice!.createdAt, created.invoice!.createdAt);

      final paid = await service.markPaid(created.invoice!.id);
      expect(paid.invoice!.status, InvoiceStatus.paid);
      expect(paid.invoice!.paidAt, now);
      expect(paid.invoice!.createdAt, created.invoice!.createdAt);
    });

    test('cannot pay cancelled invoice', () async {
      final created = await service.create(
        quoteId: 'quote-1',
        type: InvoiceType.service,
        items: items,
      );
      await service.cancel(created.invoice!.id);
      final paid = await service.markPaid(created.invoice!.id);
      expect(paid.status, InvoiceOperationStatus.cannotPayCancelled);
    });

    test('cannot cancel after payment', () async {
      final created = await service.create(
        quoteId: 'quote-1',
        type: InvoiceType.service,
        items: items,
      );
      await service.issue(created.invoice!.id);
      await service.markPaid(created.invoice!.id);
      final cancelled = await service.cancel(created.invoice!.id);
      expect(cancelled.status, InvoiceOperationStatus.cannotCancelPaid);
    });

    test('rejects invalid transitions', () async {
      final created = await service.create(
        quoteId: 'quote-1',
        type: InvoiceType.service,
        items: items,
      );
      expect(
        (await service.markPaid(created.invoice!.id)).status,
        InvoiceOperationStatus.invalidTransition,
      );
    });

    test('rejects duplicate invoice number', () async {
      await service.create(
        quoteId: 'quote-1',
        type: InvoiceType.service,
        items: items,
        invoiceNumber: 'INV-CUSTOM',
      );
      final duplicate = await service.create(
        quoteId: 'quote-1',
        type: InvoiceType.service,
        items: items,
        invoiceNumber: 'inv-custom',
      );
      expect(duplicate.status, InvoiceOperationStatus.duplicateNumber);
    });

    test('omitted or blank invoiceNumber auto-generates INV-YYYY-####', () async {
      final omitted = await service.create(
        quoteId: 'quote-1',
        type: InvoiceType.service,
        items: items,
      );
      final blank = await service.create(
        quoteId: 'quote-1',
        type: InvoiceType.service,
        items: items,
        invoiceNumber: '   ',
      );

      expect(omitted.invoice!.invoiceNumber, 'INV-2026-0001');
      expect(blank.invoice!.invoiceNumber, 'INV-2026-0002');
    });

    test('auto sequence skips past existing manual INV-YYYY-#### numbers',
        () async {
      await service.create(
        quoteId: 'quote-1',
        type: InvoiceType.service,
        items: items,
        invoiceNumber: 'inv-2026-0005',
      );
      final next = await service.create(
        quoteId: 'quote-1',
        type: InvoiceType.service,
        items: items,
      );
      expect(next.invoice!.invoiceNumber, 'INV-2026-0006');
    });

    test('rejects invalid item quantity before writing', () async {
      final result = await service.create(
        quoteId: 'quote-1',
        type: InvoiceType.service,
        items: const [
          InvoiceItemInput(
            description: 'Som',
            quantity: 0,
            unitPriceCents: 1000,
          ),
        ],
      );
      expect(result.status, InvoiceOperationStatus.validationFailed);
      expect(await invoiceRepository.listAll(), isEmpty);
    });

    test('rolls back invoice when item insert fails mid-operation', () async {
      itemRepository.shouldFailOnNextOperation = true;
      final result = await service.create(
        quoteId: 'quote-1',
        type: InvoiceType.service,
        items: items,
      );
      expect(result.status, InvoiceOperationStatus.failure);
      expect(await invoiceRepository.listAll(), isEmpty);
      expect(await itemRepository.listAll(), isEmpty);
    });

    test('cannot re-issue paid or cancelled invoices', () async {
      final created = await service.create(
        quoteId: 'quote-1',
        type: InvoiceType.service,
        items: items,
      );
      await service.issue(created.invoice!.id);
      await service.markPaid(created.invoice!.id);
      expect(
        (await service.issue(created.invoice!.id)).status,
        InvoiceOperationStatus.invalidTransition,
      );

      final other = await service.create(
        quoteId: 'quote-1',
        type: InvoiceType.service,
        items: items,
      );
      await service.cancel(other.invoice!.id);
      expect(
        (await service.issue(other.invoice!.id)).status,
        InvoiceOperationStatus.invalidTransition,
      );
    });
  });
}
