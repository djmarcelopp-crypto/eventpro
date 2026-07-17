import 'package:eventpro/features/logistics/models/quote_vehicle.dart';
import 'package:eventpro/features/logistics/models/vehicle.dart';
import 'package:eventpro/features/logistics/models/vehicle_availability.dart';
import 'package:eventpro/features/logistics/models/vehicle_event_period.dart';
import 'package:eventpro/features/logistics/models/vehicle_status.dart';
import 'package:eventpro/features/logistics/utils/vehicle_availability_calculator.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 1, 1);

  Vehicle vehicle({
    String id = 'vehicle-1',
    VehicleStatus status = VehicleStatus.available,
  }) {
    return Vehicle(
      id: id,
      plate: 'ABC1D23',
      vehicleTypeId: 'type-1',
      payloadCapacityKg: 800,
      volumeCapacityM3: 8,
      status: status,
      createdAt: now,
      updatedAt: now,
    );
  }

  Quote quote({
    required String id,
    DateTime? eventDate,
    QuoteStatus status = QuoteStatus.approved,
    String? startTime,
    String? endTime,
  }) {
    return Quote(
      id: id,
      number: 'ORC-$id',
      status: status,
      clientSnapshot: const QuoteClientSnapshot(
        sourceClientId: 'c1',
        type: QuoteClientType.individual,
        displayName: 'Cliente',
        phone: '67999990000',
      ),
      eventSnapshot: QuoteEventSnapshot(
        name: 'Evento $id',
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
          newStatus: status,
          changedAt: now,
        ),
      ],
      createdAt: now,
      updatedAt: now,
    );
  }

  QuoteVehicle link({
    required String id,
    required String quoteId,
    required String vehicleId,
    DateTime? departure,
    DateTime? returnAt,
    int freightCostCents = 0,
  }) {
    return QuoteVehicle(
      id: id,
      quoteId: quoteId,
      vehicleId: vehicleId,
      freightCostCents: freightCostCents,
      plannedDepartureAt: departure,
      plannedReturnAt: returnAt,
      createdAt: now,
      updatedAt: now,
    );
  }

  group('VehicleAvailabilityCalculator', () {
    test('vehicle is available when not linked to consuming quotes', () {
      final result = VehicleAvailabilityCalculator.calculateForVehicle(
        vehicle: vehicle(),
        quoteVehicles: const [],
        quotesById: const {},
      );

      expect(result.status, VehicleAvailabilityStatus.available);
      expect(result.consumingQuotes, isEmpty);
      expect(result.conflicts, isEmpty);
    });

    test('vehicle is unavailable when linked to a quote with period', () {
      final q1 = quote(id: 'q1', eventDate: DateTime(2026, 8, 1));
      final result = VehicleAvailabilityCalculator.calculateForVehicle(
        vehicle: vehicle(),
        quoteVehicles: [
          link(id: 'l1', quoteId: 'q1', vehicleId: 'vehicle-1'),
        ],
        quotesById: {'q1': q1},
      );

      expect(result.status, VehicleAvailabilityStatus.unavailable);
      expect(result.consumingQuotes, hasLength(1));
      expect(result.conflicts, isEmpty);
    });

    test('prefers planned logistics window over event date', () {
      final q1 = quote(id: 'q1', eventDate: DateTime(2026, 9, 1));
      final result = VehicleAvailabilityCalculator.calculateForVehicle(
        vehicle: vehicle(),
        quoteVehicles: [
          link(
            id: 'l1',
            quoteId: 'q1',
            vehicleId: 'vehicle-1',
            departure: DateTime(2026, 8, 1, 8),
            returnAt: DateTime(2026, 8, 1, 18),
          ),
        ],
        quotesById: {'q1': q1},
      );

      expect(result.consumingQuotes.single.eventPeriod.start, DateTime(2026, 8, 1, 8));
      expect(result.consumingQuotes.single.eventPeriod.end, DateTime(2026, 8, 1, 18));
    });

    test('consecutive touching periods do not conflict', () {
      final q1 = quote(
        id: 'q1',
        eventDate: DateTime(2026, 8, 1),
        startTime: '10:00',
        endTime: '12:00',
      );
      final q2 = quote(
        id: 'q2',
        eventDate: DateTime(2026, 8, 1),
        startTime: '12:00',
        endTime: '14:00',
      );
      final result = VehicleAvailabilityCalculator.calculateForVehicle(
        vehicle: vehicle(),
        quoteVehicles: [
          link(id: 'l1', quoteId: 'q1', vehicleId: 'vehicle-1'),
          link(id: 'l2', quoteId: 'q2', vehicleId: 'vehicle-1'),
        ],
        quotesById: {'q1': q1, 'q2': q2},
      );

      expect(result.conflicts, isEmpty);
    });

    test('partial overlap creates schedule conflicts', () {
      final q1 = quote(
        id: 'q1',
        eventDate: DateTime(2026, 8, 1),
        startTime: '10:00',
        endTime: '14:00',
      );
      final q2 = quote(
        id: 'q2',
        eventDate: DateTime(2026, 8, 1),
        startTime: '12:00',
        endTime: '16:00',
      );
      final result = VehicleAvailabilityCalculator.calculateForVehicle(
        vehicle: vehicle(),
        quoteVehicles: [
          link(id: 'l1', quoteId: 'q1', vehicleId: 'vehicle-1'),
          link(id: 'l2', quoteId: 'q2', vehicleId: 'vehicle-1'),
        ],
        quotesById: {'q1': q1, 'q2': q2},
      );

      expect(result.conflicts, hasLength(2));
      expect(
        result.conflicts.every(
          (c) => c.reason == VehicleAvailabilityCalculator.partialOverlapReason,
        ),
        isTrue,
      );
    });

    test('total overlap creates schedule conflicts', () {
      final q1 = quote(
        id: 'q1',
        eventDate: DateTime(2026, 8, 1),
        startTime: '10:00',
        endTime: '18:00',
      );
      final q2 = quote(
        id: 'q2',
        eventDate: DateTime(2026, 8, 1),
        startTime: '10:00',
        endTime: '18:00',
      );
      final result = VehicleAvailabilityCalculator.calculateForVehicle(
        vehicle: vehicle(),
        quoteVehicles: [
          link(id: 'l1', quoteId: 'q1', vehicleId: 'vehicle-1'),
          link(id: 'l2', quoteId: 'q2', vehicleId: 'vehicle-1'),
        ],
        quotesById: {'q1': q1, 'q2': q2},
      );

      expect(result.conflicts, hasLength(2));
      expect(
        result.conflicts.every(
          (c) => c.reason == VehicleAvailabilityCalculator.totalOverlapReason,
        ),
        isTrue,
      );
    });

    test('cancelled and rejected quotes do not consume availability', () {
      final approved = quote(id: 'q1', eventDate: DateTime(2026, 8, 1));
      final cancelled = quote(
        id: 'q2',
        eventDate: DateTime(2026, 8, 1),
        status: QuoteStatus.cancelled,
      );
      final rejected = quote(
        id: 'q3',
        eventDate: DateTime(2026, 8, 1),
        status: QuoteStatus.rejected,
      );
      final result = VehicleAvailabilityCalculator.calculateForVehicle(
        vehicle: vehicle(),
        quoteVehicles: [
          link(id: 'l1', quoteId: 'q1', vehicleId: 'vehicle-1'),
          link(id: 'l2', quoteId: 'q2', vehicleId: 'vehicle-1'),
          link(id: 'l3', quoteId: 'q3', vehicleId: 'vehicle-1'),
        ],
        quotesById: {
          'q1': approved,
          'q2': cancelled,
          'q3': rejected,
        },
      );

      expect(result.consumingQuotes.map((c) => c.quoteId), ['q1']);
      expect(result.status, VehicleAvailabilityStatus.unavailable);
    });

    test('quotes without resolvable period do not consume availability', () {
      final withoutDate = quote(id: 'q1');
      final result = VehicleAvailabilityCalculator.calculateForVehicle(
        vehicle: vehicle(),
        quoteVehicles: [
          link(id: 'l1', quoteId: 'q1', vehicleId: 'vehicle-1'),
        ],
        quotesById: {'q1': withoutDate},
      );

      expect(result.status, VehicleAvailabilityStatus.available);
      expect(result.consumingQuotes, isEmpty);
    });

    test('maintenance status makes vehicle temporally unavailable', () {
      final result = VehicleAvailabilityCalculator.calculateForVehicle(
        vehicle: vehicle(status: VehicleStatus.maintenance),
        quoteVehicles: const [],
        quotesById: const {},
      );

      expect(result.status, VehicleAvailabilityStatus.unavailable);
      expect(result.operationalStatus, VehicleStatus.maintenance);
      expect(result.isOperationallyEligible, isFalse);
    });

    test('query period marks vehicle available when no overlap', () {
      final q1 = quote(id: 'q1', eventDate: DateTime(2026, 8, 1));
      final result = VehicleAvailabilityCalculator.calculateForVehicle(
        vehicle: vehicle(),
        quoteVehicles: [
          link(id: 'l1', quoteId: 'q1', vehicleId: 'vehicle-1'),
        ],
        quotesById: {'q1': q1},
        queryPeriod: VehicleEventPeriod(
          start: DateTime(2026, 9, 1),
          end: DateTime(2026, 9, 2),
        ),
      );

      expect(result.status, VehicleAvailabilityStatus.available);
      expect(result.consumingQuotes, hasLength(1));
    });

    test('summary and plan summary aggregate counts and freight', () {
      final items = VehicleAvailabilityCalculator.calculateAll(
        vehicles: [
          vehicle(id: 'free'),
          vehicle(id: 'busy'),
          vehicle(id: 'maint', status: VehicleStatus.maintenance),
        ],
        quoteVehicles: [
          link(
            id: 'l1',
            quoteId: 'q1',
            vehicleId: 'busy',
            freightCostCents: 10_000,
          ),
          link(
            id: 'l2',
            quoteId: 'q1',
            vehicleId: 'busy',
            freightCostCents: 5_000,
          ),
        ],
        quotes: [quote(id: 'q1', eventDate: DateTime(2026, 8, 1))],
      );

      // Same vehicle linked twice to same quote would be blocked by service,
      // but calculator still aggregates; use one busy + conflict via two quotes.
      final conflicted = VehicleAvailabilityCalculator.calculateAll(
        vehicles: [
          vehicle(id: 'free'),
          vehicle(id: 'busy'),
          vehicle(id: 'conflicted'),
          vehicle(id: 'maint', status: VehicleStatus.maintenance),
        ],
        quoteVehicles: [
          link(id: 'l1', quoteId: 'q1', vehicleId: 'busy'),
          link(id: 'l2', quoteId: 'q1', vehicleId: 'conflicted'),
          link(id: 'l3', quoteId: 'q2', vehicleId: 'conflicted'),
        ],
        quotes: [
          quote(id: 'q1', eventDate: DateTime(2026, 8, 1)),
          quote(id: 'q2', eventDate: DateTime(2026, 8, 1)),
        ],
      );

      final summary = VehicleAvailabilityCalculator.summarize(conflicted);
      expect(summary.totalVehicles, 4);
      expect(summary.availableCount, 1);
      expect(summary.unavailableCount, 3);
      expect(summary.conflictCount, 2);

      final plan = VehicleAvailabilityCalculator.planSummary(
        conflicted,
        plannedFreightCostCents: 15_000,
      );
      expect(plan.maintenanceCount, 1);
      expect(plan.plannedFreightCostCents, 15_000);
      expect(plan.availabilityPercent, closeTo(25, 0.001));

      expect(items, isNotEmpty);
    });
  });
}
