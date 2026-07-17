import 'package:eventpro/features/logistics/models/vehicle_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VehicleType', () {
    final createdAt = DateTime(2026, 7, 17, 10);
    final updatedAt = DateTime(2026, 7, 17, 10);

    VehicleType buildType({
      String id = 'type-1',
      String name = 'Van',
      String? description = 'Utilitário',
      bool active = true,
    }) {
      return VehicleType(
        id: id,
        name: name,
        description: description,
        active: active,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    }

    test('description defaults to null and active to true', () {
      final type = VehicleType(
        id: 'type-1',
        name: 'Van',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(type.description, isNull);
      expect(type.active, isTrue);
    });

    test('equality compares all fields', () {
      final a = buildType();
      final b = buildType();
      final different = buildType(name: 'Truck');

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(equals(different)));
    });

    test('copyWith preserves original values when no override is given', () {
      final original = buildType();
      final copy = original.copyWith();

      expect(copy, equals(original));
      expect(identical(copy, original), isFalse);
    });

    test('copyWith overrides selected fields and can clear description', () {
      final original = buildType();
      final copy = original.copyWith(
        name: 'Caminhão',
        active: false,
        clearDescription: true,
      );

      expect(copy.id, original.id);
      expect(copy.name, 'Caminhão');
      expect(copy.active, isFalse);
      expect(copy.description, isNull);
      expect(copy.createdAt, original.createdAt);
    });
  });
}
