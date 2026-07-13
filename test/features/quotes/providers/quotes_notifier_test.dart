import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';
import 'package:eventpro/features/quotes/providers/quote_clock_provider.dart';
import 'package:eventpro/features/quotes/providers/quotes_provider.dart';
import '../quotes_test_helpers.dart';

void main() {
  group('QuotesNotifier', () {
    late ProviderContainer container;
    final fixedNow = DateTime(2026, 7, 13, 10, 30);

    ProviderContainer createContainer() {
      return ProviderContainer(
        overrides: [
          quoteClockProvider.overrideWithValue(() => fixedNow),
        ],
      );
    }

    setUp(() {
      container = createContainer();
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
      expect(quote.createdAt, fixedNow);
      expect(quote.updatedAt, fixedNow);
    });

    test('addQuote ignora histórico recebido e cria entrada inicial', () {
      final notifier = container.read(quotesProvider.notifier);
      final fakeHistory = [
        QuoteStatusHistoryEntry(
          previousStatus: QuoteStatus.sent,
          newStatus: QuoteStatus.approved,
          changedAt: DateTime(2010, 1, 1),
        ),
      ];

      notifier.addQuote(
        sampleQuoteDraft().copyWith(statusHistory: fakeHistory),
      );

      final quote = container.read(quotesProvider).single;
      expect(quote.statusHistory, hasLength(1));
      expect(quote.statusHistory.single.previousStatus, isNull);
      expect(quote.statusHistory.single.newStatus, QuoteStatus.draft);
      expect(quote.statusHistory.single.changedAt, quote.createdAt);
      expect(quote.statusHistory.single.changedAt, fixedNow);
    });

    test('transitionStatus adiciona histórico e dupla transição inválida não duplica', () {
      final notifier = container.read(quotesProvider.notifier);
      notifier.addQuote(sampleQuoteDraft(id: 'quote-history'));

      expect(
        notifier.transitionStatus('quote-history', QuoteStatus.sent),
        isTrue,
      );
      expect(
        notifier.transitionStatus('quote-history', QuoteStatus.sent),
        isFalse,
      );

      final quote = notifier.findById('quote-history')!;
      expect(quote.statusHistory, hasLength(2));
      expect(quote.statusHistory.last.previousStatus, QuoteStatus.draft);
      expect(quote.statusHistory.last.newStatus, QuoteStatus.sent);
      expect(quote.statusHistory.last.changedAt, fixedNow);
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
        statusHistory: existing.statusHistory,
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
      expect(result.statusHistory, existing.statusHistory);
      expect(result.updatedAt, fixedNow);
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

    test('reabrir aprovado limpa approvedAt e preserva dados', () {
      final notifier = container.read(quotesProvider.notifier);
      notifier.addQuote(sampleQuoteDraft(id: 'quote-reopen'));

      final beforeApproval = notifier.findById('quote-reopen')!;
      notifier.transitionStatus('quote-reopen', QuoteStatus.sent);
      notifier.transitionStatus('quote-reopen', QuoteStatus.approved);

      final approved = notifier.findById('quote-reopen')!;
      expect(approved.approvedAt, fixedNow);
      expect(approved.statusHistory, hasLength(3));

      expect(
        notifier.transitionStatus('quote-reopen', QuoteStatus.draft),
        isTrue,
      );

      final reopened = notifier.findById('quote-reopen')!;
      expect(reopened.status, QuoteStatus.draft);
      expect(reopened.approvedAt, isNull);
      expect(reopened.number, beforeApproval.number);
      expect(reopened.createdAt, beforeApproval.createdAt);
      expect(reopened.items, approved.items);
      expect(reopened.subtotalCents, approved.subtotalCents);
      expect(reopened.discountCents, approved.discountCents);
      expect(reopened.freightCents, approved.freightCents);
      expect(reopened.totalCents, approved.totalCents);
      expect(reopened.notes, approved.notes);
      expect(reopened.statusHistory, hasLength(4));
      expect(reopened.statusHistory[2].previousStatus, QuoteStatus.sent);
      expect(reopened.statusHistory[2].newStatus, QuoteStatus.approved);
      expect(reopened.statusHistory.last.previousStatus, QuoteStatus.approved);
      expect(reopened.statusHistory.last.newStatus, QuoteStatus.draft);
    });

    test('reabrir bloqueado fora de aprovado', () {
      final notifier = container.read(quotesProvider.notifier);
      notifier.addQuote(sampleQuoteDraft(id: 'quote-reopen-blocked'));
      notifier.transitionStatus('quote-reopen-blocked', QuoteStatus.sent);

      expect(
        notifier.transitionStatus('quote-reopen-blocked', QuoteStatus.draft),
        isFalse,
      );
      expect(
        notifier.findById('quote-reopen-blocked')?.status,
        QuoteStatus.sent,
      );
    });

    test('ciclo completo draft → sent → approved → draft → sent → approved', () {
      final t1 = DateTime(2026, 7, 13, 10, 0);
      final t2 = DateTime(2026, 7, 13, 11, 0);
      final t3 = DateTime(2026, 7, 13, 12, 0);
      final t4 = DateTime(2026, 7, 13, 13, 0);
      final t5 = DateTime(2026, 7, 13, 14, 0);
      final t6 = DateTime(2026, 7, 13, 15, 0);

      var currentNow = t1;
      final cycleContainer = ProviderContainer(
        overrides: [
          quoteClockProvider.overrideWithValue(() => currentNow),
        ],
      );
      addTearDown(cycleContainer.dispose);

      final notifier = cycleContainer.read(quotesProvider.notifier);
      notifier.addQuote(sampleQuoteDraft(id: 'quote-cycle'));

      final created = notifier.findById('quote-cycle')!;
      final number = created.number;
      final items = created.items;
      final createdAt = created.createdAt;

      currentNow = t2;
      notifier.transitionStatus('quote-cycle', QuoteStatus.sent);

      currentNow = t3;
      notifier.transitionStatus('quote-cycle', QuoteStatus.approved);
      expect(notifier.findById('quote-cycle')!.approvedAt, t3);

      currentNow = t4;
      notifier.transitionStatus('quote-cycle', QuoteStatus.draft);
      final reopened = notifier.findById('quote-cycle')!;
      expect(reopened.approvedAt, isNull);

      currentNow = t5;
      notifier.transitionStatus('quote-cycle', QuoteStatus.sent);

      currentNow = t6;
      notifier.transitionStatus('quote-cycle', QuoteStatus.approved);
      final finalQuote = notifier.findById('quote-cycle')!;

      expect(finalQuote.approvedAt, t6);
      expect(finalQuote.number, number);
      expect(finalQuote.createdAt, createdAt);
      expect(finalQuote.items, items);
      expect(finalQuote.statusHistory, hasLength(6));
      expect(finalQuote.statusHistory[2].newStatus, QuoteStatus.approved);
      expect(finalQuote.statusHistory[2].changedAt, t3);
      expect(finalQuote.statusHistory[3].previousStatus, QuoteStatus.approved);
      expect(finalQuote.statusHistory[3].newStatus, QuoteStatus.draft);
      expect(finalQuote.statusHistory.last.newStatus, QuoteStatus.approved);
      expect(finalQuote.statusHistory.last.changedAt, t6);
    });
  });
}
