import 'package:eventpro/features/equipment/models/equipment.dart';
import 'package:eventpro/features/equipment/models/equipment_status.dart';
import 'package:eventpro/features/equipment/utils/equipment_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EquipmentValidator', () {
    test('accepts a valid equipment draft', () {
      final result = EquipmentValidator.validateFields(
        name: 'Caixa de som',
        categoryId: 'cat-1',
        totalQuantity: 2,
        status: EquipmentStatus.available,
      );

      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('rejects missing name', () {
      final result = EquipmentValidator.validateFields(
        name: '  ',
        categoryId: 'cat-1',
        totalQuantity: 1,
        status: EquipmentStatus.available,
      );

      expect(result.errors, contains(EquipmentValidator.nameRequiredError));
    });

    test('rejects missing category', () {
      final result = EquipmentValidator.validateFields(
        name: 'Caixa',
        categoryId: null,
        totalQuantity: 1,
        status: EquipmentStatus.available,
      );

      expect(
        result.errors,
        contains(EquipmentValidator.categoryRequiredError),
      );
    });

    test('rejects quantity less than or equal to zero', () {
      expect(
        EquipmentValidator.validateFields(
          name: 'Caixa',
          categoryId: 'cat-1',
          totalQuantity: 0,
          status: EquipmentStatus.available,
        ).errors,
        contains(EquipmentValidator.quantityGreaterThanZeroError),
      );
      expect(
        EquipmentValidator.validateFields(
          name: 'Caixa',
          categoryId: 'cat-1',
          totalQuantity: -1,
          status: EquipmentStatus.available,
        ).errors,
        contains(EquipmentValidator.quantityGreaterThanZeroError),
      );
    });

    test('rejects missing status', () {
      final result = EquipmentValidator.validateFields(
        name: 'Caixa',
        categoryId: 'cat-1',
        totalQuantity: 1,
        status: null,
      );

      expect(result.errors, contains(EquipmentValidator.statusRequiredError));
    });

    test('accumulates multiple errors', () {
      final result = EquipmentValidator.validateFields(
        name: null,
        categoryId: '',
        totalQuantity: 0,
        status: null,
      );

      expect(result.errors, [
        EquipmentValidator.nameRequiredError,
        EquipmentValidator.categoryRequiredError,
        EquipmentValidator.quantityGreaterThanZeroError,
        EquipmentValidator.statusRequiredError,
      ]);
    });

    test('validate delegates to fields from the entity', () {
      final valid = Equipment(
        id: 'eq-1',
        name: 'Microfone',
        categoryId: 'cat-1',
        totalQuantity: 3,
        status: EquipmentStatus.available,
        createdAt: DateTime(2026, 7, 1),
        updatedAt: DateTime(2026, 7, 1),
      );
      final invalid = valid.copyWith(name: '  ', totalQuantity: 0);

      expect(EquipmentValidator.validate(valid).isValid, isTrue);
      expect(EquipmentValidator.validate(invalid).isValid, isFalse);
    });
  });
}
