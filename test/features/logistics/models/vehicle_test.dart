import 'package:eventpro/features/logistics/models/vehicle.dart';
import 'package:eventpro/features/logistics/models/vehicle_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Vehicle', () {
    final createdAt = DateTime(2026, 7, 17, 10);
    final updatedAt = DateTime(2026, 7, 17, 10);

    Vehicle buildVehicle({
      String id = 'vehicle-1',
      String plate = 'ABC1D23',
      String description = 'Van branca',
      String vehicleTypeId = 'type-van',
      double payloadCapacityKg = 800,
      double volumeCapacityM3 = 8.5,
      String observations = 'Revisada em 2026',
      VehicleStatus status = VehicleStatus.available,
    }) {
      return Vehicle(
        id: id,
        plate: plate,
        description: description,
        vehicleTypeId: vehicleTypeId,
        payloadCapacityKg: payloadCapacityKg,
        volumeCapacityM3: volumeCapacityM3,
        observations: observations,
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    }

    test('description and observations default to empty', () {
      final vehicle = Vehicle(
        id: 'vehicle-1',
        plate: 'ABC1D23',
        vehicleTypeId: 'type-van',
        payloadCapacityKg: 0,
        volumeCapacityM3: 0,
        status: VehicleStatus.available,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(vehicle.description, '');
      expect(vehicle.observations, '');
    });

    test('status helpers reflect status', () {
      expect(buildVehicle().isAvailable, isTrue);
      expect(
        buildVehicle(status: VehicleStatus.maintenance).isInMaintenance,
        isTrue,
      );
      expect(
        buildVehicle(status: VehicleStatus.unavailable).isUnavailable,
        isTrue,
      );
      expect(
        buildVehicle(status: VehicleStatus.inactive).isInactive,
        isTrue,
      );
    });

    test('equality compares all fields', () {
      final a = buildVehicle();
      final b = buildVehicle();
      final different = buildVehicle(plate: 'XYZ9Z99');

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(equals(different)));
    });

    test('copyWith preserves original values when no override is given', () {
      final original = buildVehicle();
      final copy = original.copyWith();

      expect(copy, equals(original));
      expect(identical(copy, original), isFalse);
    });

    test('copyWith overrides selected fields', () {
      final original = buildVehicle();
      final copy = original.copyWith(
        plate: 'DEF2E34',
        payloadCapacityKg: 1200,
        status: VehicleStatus.maintenance,
      );

      expect(copy.id, original.id);
      expect(copy.plate, 'DEF2E34');
      expect(copy.payloadCapacityKg, 1200);
      expect(copy.status, VehicleStatus.maintenance);
      expect(copy.vehicleTypeId, original.vehicleTypeId);
      expect(copy.volumeCapacityM3, original.volumeCapacityM3);
    });
  });
}
