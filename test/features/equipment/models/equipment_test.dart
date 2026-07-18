import 'package:eventpro/features/equipment/models/equipment.dart';
import 'package:eventpro/features/equipment/models/equipment_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Equipment', () {
    final createdAt = DateTime(2026, 7, 1, 10);
    final updatedAt = DateTime(2026, 7, 1, 10);

    Equipment buildEquipment({
      String id = 'eq-1',
      String name = 'Caixa de som',
      String description = 'JBL 15"',
      String categoryId = 'cat-sound',
      String? serialNumber = 'SN-001',
      int totalQuantity = 4,
      EquipmentStatus status = EquipmentStatus.available,
    }) {
      return Equipment(
        id: id,
        name: name,
        description: description,
        categoryId: categoryId,
        serialNumber: serialNumber,
        totalQuantity: totalQuantity,
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    }

    test('description defaults to empty and serialNumber to null', () {
      final equipment = Equipment(
        id: 'eq-1',
        name: 'Microfone',
        categoryId: 'cat-sound',
        totalQuantity: 2,
        status: EquipmentStatus.available,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(equipment.description, '');
      expect(equipment.serialNumber, isNull);
    });

    test('status helpers reflect status', () {
      expect(buildEquipment().isAvailable, isTrue);
      expect(
        buildEquipment(status: EquipmentStatus.reserved).isReserved,
        isTrue,
      );
      expect(
        buildEquipment(status: EquipmentStatus.maintenance).isInMaintenance,
        isTrue,
      );
      expect(
        buildEquipment(status: EquipmentStatus.inactive).isInactive,
        isTrue,
      );
    });

    test('equality compares all fields', () {
      final a = buildEquipment();
      final b = buildEquipment();
      final different = buildEquipment(name: 'Outro');

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(equals(different)));
    });

    test('copyWith preserves original values when no override is given', () {
      final original = buildEquipment();

      final copy = original.copyWith();

      expect(copy, equals(original));
      expect(identical(copy, original), isFalse);
    });

    test('copyWith overrides selected fields', () {
      final original = buildEquipment();

      final copy = original.copyWith(
        name: 'Microfone',
        totalQuantity: 8,
        status: EquipmentStatus.maintenance,
        serialNumber: 'SN-999',
      );

      expect(copy.id, original.id);
      expect(copy.name, 'Microfone');
      expect(copy.totalQuantity, 8);
      expect(copy.status, EquipmentStatus.maintenance);
      expect(copy.serialNumber, 'SN-999');
      expect(copy.categoryId, original.categoryId);
    });

    test('copyWith can clear serialNumber', () {
      final original = buildEquipment(serialNumber: 'SN-001');

      final cleared = original.copyWith(clearSerialNumber: true);

      expect(cleared.serialNumber, isNull);
    });
  });
}
