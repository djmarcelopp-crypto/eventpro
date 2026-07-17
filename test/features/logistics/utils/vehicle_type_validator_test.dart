import 'package:eventpro/features/logistics/models/vehicle_type.dart';
import 'package:eventpro/features/logistics/utils/vehicle_type_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VehicleTypeValidator', () {
    test('accepts a valid type draft', () {
      final result = VehicleTypeValidator.validateFields(name: 'Van');

      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('rejects missing name', () {
      final result = VehicleTypeValidator.validateFields(name: '  ');

      expect(result.errors, contains(VehicleTypeValidator.nameRequiredError));
    });

    test('validate delegates to fields of the entity', () {
      final now = DateTime(2026, 7, 17);
      final result = VehicleTypeValidator.validate(
        VehicleType(
          id: 't1',
          name: '',
          createdAt: now,
          updatedAt: now,
        ),
      );

      expect(result.isValid, isFalse);
      expect(result.errors, contains(VehicleTypeValidator.nameRequiredError));
    });
  });
}
