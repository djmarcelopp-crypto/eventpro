import 'package:eventpro/features/logistics/models/quote_vehicle.dart';
import 'package:eventpro/features/logistics/models/vehicle_availability.dart';
import 'package:eventpro/features/logistics/models/vehicle_status.dart';
import 'package:eventpro/features/logistics/utils/vehicle_availability_service.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../quotes/fakes/fake_quote_repository.dart';
import '../fakes/fake_quote_vehicle_repository.dart';
import '../fakes/fake_vehicle_repository.dart';
import '../logistics_test_helpers.dart';

void main() {
  group('VehicleAvailabilityService', () {
    late FakeVehicleRepository vehicleRepository;
    late FakeQuoteVehicleRepository quoteVehicleRepository;
    late FakeQuoteRepository quoteRepository;
    late VehicleAvailabilityService service;
    final now = DateTime(2026, 1, 1);

    Quote consumingQuote({
      required String id,
      required DateTime eventDate,
      QuoteStatus status = QuoteStatus.approved,
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

    setUp(() {
      vehicleRepository = FakeVehicleRepository(
        initialVehicles: [
          buildTestVehicle(id: 'free', plate: 'FREE000'),
          buildTestVehicle(id: 'busy', plate: 'BUSY000'),
          buildTestVehicle(
            id: 'maint',
            plate: 'MAIN000',
            status: VehicleStatus.maintenance,
          ),
        ],
      );
      quoteVehicleRepository = FakeQuoteVehicleRepository();
      quoteRepository = FakeQuoteRepository();
      service = VehicleAvailabilityService(
        vehicleRepository: vehicleRepository,
        quoteVehicleRepository: quoteVehicleRepository,
        quoteRepository: quoteRepository,
      );
    });

    test('listAll and summary with no links keep eligible vehicles available',
        () async {
      final items = await service.listAll();
      expect(items, hasLength(3));
      expect(
        items.where((item) => item.isAvailable).map((item) => item.vehicleId),
        ['free', 'busy'],
      );
      expect(
        items.singleWhere((item) => item.vehicleId == 'maint').status,
        VehicleAvailabilityStatus.unavailable,
      );

      final summary = await service.summary();
      expect(summary.availableCount, 2);
      expect(summary.unavailableCount, 1);
    });

    test('forVehicle returns occupied vehicle and planSummary freight', () async {
      final q1 = consumingQuote(id: 'q1', eventDate: DateTime(2026, 8, 1));
      await quoteRepository.insert(q1);
      await quoteVehicleRepository.insert(
        QuoteVehicle(
          id: 'qv-1',
          quoteId: 'q1',
          vehicleId: 'busy',
          freightCostCents: 12_500,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final busy = await service.forVehicle('busy');
      expect(busy, isNotNull);
      expect(busy!.status, VehicleAvailabilityStatus.unavailable);
      expect(busy.consumingQuotes, hasLength(1));

      final plan = await service.planSummary();
      expect(plan.plannedFreightCostCents, 12_500);
      expect(plan.maintenanceCount, 1);
      expect(plan.availableCount, 1);
    });
  });
}
