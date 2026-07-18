import 'package:eventpro/features/agenda/models/agenda_block.dart';
import 'package:eventpro/features/agenda/models/agenda_occupancy.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../quotes/quotes_test_helpers.dart';

void main() {
  group('AgendaOccupancy.fromQuote', () {
    final eventSnapshot = QuoteEventSnapshot(
      name: 'Casamento Ana',
      date: DateTime(2026, 8, 15),
      startTime: '18:00',
      endTime: '23:00',
    );

    test('draft status maps to proposal', () {
      final quote = sampleQuoteDraft(
        status: QuoteStatus.draft,
      ).copyWith(eventSnapshot: eventSnapshot);

      final occupancy = AgendaOccupancy.fromQuote(quote)!;

      expect(occupancy.kind, AgendaOccupancyKind.proposal);
      expect(occupancy.sourceQuoteId, quote.id);
      expect(occupancy.sourceBlockId, isNull);
      expect(occupancy.title, 'Casamento Ana');
      expect(occupancy.start, DateTime(2026, 8, 15, 18, 0));
      expect(occupancy.end, DateTime(2026, 8, 15, 23, 0));
    });

    test('sent status maps to proposal', () {
      final quote = sampleQuoteDraft(
        status: QuoteStatus.sent,
      ).copyWith(eventSnapshot: eventSnapshot);

      final occupancy = AgendaOccupancy.fromQuote(quote)!;

      expect(occupancy.kind, AgendaOccupancyKind.proposal);
    });

    test('approved status maps to confirmed', () {
      final quote = sampleQuoteDraft(
        status: QuoteStatus.approved,
      ).copyWith(eventSnapshot: eventSnapshot);

      final occupancy = AgendaOccupancy.fromQuote(quote)!;

      expect(occupancy.kind, AgendaOccupancyKind.confirmed);
    });

    test('rejected status is ignored (returns null)', () {
      final quote = sampleQuoteDraft(
        status: QuoteStatus.rejected,
      ).copyWith(eventSnapshot: eventSnapshot);

      expect(AgendaOccupancy.fromQuote(quote), isNull);
    });

    test('cancelled status is ignored (returns null)', () {
      final quote = sampleQuoteDraft(
        status: QuoteStatus.cancelled,
      ).copyWith(eventSnapshot: eventSnapshot);

      expect(AgendaOccupancy.fromQuote(quote), isNull);
    });

    test('quote without event date does not occupy the agenda', () {
      final quote = sampleQuoteDraft(status: QuoteStatus.approved);

      expect(AgendaOccupancy.fromQuote(quote), isNull);
    });

    test('falls back to the quote number when the event has no name', () {
      final quote = sampleQuoteDraft(status: QuoteStatus.approved).copyWith(
        eventSnapshot: QuoteEventSnapshot(date: DateTime(2026, 8, 15)),
        number: 'ORC-2026-0042',
      );

      final occupancy = AgendaOccupancy.fromQuote(quote)!;

      expect(occupancy.title, 'ORC-2026-0042');
    });

    test('id is namespaced to avoid clashing with block ids', () {
      final quote = sampleQuoteDraft(
        id: 'shared-id',
        status: QuoteStatus.approved,
      ).copyWith(eventSnapshot: eventSnapshot);

      final occupancy = AgendaOccupancy.fromQuote(quote)!;

      expect(occupancy.id, 'quote-shared-id');
    });
  });

  group('AgendaOccupancy.fromBlock', () {
    test('maps all fields from the block', () {
      final block = AgendaBlock(
        id: 'block-1',
        title: 'Manutenção do galpão',
        notes: 'Fechado para reforma',
        start: DateTime(2026, 8, 15, 8, 0),
        end: DateTime(2026, 8, 15, 12, 0),
        createdAt: DateTime(2026, 8, 1, 9, 0),
        updatedAt: DateTime(2026, 8, 1, 9, 0),
      );

      final occupancy = AgendaOccupancy.fromBlock(block);

      expect(occupancy.id, 'block-block-1');
      expect(occupancy.kind, AgendaOccupancyKind.block);
      expect(occupancy.title, 'Manutenção do galpão');
      expect(occupancy.start, block.start);
      expect(occupancy.end, block.end);
      expect(occupancy.sourceBlockId, 'block-1');
      expect(occupancy.sourceQuoteId, isNull);
    });
  });
}
