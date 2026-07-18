import 'package:eventpro/features/equipment/models/equipment_category.dart';
import 'package:eventpro/features/equipment/utils/equipment_category_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EquipmentCategoryValidator', () {
    test('accepts a valid category name', () {
      final result = EquipmentCategoryValidator.validateFields(name: 'Som');

      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('rejects null or blank name', () {
      expect(
        EquipmentCategoryValidator.validateFields(name: null).errors,
        contains(EquipmentCategoryValidator.nameRequiredError),
      );
      expect(
        EquipmentCategoryValidator.validateFields(name: '   ').errors,
        contains(EquipmentCategoryValidator.nameRequiredError),
      );
    });

    test('validate delegates to fields from the entity', () {
      final valid = EquipmentCategory(
        id: 'c1',
        name: 'Som',
        createdAt: DateTime(2026, 7, 1),
        updatedAt: DateTime(2026, 7, 1),
      );
      final invalid = EquipmentCategory(
        id: 'c2',
        name: '  ',
        createdAt: DateTime(2026, 7, 1),
        updatedAt: DateTime(2026, 7, 1),
      );

      expect(EquipmentCategoryValidator.validate(valid).isValid, isTrue);
      expect(EquipmentCategoryValidator.validate(invalid).isValid, isFalse);
    });
  });
}
