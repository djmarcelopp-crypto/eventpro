import 'package:eventpro/features/logistics/utils/vehicle_list_filter.dart';
import 'package:eventpro/features/logistics/models/vehicle.dart';
import 'package:eventpro/features/logistics/models/vehicle_filters.dart';
import 'package:eventpro/features/logistics/models/vehicle_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VehicleListFilter', () {
    final now = DateTime(2026, 7, 17);
    final vehicles = [
      Vehicle(
        id: '1',
        plate: 'ABC1D23',
        description: 'Van branca',
        vehicleTypeId: 'van',
        payloadCapacityKg: 800,
        volumeCapacityM3: 8,
        status: VehicleStatus.available,
        createdAt: now,
        updatedAt: now,
      ),
      Vehicle(
        id: '2',
        plate: 'XYZ9Z99',
        vehicleTypeId: 'truck',
        payloadCapacityKg: 2000,
        volumeCapacityM3: 20,
        status: VehicleStatus.maintenance,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    test('filters by status and plate query', () {
      final filtered = VehicleListFilter.apply(
        vehicles,
        const VehicleFilters(
          status: VehicleStatus.available,
          plateQuery: 'abc',
        ),
      );
      expect(filtered, hasLength(1));
      expect(filtered.single.id, '1');
    });
  });
}
