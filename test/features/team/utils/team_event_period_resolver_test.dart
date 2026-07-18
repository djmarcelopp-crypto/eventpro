import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/team/utils/team_event_period_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TeamEventPeriodResolver', () {
    test('returns null when snapshot has no date', () {
      const snapshot = QuoteEventSnapshot(name: 'Sem data');
      expect(TeamEventPeriodResolver.resolve(snapshot), isNull);
    });

    test('uses full-day defaults when times are missing', () {
      final period = TeamEventPeriodResolver.resolve(
        QuoteEventSnapshot(
          name: 'Evento',
          date: DateTime(2026, 8, 1),
        ),
      );

      expect(period, isNotNull);
      expect(period!.start, DateTime(2026, 8, 1, 0, 0));
      expect(period.end, DateTime(2026, 8, 1, 23, 59));
    });

    test('wraps overnight when end is not after start', () {
      final period = TeamEventPeriodResolver.resolve(
        QuoteEventSnapshot(
          name: 'Festa',
          date: DateTime(2026, 8, 1),
          startTime: '22:00',
          endTime: '02:00',
        ),
      );

      expect(period!.start, DateTime(2026, 8, 1, 22, 0));
      expect(period.end, DateTime(2026, 8, 2, 2, 0));
    });
  });
}
