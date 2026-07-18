import 'package:eventpro/features/logistics/models/vehicle_availability.dart';
import 'package:eventpro/features/logistics/models/vehicle_status.dart';
import 'package:eventpro/features/logistics/providers/vehicle_availability_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_vehicle_repository.dart';
import '../fakes/fake_vehicle_type_repository.dart';
import '../fakes/logistics_repository_test_overrides.dart';
import '../logistics_test_helpers.dart';

void main() {
  group('vehicleAvailabilityProvider', () {
    test('exposes available vehicles and empty plan conflicts', () async {
      final container = ProviderContainer(
        overrides: logisticsRepositoryOverrides(
          vehicleRepository: FakeVehicleRepository(
            initialVehicles: [
              buildTestVehicle(),
              buildTestVehicle(
                id: 'v-maint',
                plate: 'MAIN000',
                status: VehicleStatus.maintenance,
              ),
            ],
          ),
          typeRepository: FakeVehicleTypeRepository(
            initialTypes: [buildTestType()],
          ),
        ),
      );
      addTearDown(container.dispose);

      final items = await container.read(vehicleAvailabilityProvider.future);
      expect(items, hasLength(2));
      expect(
        items.singleWhere((item) => item.vehicleId == 'vehicle-1').status,
        VehicleAvailabilityStatus.available,
      );

      final summary =
          await container.read(vehicleAvailabilitySummaryProvider.future);
      expect(summary.totalVehicles, 2);
      expect(summary.availableCount, 1);
      expect(summary.conflictCount, 0);

      final plan = await container.read(logisticsPlanSummaryProvider.future);
      expect(plan.maintenanceCount, 1);
      expect(plan.plannedFreightCostCents, 0);
      expect(plan.availabilityPercent, 50);
    });
  });
}
