import 'package:eventpro/features/agenda/utils/agenda_event_interval_resolver.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AgendaEventIntervalResolver', () {
    test('returns null when the snapshot has no date', () {
      const snapshot = QuoteEventSnapshot(
        startTime: '18:00',
        endTime: '23:00',
      );

      expect(AgendaEventIntervalResolver.resolve(snapshot), isNull);
    });

    test('converts explicit start and end times on the same day', () {
      final snapshot = QuoteEventSnapshot(
        date: DateTime(2026, 8, 15),
        startTime: '18:00',
        endTime: '23:30',
      );

      final interval = AgendaEventIntervalResolver.resolve(snapshot)!;

      expect(interval.start, DateTime(2026, 8, 15, 18, 0));
      expect(interval.end, DateTime(2026, 8, 15, 23, 30));
    });

    test('defaults start to 00:00 when startTime is missing', () {
      final snapshot = QuoteEventSnapshot(
        date: DateTime(2026, 8, 15),
        endTime: '10:00',
      );

      final interval = AgendaEventIntervalResolver.resolve(snapshot)!;

      expect(interval.start, DateTime(2026, 8, 15, 0, 0));
      expect(interval.end, DateTime(2026, 8, 15, 10, 0));
    });

    test('defaults end to 23:59 when endTime is missing', () {
      final snapshot = QuoteEventSnapshot(
        date: DateTime(2026, 8, 15),
        startTime: '14:00',
      );

      final interval = AgendaEventIntervalResolver.resolve(snapshot)!;

      expect(interval.start, DateTime(2026, 8, 15, 14, 0));
      expect(interval.end, DateTime(2026, 8, 15, 23, 59));
    });

    test('defaults to the full day (00:00 - 23:59) when both times are missing', () {
      final snapshot = QuoteEventSnapshot(date: DateTime(2026, 8, 15));

      final interval = AgendaEventIntervalResolver.resolve(snapshot)!;

      expect(interval.start, DateTime(2026, 8, 15, 0, 0));
      expect(interval.end, DateTime(2026, 8, 15, 23, 59));
    });

    test('rolls end over to the next day when end is before start', () {
      final snapshot = QuoteEventSnapshot(
        date: DateTime(2026, 8, 15),
        startTime: '22:00',
        endTime: '02:00',
      );

      final interval = AgendaEventIntervalResolver.resolve(snapshot)!;

      expect(interval.start, DateTime(2026, 8, 15, 22, 0));
      expect(interval.end, DateTime(2026, 8, 16, 2, 0));
    });

    test('rolls end over to the next day when end equals start', () {
      final snapshot = QuoteEventSnapshot(
        date: DateTime(2026, 8, 15),
        startTime: '20:00',
        endTime: '20:00',
      );

      final interval = AgendaEventIntervalResolver.resolve(snapshot)!;

      expect(interval.start, DateTime(2026, 8, 15, 20, 0));
      expect(interval.end, DateTime(2026, 8, 16, 20, 0));
    });

    test('preserves the civil date and local wall-clock time without timezone conversion', () {
      final snapshot = QuoteEventSnapshot(
        date: DateTime.utc(2026, 8, 15),
        startTime: '09:00',
        endTime: '11:00',
      );

      final interval = AgendaEventIntervalResolver.resolve(snapshot)!;

      expect(interval.start.isUtc, isFalse);
      expect(interval.start.year, 2026);
      expect(interval.start.month, 8);
      expect(interval.start.day, 15);
      expect(interval.start.hour, 9);
    });

    test('treats malformed time strings as missing (uses fallback)', () {
      final snapshot = QuoteEventSnapshot(
        date: DateTime(2026, 8, 15),
        startTime: 'not-a-time',
        endTime: '25:99',
      );

      final interval = AgendaEventIntervalResolver.resolve(snapshot)!;

      expect(interval.start, DateTime(2026, 8, 15, 0, 0));
      expect(interval.end, DateTime(2026, 8, 15, 23, 59));
    });
  });
}
