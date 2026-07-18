import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/equipment/data/mappers/equipment_category_mapper.dart';
import 'package:eventpro/features/equipment/data/mappers/equipment_mapper.dart';
import 'package:eventpro/features/equipment/models/equipment.dart';
import 'package:eventpro/features/equipment/models/equipment_category.dart';
import 'package:eventpro/features/equipment/models/equipment_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EquipmentMapper', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;

    final createdAt = DateTime(2026, 7, 1, 12);
    final updatedAt = DateTime(2026, 7, 2, 15);

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'equipment_mapper_test_',
      );
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      await database.into(database.equipmentCategories).insert(
            EquipmentCategoryMapper.toInsertCompanion(
              EquipmentCategory(
                id: 'cat-1',
                name: 'Som',
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
            ),
          );
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    Future<Equipment> persistAndReload(Equipment equipment) async {
      await database
          .into(database.equipments)
          .insert(EquipmentMapper.toInsertCompanion(equipment));
      final row = await (database.select(database.equipments)
            ..where((tbl) => tbl.id.equals(equipment.id)))
          .getSingle();
      return EquipmentMapper.toDomain(row);
    }

    test('round-trips all fields and serializes EquipmentStatus by name',
        () async {
      final original = Equipment(
        id: 'eq-1',
        name: 'Caixa',
        description: 'JBL 15"',
        categoryId: 'cat-1',
        serialNumber: 'SN-1',
        totalQuantity: 4,
        status: EquipmentStatus.maintenance,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final companion = EquipmentMapper.toInsertCompanion(original);
      expect(companion.status.value, 'maintenance');

      final restored = await persistAndReload(original);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.description, original.description);
      expect(restored.categoryId, original.categoryId);
      expect(restored.serialNumber, original.serialNumber);
      expect(restored.totalQuantity, original.totalQuantity);
      expect(restored.status, EquipmentStatus.maintenance);
      expect(restored.createdAt, original.createdAt);
      expect(restored.updatedAt, original.updatedAt);
    });

    test('maps null serialNumber', () async {
      final original = Equipment(
        id: 'eq-2',
        name: 'Microfone',
        categoryId: 'cat-1',
        totalQuantity: 2,
        status: EquipmentStatus.available,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final restored = await persistAndReload(original);
      expect(restored.serialNumber, isNull);
      expect(restored.status, EquipmentStatus.available);
    });
  });
}
