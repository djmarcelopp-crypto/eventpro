import 'package:eventpro/features/equipment/utils/equipment_event_period_resolver.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EquipmentEventPeriodResolver', () {
    test('returns null without event date', () {
      expect(
        EquipmentEventPeriodResolver.resolve(const QuoteEventSnapshot()),
        isNull,
      );
    });

    test('uses full-day defaults when times are omitted', () {
      final period = EquipmentEventPeriodResolver.resolve(
        QuoteEventSnapshot(date: DateTime(2026, 8, 1)),
      );
      expect(period, isNotNull);
      expect(period!.start, DateTime(2026, 8, 1, 0, 0));
      expect(period.end, DateTime(2026, 8, 1, 23, 59));
    });

    test('wraps overnight when end is not after start', () {
      final period = EquipmentEventPeriodResolver.resolve(
        QuoteEventSnapshot(
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
