import 'package:eventpro/features/equipment/models/equipment_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EquipmentCategory', () {
    EquipmentCategory buildCategory({
      String id = 'cat-1',
      String name = 'Som',
      String? description = 'Caixas e mesas',
      bool active = true,
    }) {
      return EquipmentCategory(
        id: id,
        name: name,
        description: description,
        active: active,
      );
    }

    test('active defaults to true and description defaults to null', () {
      final category = EquipmentCategory(id: 'cat-1', name: 'Iluminação');

      expect(category.active, isTrue);
      expect(category.description, isNull);
    });

    test('equality compares all fields', () {
      final a = buildCategory();
      final b = buildCategory();
      final different = buildCategory(name: 'Iluminação');

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(equals(different)));
    });

    test('copyWith preserves original values when no override is given', () {
      final original = buildCategory();

      final copy = original.copyWith();

      expect(copy, equals(original));
      expect(identical(copy, original), isFalse);
    });

    test('copyWith overrides selected fields', () {
      final original = buildCategory();

      final copy = original.copyWith(
        name: 'Iluminação',
        description: 'Refletores',
        active: false,
      );

      expect(copy.id, original.id);
      expect(copy.name, 'Iluminação');
      expect(copy.description, 'Refletores');
      expect(copy.active, isFalse);
    });

    test('copyWith can clear description', () {
      final original = buildCategory(description: 'Tem texto');

      final cleared = original.copyWith(clearDescription: true);

      expect(cleared.description, isNull);
    });
  });
}
