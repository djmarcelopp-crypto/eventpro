import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/equipment/data/mappers/equipment_category_mapper.dart';
import 'package:eventpro/features/equipment/models/equipment_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EquipmentCategoryMapper', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;

    final createdAt = DateTime(2026, 7, 1, 12);
    final updatedAt = DateTime(2026, 7, 2, 15);

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'equipment_category_mapper_test_',
      );
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    Future<EquipmentCategory> persistAndReload(
      EquipmentCategory category,
    ) async {
      await database.into(database.equipmentCategories).insert(
            EquipmentCategoryMapper.toInsertCompanion(category),
          );
      final row = await (database.select(database.equipmentCategories)
            ..where((tbl) => tbl.id.equals(category.id)))
          .getSingle();
      return EquipmentCategoryMapper.toDomain(row);
    }

    test('round-trips all fields including nullable description', () async {
      final original = EquipmentCategory(
        id: 'cat-1',
        name: 'Som',
        description: 'Caixas',
        active: true,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final restored = await persistAndReload(original);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.description, original.description);
      expect(restored.active, original.active);
      expect(restored.createdAt, original.createdAt);
      expect(restored.updatedAt, original.updatedAt);
    });

    test('maps null description', () async {
      final original = EquipmentCategory(
        id: 'cat-2',
        name: 'Iluminação',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final restored = await persistAndReload(original);
      expect(restored.description, isNull);
    });
  });
}
