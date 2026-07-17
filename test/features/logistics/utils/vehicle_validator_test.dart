import 'package:eventpro/features/logistics/models/vehicle.dart';
import 'package:eventpro/features/logistics/models/vehicle_status.dart';
import 'package:eventpro/features/logistics/utils/vehicle_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VehicleValidator', () {
    final now = DateTime(2026, 7, 17);

    test('accepts a valid vehicle draft', () {
      final result = VehicleValidator.validateFields(
        plate: 'ABC1D23',
        vehicleTypeId: 'type-van',
        payloadCapacityKg: 0,
        volumeCapacityM3: 0,
        status: VehicleStatus.available,
      );

      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('rejects missing plate', () {
      final result = VehicleValidator.validateFields(
        plate: '  ',
        vehicleTypeId: 'type-van',
        payloadCapacityKg: 100,
        volumeCapacityM3: 2,
        status: VehicleStatus.available,
      );

      expect(result.errors, contains(VehicleValidator.plateRequiredError));
    });

    test('rejects missing type', () {
      final result = VehicleValidator.validateFields(
        plate: 'ABC1D23',
        vehicleTypeId: null,
        payloadCapacityKg: 100,
        volumeCapacityM3: 2,
        status: VehicleStatus.available,
      );

      expect(result.errors, contains(VehicleValidator.typeRequiredError));
    });

    test('rejects negative payload capacity', () {
      final result = VehicleValidator.validateFields(
        plate: 'ABC1D23',
        vehicleTypeId: 'type-van',
        payloadCapacityKg: -1,
        volumeCapacityM3: 2,
        status: VehicleStatus.available,
      );

      expect(
        result.errors,
        contains(VehicleValidator.payloadCapacityNonNegativeError),
      );
    });

    test('rejects negative volume capacity', () {
      final result = VehicleValidator.validateFields(
        plate: 'ABC1D23',
        vehicleTypeId: 'type-van',
        payloadCapacityKg: 100,
        volumeCapacityM3: -0.1,
        status: VehicleStatus.available,
      );

      expect(
        result.errors,
        contains(VehicleValidator.volumeCapacityNonNegativeError),
      );
    });

    test('accepts zero capacities', () {
      final result = VehicleValidator.validateFields(
        plate: 'ABC1D23',
        vehicleTypeId: 'type-van',
        payloadCapacityKg: 0,
        volumeCapacityM3: 0,
        status: VehicleStatus.available,
      );

      expect(result.isValid, isTrue);
    });

    test('rejects missing status', () {
      final result = VehicleValidator.validateFields(
        plate: 'ABC1D23',
        vehicleTypeId: 'type-van',
        payloadCapacityKg: 100,
        volumeCapacityM3: 2,
        status: null,
      );

      expect(result.errors, contains(VehicleValidator.statusRequiredError));
    });

    test('rejects invalid status name', () {
      final result = VehicleValidator.validateFields(
        plate: 'ABC1D23',
        vehicleTypeId: 'type-van',
        payloadCapacityKg: 100,
        volumeCapacityM3: 2,
        statusName: 'not-a-status',
      );

      expect(result.errors, contains(VehicleValidator.statusInvalidError));
    });

    test('accepts a known status name when enum status is omitted', () {
      final result = VehicleValidator.validateFields(
        plate: 'ABC1D23',
        vehicleTypeId: 'type-van',
        payloadCapacityKg: 100,
        volumeCapacityM3: 2,
        statusName: VehicleStatus.available.name,
      );

      expect(result.isValid, isTrue);
    });

    test('validate delegates to fields of the entity', () {
      final result = VehicleValidator.validate(
        Vehicle(
          id: 'v1',
          plate: '',
          vehicleTypeId: '',
          payloadCapacityKg: -10,
          volumeCapacityM3: -1,
          status: VehicleStatus.available,
          createdAt: now,
          updatedAt: now,
        ),
      );

      expect(result.isValid, isFalse);
      expect(result.errors, contains(VehicleValidator.plateRequiredError));
      expect(result.errors, contains(VehicleValidator.typeRequiredError));
      expect(
        result.errors,
        contains(VehicleValidator.payloadCapacityNonNegativeError),
      );
      expect(
        result.errors,
        contains(VehicleValidator.volumeCapacityNonNegativeError),
      );
    });
  });
}
