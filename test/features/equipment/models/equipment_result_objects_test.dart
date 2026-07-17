import 'package:eventpro/features/equipment/models/equipment.dart';
import 'package:eventpro/features/equipment/models/equipment_category.dart';
import 'package:eventpro/features/equipment/models/equipment_category_delete_result.dart';
import 'package:eventpro/features/equipment/models/equipment_category_write_result.dart';
import 'package:eventpro/features/equipment/models/equipment_delete_result.dart';
import 'package:eventpro/features/equipment/models/equipment_status.dart';
import 'package:eventpro/features/equipment/models/equipment_write_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Equipment Result Objects', () {
    final stamp = DateTime(2026, 7, 1);

    test('EquipmentWriteResult factories expose expected status flags', () {
      final equipment = Equipment(
        id: 'eq-1',
        name: 'Caixa',
        categoryId: 'cat-1',
        totalQuantity: 1,
        status: EquipmentStatus.available,
        createdAt: stamp,
        updatedAt: stamp,
      );

      expect(EquipmentWriteResult.success(equipment).isSuccess, isTrue);
      expect(
        EquipmentWriteResult.validationFailed(const ['erro']).status,
        EquipmentWriteStatus.validationFailed,
      );
      expect(
        EquipmentWriteResult.categoryNotFound().status,
        EquipmentWriteStatus.categoryNotFound,
      );
      expect(
        EquipmentWriteResult.categoryInactive().status,
        EquipmentWriteStatus.categoryInactive,
      );
      expect(
        EquipmentWriteResult.notFound().status,
        EquipmentWriteStatus.notFound,
      );
      expect(
        EquipmentWriteResult.failure().status,
        EquipmentWriteStatus.failure,
      );
    });

    test('EquipmentDeleteResult exposes isDeleted', () {
      expect(
        const EquipmentDeleteResult(
          status: EquipmentDeleteStatus.deleted,
        ).isDeleted,
        isTrue,
      );
      expect(
        const EquipmentDeleteResult(
          status: EquipmentDeleteStatus.notFound,
        ).isDeleted,
        isFalse,
      );
    });

    test('EquipmentCategoryWriteResult factories expose expected statuses', () {
      final category = EquipmentCategory(
        id: 'cat-1',
        name: 'Som',
        createdAt: stamp,
        updatedAt: stamp,
      );

      expect(EquipmentCategoryWriteResult.success(category).isSuccess, isTrue);
      expect(
        EquipmentCategoryWriteResult.validationFailed(const ['x']).status,
        EquipmentCategoryWriteStatus.validationFailed,
      );
      expect(
        EquipmentCategoryWriteResult.notFound().status,
        EquipmentCategoryWriteStatus.notFound,
      );
      expect(
        EquipmentCategoryWriteResult.failure().status,
        EquipmentCategoryWriteStatus.failure,
      );
    });

    test('EquipmentCategoryDeleteResult exposes usage helpers', () {
      const blocked = EquipmentCategoryDeleteResult(
        status: EquipmentCategoryDeleteStatus.blockedByUsage,
        blockingEquipmentCount: 3,
      );

      expect(blocked.isBlockedByUsage, isTrue);
      expect(blocked.blockingEquipmentCount, 3);
      expect(
        const EquipmentCategoryDeleteResult(
          status: EquipmentCategoryDeleteStatus.deleted,
        ).isDeleted,
        isTrue,
      );
    });
  });
}
