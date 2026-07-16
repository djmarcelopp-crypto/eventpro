import 'package:eventpro/features/agenda/models/agenda_occupancy.dart';
import 'package:eventpro/features/agenda/utils/agenda_overlap_checker.dart';
import 'package:flutter_test/flutter_test.dart';

AgendaOccupancy _occupancy({
  required String id,
  required AgendaOccupancyKind kind,
  required DateTime start,
  required DateTime end,
}) {
  return AgendaOccupancy(
    id: id,
    kind: kind,
    title: 'Ocupação $id',
    start: start,
    end: end,
    sourceBlockId: kind == AgendaOccupancyKind.block ? id : null,
    sourceQuoteId: kind == AgendaOccupancyKind.block ? null : id,
  );
}

void main() {
  group('AgendaOverlapChecker.overlaps (raw intervals)', () {
    test('detects overlap when intervals intersect', () {
      final result = AgendaOverlapChecker.overlaps(
        firstStart: DateTime(2026, 8, 15, 18, 0),
        firstEnd: DateTime(2026, 8, 15, 23, 0),
        secondStart: DateTime(2026, 8, 15, 20, 0),
        secondEnd: DateTime(2026, 8, 16, 1, 0),
      );

      expect(result, isTrue);
    });

    test('returns false when intervals only touch at the boundary', () {
      final result = AgendaOverlapChecker.overlaps(
        firstStart: DateTime(2026, 8, 15, 18, 0),
        firstEnd: DateTime(2026, 8, 15, 20, 0),
        secondStart: DateTime(2026, 8, 15, 20, 0),
        secondEnd: DateTime(2026, 8, 15, 22, 0),
      );

      expect(result, isFalse);
    });

    test('returns false for intervals far apart', () {
      final result = AgendaOverlapChecker.overlaps(
        firstStart: DateTime(2026, 8, 15, 8, 0),
        firstEnd: DateTime(2026, 8, 15, 10, 0),
        secondStart: DateTime(2026, 8, 20, 8, 0),
        secondEnd: DateTime(2026, 8, 20, 10, 0),
      );

      expect(result, isFalse);
    });
  });

  group('AgendaOverlapChecker.occupanciesOverlap', () {
    test('block × block conflict', () {
      final first = _occupancy(
        id: 'block-1',
        kind: AgendaOccupancyKind.block,
        start: DateTime(2026, 8, 15, 8, 0),
        end: DateTime(2026, 8, 15, 18, 0),
      );
      final second = _occupancy(
        id: 'block-2',
        kind: AgendaOccupancyKind.block,
        start: DateTime(2026, 8, 15, 12, 0),
        end: DateTime(2026, 8, 15, 20, 0),
      );

      expect(AgendaOverlapChecker.occupanciesOverlap(first, second), isTrue);
    });

    test('block × quote conflict', () {
      final block = _occupancy(
        id: 'block-1',
        kind: AgendaOccupancyKind.block,
        start: DateTime(2026, 8, 15, 8, 0),
        end: DateTime(2026, 8, 15, 18, 0),
      );
      final proposal = _occupancy(
        id: 'quote-1',
        kind: AgendaOccupancyKind.proposal,
        start: DateTime(2026, 8, 15, 17, 0),
        end: DateTime(2026, 8, 15, 22, 0),
      );

      expect(AgendaOverlapChecker.occupanciesOverlap(block, proposal), isTrue);
    });

    test('quote × quote conflict', () {
      final proposal = _occupancy(
        id: 'quote-1',
        kind: AgendaOccupancyKind.proposal,
        start: DateTime(2026, 8, 15, 18, 0),
        end: DateTime(2026, 8, 15, 23, 0),
      );
      final confirmed = _occupancy(
        id: 'quote-2',
        kind: AgendaOccupancyKind.confirmed,
        start: DateTime(2026, 8, 15, 19, 0),
        end: DateTime(2026, 8, 16, 1, 0),
      );

      expect(
        AgendaOverlapChecker.occupanciesOverlap(proposal, confirmed),
        isTrue,
      );
    });

    test('no conflict when occupancies do not intersect', () {
      final morning = _occupancy(
        id: 'block-1',
        kind: AgendaOccupancyKind.block,
        start: DateTime(2026, 8, 15, 8, 0),
        end: DateTime(2026, 8, 15, 12, 0),
      );
      final evening = _occupancy(
        id: 'quote-1',
        kind: AgendaOccupancyKind.confirmed,
        start: DateTime(2026, 8, 15, 18, 0),
        end: DateTime(2026, 8, 15, 23, 0),
      );

      expect(
        AgendaOverlapChecker.occupanciesOverlap(morning, evening),
        isFalse,
      );
    });
  });
}
