import 'package:eventpro/features/logistics/models/quote_vehicle_write_result.dart';
import 'package:eventpro/features/logistics/models/vehicle.dart';
import 'package:eventpro/features/logistics/models/vehicle_status.dart';
import 'package:eventpro/features/logistics/utils/quote_vehicle_service.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';
import 'package:eventpro/features/team/models/team_member.dart';
import 'package:eventpro/features/team/models/team_member_status.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../quotes/fakes/fake_quote_repository.dart';
import '../../team/fakes/fake_team_member_repository.dart';
import '../fakes/fake_quote_vehicle_repository.dart';
import '../fakes/fake_vehicle_repository.dart';

void main() {
  group('QuoteVehicleService', () {
    late FakeQuoteVehicleRepository quoteVehicleRepository;
    late FakeVehicleRepository vehicleRepository;
    late FakeQuoteRepository quoteRepository;
    late FakeTeamMemberRepository memberRepository;
    late QuoteVehicleService service;
    final now = DateTime(2026, 7, 17, 12);
    final earlier = DateTime(2026, 1, 1);

    Quote buildQuote({String id = 'q1'}) {
      return Quote(
        id: id,
        number: 'ORC-001',
        status: QuoteStatus.draft,
        clientSnapshot: const QuoteClientSnapshot(
          sourceClientId: 'c1',
          type: QuoteClientType.individual,
          displayName: 'Cliente',
          phone: '67999990000',
        ),
        eventSnapshot: const QuoteEventSnapshot(name: 'Evento'),
        items: const [],
        subtotalCents: 0,
        discountCents: 0,
        freightCents: 0,
        totalCents: 0,
        statusHistory: [
          QuoteStatusHistoryEntry(
            previousStatus: null,
            newStatus: QuoteStatus.draft,
            changedAt: earlier,
          ),
        ],
        createdAt: earlier,
        updatedAt: earlier,
      );
    }

    Vehicle buildVehicle({
      String id = 'v1',
      VehicleStatus status = VehicleStatus.available,
    }) {
      return Vehicle(
        id: id,
        plate: 'ABC1D23',
        vehicleTypeId: 'type-1',
        payloadCapacityKg: 800,
        volumeCapacityM3: 8,
        status: status,
        createdAt: earlier,
        updatedAt: earlier,
      );
    }

    setUp(() async {
      quoteVehicleRepository = FakeQuoteVehicleRepository();
      vehicleRepository = FakeVehicleRepository();
      quoteRepository = FakeQuoteRepository(initialQuotes: [buildQuote()]);
      memberRepository = FakeTeamMemberRepository(
        initialMembers: [
          TeamMember(
            id: 'driver-1',
            name: 'Motorista',
            phone: '11999999999',
            roleId: 'role-1',
            dailyRate: 0,
            status: TeamMemberStatus.active,
            createdAt: earlier,
            updatedAt: earlier,
          ),
        ],
      );
      await vehicleRepository.insert(buildVehicle());
      service = QuoteVehicleService(
        quoteVehicleRepository: quoteVehicleRepository,
        vehicleRepository: vehicleRepository,
        quoteRepository: quoteRepository,
        teamMemberRepository: memberRepository,
        clock: () => now,
      );
    });

    test('add links available vehicle with freight cost', () async {
      final result = await service.add(
        quoteId: 'q1',
        vehicleId: 'v1',
        freightCostCents: 15_000,
        driverTeamMemberId: 'driver-1',
      );

      expect(result.isSuccess, isTrue);
      expect(result.item!.freightCostCents, 15_000);
      expect(result.item!.driverTeamMemberId, 'driver-1');
      final summary = await service.summaryForQuote('q1');
      expect(summary.totalFreightCostCents, 15_000);
    });

    test('rejects unavailable vehicle status', () async {
      await vehicleRepository.update(
        buildVehicle(status: VehicleStatus.maintenance),
      );
      final result = await service.add(quoteId: 'q1', vehicleId: 'v1');
      expect(result.status, QuoteVehicleWriteStatus.vehicleUnavailable);
    });

    test('rejects duplicate vehicle on same quote', () async {
      await service.add(quoteId: 'q1', vehicleId: 'v1');
      final result = await service.add(quoteId: 'q1', vehicleId: 'v1');
      expect(result.status, QuoteVehicleWriteStatus.duplicateVehicle);
    });

    test('rejects return before departure', () async {
      final result = await service.add(
        quoteId: 'q1',
        vehicleId: 'v1',
        plannedDepartureAt: DateTime(2026, 8, 2),
        plannedReturnAt: DateTime(2026, 8, 1),
      );
      expect(result.status, QuoteVehicleWriteStatus.invalidSchedule);
    });

    test('rejects negative freight', () async {
      final result = await service.add(
        quoteId: 'q1',
        vehicleId: 'v1',
        freightCostCents: -1,
      );
      expect(result.status, QuoteVehicleWriteStatus.validationFailed);
    });
  });
}
