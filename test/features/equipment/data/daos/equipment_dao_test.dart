import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EquipmentCategoriesDao / EquipmentsDao', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('equipment_dao_test_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('DAO CRUD for categories and equipment', () async {
      final categoriesDao = database.equipmentCategoriesDao;
      final equipmentDao = database.equipmentsDao;

      await categoriesDao.insertRow(
        EquipmentCategoriesCompanion.insert(
          id: 'cat-1',
          name: 'Som',
          active: true,
          createdAt: 1_700_000_000_000,
          updatedAt: 1_700_000_000_000,
        ),
      );

      expect((await categoriesDao.getAllOrdered()).single.name, 'Som');
      expect((await categoriesDao.getById('cat-1'))?.id, 'cat-1');

      await equipmentDao.insertRow(
        EquipmentsCompanion.insert(
          id: 'eq-1',
          name: 'Caixa',
          description: 'JBL',
          categoryId: 'cat-1',
          totalQuantity: 3,
          status: 'available',
          createdAt: 1_700_000_000_000,
          updatedAt: 1_700_000_000_000,
        ),
      );

      expect((await equipmentDao.getAllOrdered()).single.totalQuantity, 3);
      expect((await equipmentDao.getById('eq-1'))?.status, 'available');

      final updated = await equipmentDao.updateRow(
        EquipmentsCompanion.insert(
          id: 'eq-1',
          name: 'Caixa Pro',
          description: 'JBL',
          categoryId: 'cat-1',
          totalQuantity: 5,
          status: 'maintenance',
          createdAt: 1_700_000_000_000,
          updatedAt: 1_700_000_100_000,
        ),
      );
      expect(updated, isTrue);
      expect((await equipmentDao.getById('eq-1'))?.name, 'Caixa Pro');

      expect(await equipmentDao.deleteById('eq-1'), isTrue);
      expect(await equipmentDao.getById('eq-1'), isNull);
      expect(await categoriesDao.deleteById('cat-1'), isTrue);
    });
  });
}
