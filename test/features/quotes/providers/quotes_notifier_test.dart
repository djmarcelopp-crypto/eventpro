import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/providers/quotes_provider.dart';
import '../quotes_test_helpers.dart';

void main() {
  group('QuotesNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('inicia com lista vazia', () {
      expect(container.read(quotesProvider), isEmpty);
    });

    test('addQuote força draft, approvedAt null e número gerado', () {
      final notifier = container.read(quotesProvider.notifier);
      notifier.addQuote(sampleQuoteDraft());

      final quote = container.read(quotesProvider).single;
      expect(quote.status, QuoteStatus.draft);
      expect(quote.approvedAt, isNull);
      expect(quote.number, 'ORC-${DateTime.now().year}-0001');
      expect(quote.number, isNot('SHOULD-BE-IGNORED'));
      expect(quote.createdAt, isNot(DateTime(2020, 1, 1)));
    });

    test('findById retorna orçamento existente ou null', () {
      final notifier = container.read(quotesProvider.notifier);
      notifier.addQuote(sampleQuoteDraft(id: 'quote-42'));

      expect(notifier.findById('quote-42')?.id, 'quote-42');
      expect(notifier.findById('missing'), isNull);
    });

    test('updateQuote funciona somente em draft', () {
      final notifier = container.read(quotesProvider.notifier);
      notifier.addQuote(sampleQuoteDraft(id: 'quote-1'));

      final existing = notifier.findById('quote-1')!;
      final updatedDraft = Quote(
        id: existing.id,
        number: 'IGNORED',
        status: QuoteStatus.sent,
        clientSnapshot: QuoteClientSnapshot.fromClient(
          sampleClient(name: 'Cliente atualizado'),
        ),
        eventSnapshot: QuoteEventSnapshot.empty,
        items: [sampleLineItem(quantity: 3)],
        subtotalCents: 0,
        discountCents: 1000,
        freightCents: 500,
        totalCents: 0,
        createdAt: DateTime(2019, 1, 1),
        updatedAt: DateTime(2019, 1, 1),
      );

      expect(notifier.updateQuote(updatedDraft), isTrue);

      final result = notifier.findById('quote-1')!;
      expect(result.status, QuoteStatus.draft);
      expect(result.approvedAt, isNull);
      expect(result.number, existing.number);
      expect(result.createdAt, existing.createdAt);
      expect(result.clientSnapshot.displayName, 'Cliente atualizado');
      expect(result.discountCents, 1000);
      expect(result.items.single.quantity, 3);
    });

    test('updateQuote bloqueado fora de draft', () {
      final notifier = container.read(quotesProvider.notifier);
      notifier.addQuote(sampleQuoteDraft(id: 'quote-2'));
      notifier.transitionStatus('quote-2', QuoteStatus.sent);

      final existing = notifier.findById('quote-2')!;
      final attempt = existing.copyWith(
        notes: 'Tentativa de alteração',
      );

      expect(notifier.updateQuote(attempt), isFalse);
      expect(notifier.findById('quote-2')?.notes, isNull);
    });

    test('transitionStatus é a única forma de alterar status', () {
      final notifier = container.read(quotesProvider.notifier);
      notifier.addQuote(sampleQuoteDraft(id: 'quote-3'));

      expect(
        notifier.transitionStatus('quote-3', QuoteStatus.approved),
        isFalse,
      );
      expect(
        notifier.transitionStatus('quote-3', QuoteStatus.sent),
        isTrue,
      );
      expect(notifier.findById('quote-3')?.status, QuoteStatus.sent);
    });

    test('approvedAt preenchido na aprovação e preservado ao cancelar', () {
      final notifier = container.read(quotesProvider.notifier);
      notifier.addQuote(sampleQuoteDraft(id: 'quote-4'));
      notifier.transitionStatus('quote-4', QuoteStatus.sent);
      notifier.transitionStatus('quote-4', QuoteStatus.approved);

      final approved = notifier.findById('quote-4')!;
      expect(approved.approvedAt, isNotNull);
      expect(approved.isApprovedForContract, isTrue);

      final approvedAt = approved.approvedAt;
      notifier.transitionStatus('quote-4', QuoteStatus.cancelled);

      final cancelled = notifier.findById('quote-4')!;
      expect(cancelled.status, QuoteStatus.cancelled);
      expect(cancelled.approvedAt, approvedAt);
    });
  });
}
