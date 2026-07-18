import 'package:eventpro/features/billing/models/invoice_item_input.dart';
import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:eventpro/features/billing/models/invoice_type.dart';
import 'package:eventpro/features/billing/utils/invoice_service.dart';
import 'package:eventpro/features/billing/utils/quote_invoice_service.dart';
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
  group('QuoteInvoiceService', () {
    late QuoteInvoiceService service;
    final now = DateTime(2026, 7, 17, 12);

    setUp(() {
      final invoiceRepository = FakeInvoiceRepository();
      final itemRepository = FakeInvoiceItemRepository();
      final quoteRepository = FakeQuoteRepository(
        initialQuotes: [
          Quote(
            id: 'quote-1',
            number: 'ORC-1',
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
          ),
        ],
      );
      final invoiceService = InvoiceService(
        invoiceRepository: invoiceRepository,
        itemRepository: itemRepository,
        quoteRepository: quoteRepository,
        clock: () => now,
      );
      service = QuoteInvoiceService(invoiceService: invoiceService);
    });

    test('generateForQuote issues invoice and exposes status', () async {
      final result = await service.generateForQuote(
        quoteId: 'quote-1',
        type: InvoiceType.service,
        items: const [
          InvoiceItemInput(
            description: 'Som',
            quantity: 1,
            unitPriceCents: 10_000,
          ),
        ],
      );

      expect(result.isSuccess, isTrue);
      expect(result.invoice!.status, InvoiceStatus.issued);
      expect(await service.statusForQuote('quote-1'), InvoiceStatus.issued);

      final summary = await service.summaryForQuote('quote-1');
      expect(summary.invoiceCount, 1);
      expect(summary.totalBilledCents, 10_000);
      expect(summary.hasCancellable, isTrue);
    });

    test('registerPayment and cancelInvoice update summary', () async {
      final generated = await service.generateForQuote(
        quoteId: 'quote-1',
        items: const [
          InvoiceItemInput(
            description: 'Som',
            quantity: 1,
            unitPriceCents: 10_000,
          ),
        ],
      );

      final paid = await service.registerPayment(generated.invoice!.id);
      expect(paid.invoice!.status, InvoiceStatus.paid);

      var summary = await service.summaryForQuote('quote-1');
      expect(summary.hasPaid, isTrue);
      expect(summary.totalPaidCents, 10_000);
      expect(summary.hasCancellable, isFalse);

      final second = await service.generateForQuote(
        quoteId: 'quote-1',
        items: const [
          InvoiceItemInput(
            description: 'Luz',
            quantity: 1,
            unitPriceCents: 2_000,
          ),
        ],
      );
      final cancelled = await service.cancelInvoice(second.invoice!.id);
      expect(cancelled.invoice!.status, InvoiceStatus.cancelled);

      summary = await service.summaryForQuote('quote-1');
      expect(summary.totalBilledCents, 10_000);
    });

    test('empty quote has null status', () async {
      expect(await service.statusForQuote('quote-1'), isNull);
    });
  });
}
