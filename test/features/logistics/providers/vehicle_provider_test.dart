import 'package:eventpro/features/logistics/models/vehicle.dart';
import 'package:eventpro/features/logistics/models/vehicle_status.dart';
import 'package:eventpro/features/logistics/models/vehicle_type.dart';
import 'package:eventpro/features/logistics/providers/vehicle_provider.dart';
import 'package:eventpro/features/logistics/providers/vehicle_type_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_vehicle_repository.dart';
import '../fakes/fake_vehicle_type_repository.dart';
import '../fakes/logistics_repository_test_overrides.dart';

void main() {
  group('vehicleProvider / vehicleTypeProvider', () {
    final now = DateTime(2026, 7, 17);

    test('loads and creates vehicles via service orchestration', () async {
      final typeRepository = FakeVehicleTypeRepository(
        initialTypes: [
          VehicleType(
            id: 'type-1',
            name: 'Van',
            createdAt: now,
            updatedAt: now,
          ),
        ],
      );
      final container = ProviderContainer(
        overrides: logisticsRepositoryOverrides(
          typeRepository: typeRepository,
          vehicleRepository: FakeVehicleRepository(),
          clock: () => now,
        ),
      );
      addTearDown(container.dispose);

      final types = await container.read(vehicleTypeProvider.future);
      expect(types, hasLength(1));

      final result = await container.read(vehicleProvider.notifier).addVehicle(
            Vehicle(
              id: '',
              plate: 'abc1d23',
              vehicleTypeId: 'type-1',
              payloadCapacityKg: 800,
              volumeCapacityM3: 8,
              status: VehicleStatus.available,
              createdAt: now,
              updatedAt: now,
            ),
          );

      expect(result.isSuccess, isTrue);
      expect(result.vehicle!.plate, 'ABC1D23');
      final vehicles = await container.read(vehicleProvider.future);
      expect(vehicles, hasLength(1));
    });
  });
}
