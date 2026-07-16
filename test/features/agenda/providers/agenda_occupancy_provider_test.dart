import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/agenda/models/agenda_block.dart';
import 'package:eventpro/features/agenda/models/agenda_occupancy.dart';
import 'package:eventpro/features/agenda/providers/agenda_block_repository_provider.dart';
import 'package:eventpro/features/agenda/providers/agenda_blocks_provider.dart';
import 'package:eventpro/features/agenda/providers/agenda_occupancy_provider.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/providers/quotes_provider.dart';

import '../../quotes/quotes_test_helpers.dart';
import '../fakes/fake_agenda_block_repository.dart';

AgendaBlock _sampleBlock({
  required String id,
  required String title,
  required DateTime start,
  required DateTime end,
}) {
  return AgendaBlock(
    id: id,
    title: title,
    start: start,
    end: end,
    createdAt: DateTime(2026, 8, 1, 9, 0),
    updatedAt: DateTime(2026, 8, 1, 9, 0),
  );
}

ProviderContainer _createContainer() {
  final container = ProviderContainer(
    overrides: [
      agendaBlockRepositoryProvider.overrideWithValue(
        FakeAgendaBlockRepository(),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('agendaOccupancyProvider', () {
    test('starts empty when there are no quotes or blocks', () async {
      final container = _createContainer();
      await container.read(agendaBlocksProvider.future);

      final occupancy = container.read(agendaOccupancyProvider);

      expect(occupancy.value, isEmpty);
    });

    test(
      'combines proposal/confirmed quotes with manual blocks, sorted by start',
      () async {
        final container = _createContainer();
        await container.read(agendaBlocksProvider.future);

        final approvedQuote = sampleQuoteDraft(
          id: 'quote-approved',
          status: QuoteStatus.approved,
        ).copyWith(
          eventSnapshot: QuoteEventSnapshot(
            name: 'Casamento Ana',
            date: DateTime(2026, 8, 20),
            startTime: '18:00',
            endTime: '23:00',
          ),
        );
        final draftQuote = sampleQuoteDraft(
          id: 'quote-draft',
          status: QuoteStatus.draft,
        ).copyWith(
          eventSnapshot: QuoteEventSnapshot(
            name: 'Aniversário Bia',
            date: DateTime(2026, 8, 10),
            startTime: '14:00',
            endTime: '18:00',
          ),
        );

        container
            .read(quotesProvider.notifier)
            .hydrate([approvedQuote, draftQuote]);
        container.read(agendaBlocksProvider.notifier).hydrate([
          _sampleBlock(
            id: 'block-1',
            title: 'Manutenção do galpão',
            start: DateTime(2026, 8, 15, 8, 0),
            end: DateTime(2026, 8, 15, 12, 0),
          ),
        ]);

        final occupancy = container.read(agendaOccupancyProvider).value!;

        expect(occupancy, hasLength(3));
        expect(
          occupancy.map((item) => item.title).toList(),
          ['Aniversário Bia', 'Manutenção do galpão', 'Casamento Ana'],
        );
        expect(occupancy[0].kind, AgendaOccupancyKind.proposal);
        expect(occupancy[1].kind, AgendaOccupancyKind.block);
        expect(occupancy[2].kind, AgendaOccupancyKind.confirmed);
      },
    );

    test('ignores rejected and cancelled quotes', () async {
      final container = _createContainer();
      await container.read(agendaBlocksProvider.future);

      final rejectedQuote = sampleQuoteDraft(
        id: 'quote-rejected',
        status: QuoteStatus.rejected,
      ).copyWith(
        eventSnapshot: QuoteEventSnapshot(date: DateTime(2026, 8, 20)),
      );
      final cancelledQuote = sampleQuoteDraft(
        id: 'quote-cancelled',
        status: QuoteStatus.cancelled,
      ).copyWith(
        eventSnapshot: QuoteEventSnapshot(date: DateTime(2026, 8, 21)),
      );

      container
          .read(quotesProvider.notifier)
          .hydrate([rejectedQuote, cancelledQuote]);

      final occupancy = container.read(agendaOccupancyProvider).value!;

      expect(occupancy, isEmpty);
    });

    test('ignores quotes without an event date', () async {
      final container = _createContainer();
      await container.read(agendaBlocksProvider.future);

      final quoteWithoutDate = sampleQuoteDraft(status: QuoteStatus.approved);
      container.read(quotesProvider.notifier).hydrate([quoteWithoutDate]);

      final occupancy = container.read(agendaOccupancyProvider).value!;

      expect(occupancy, isEmpty);
    });

    test('recomputes when agenda blocks change', () async {
      final container = _createContainer();
      await container.read(agendaBlocksProvider.future);

      expect(container.read(agendaOccupancyProvider).value, isEmpty);

      container.read(agendaBlocksProvider.notifier).hydrate([
        _sampleBlock(
          id: 'block-1',
          title: 'Bloqueio novo',
          start: DateTime(2026, 8, 15, 8, 0),
          end: DateTime(2026, 8, 15, 12, 0),
        ),
      ]);

      final occupancy = container.read(agendaOccupancyProvider).value!;
      expect(occupancy, hasLength(1));
      expect(occupancy.single.title, 'Bloqueio novo');
    });
  });
}
