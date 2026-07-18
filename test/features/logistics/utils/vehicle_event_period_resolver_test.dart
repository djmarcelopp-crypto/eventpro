import 'package:eventpro/features/logistics/models/quote_vehicle.dart';
import 'package:eventpro/features/logistics/utils/vehicle_event_period_resolver.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 7, 17);

  Quote quote({
    DateTime? eventDate,
    String? startTime,
    String? endTime,
  }) {
    return Quote(
      id: 'q1',
      number: 'ORC-1',
      status: QuoteStatus.approved,
      clientSnapshot: const QuoteClientSnapshot(
        sourceClientId: 'c1',
        type: QuoteClientType.individual,
        displayName: 'Cliente',
        phone: '67999990000',
      ),
      eventSnapshot: QuoteEventSnapshot(
        name: 'Evento',
        date: eventDate,
        startTime: startTime,
        endTime: endTime,
      ),
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

  QuoteVehicle link({
    DateTime? departure,
    DateTime? returnAt,
  }) {
    return QuoteVehicle(
      id: 'qv-1',
      quoteId: 'q1',
      vehicleId: 'v1',
      freightCostCents: 0,
      plannedDepartureAt: departure,
      plannedReturnAt: returnAt,
      createdAt: now,
      updatedAt: now,
    );
  }

  group('VehicleEventPeriodResolver', () {
    test('prefers planned departure/return when both are set', () {
      final period = VehicleEventPeriodResolver.resolve(
        link: link(
          departure: DateTime(2026, 8, 1, 8),
          returnAt: DateTime(2026, 8, 1, 18),
        ),
        quote: quote(eventDate: DateTime(2026, 9, 1)),
      );

      expect(period, isNotNull);
      expect(period!.start, DateTime(2026, 8, 1, 8));
      expect(period.end, DateTime(2026, 8, 1, 18));
    });

    test('ignores incomplete planned window and falls back to event', () {
      final period = VehicleEventPeriodResolver.resolve(
        link: link(departure: DateTime(2026, 8, 1, 8)),
        quote: quote(
          eventDate: DateTime(2026, 9, 1),
          startTime: '10:00',
          endTime: '12:00',
        ),
      );

      expect(period, isNotNull);
      expect(period!.start, DateTime(2026, 9, 1, 10));
      expect(period.end, DateTime(2026, 9, 1, 12));
    });

    test('returns null when planned window is invalid and event has no date', () {
      final period = VehicleEventPeriodResolver.resolve(
        link: link(
          departure: DateTime(2026, 8, 2),
          returnAt: DateTime(2026, 8, 1),
        ),
        quote: quote(),
      );

      expect(period, isNull);
    });

    test('returns null when no planned window and event has no date', () {
      final period = VehicleEventPeriodResolver.resolve(
        link: link(),
        quote: quote(),
      );

      expect(period, isNull);
    });
  });
}
