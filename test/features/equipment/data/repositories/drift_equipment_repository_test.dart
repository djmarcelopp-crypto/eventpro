import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/equipment/data/repositories/drift_equipment_category_repository.dart';
import 'package:eventpro/features/equipment/data/repositories/drift_equipment_repository.dart';
import 'package:eventpro/features/equipment/models/equipment.dart';
import 'package:eventpro/features/equipment/models/equipment_category.dart';
import 'package:eventpro/features/equipment/models/equipment_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriftEquipmentRepository', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;
    late DriftEquipmentRepository repository;
    late DriftEquipmentCategoryRepository categoryRepository;

    final createdAt = DateTime(2026, 7, 1, 9);
    final updatedAt = DateTime(2026, 7, 1, 9);

    Future<void> seedCategory() async {
      await categoryRepository.insert(
        EquipmentCategory(
          id: 'cat-1',
          name: 'Som',
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      );
    }

    Equipment buildEquipment({
      required String id,
      required String name,
      EquipmentStatus status = EquipmentStatus.available,
      String? serialNumber,
      int totalQuantity = 2,
    }) {
      return Equipment(
        id: id,
        name: name,
        description: 'desc',
        categoryId: 'cat-1',
        serialNumber: serialNumber,
        totalQuantity: totalQuantity,
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    }

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('equipment_repo_test_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      repository = DriftEquipmentRepository(database);
      categoryRepository = DriftEquipmentCategoryRepository(database);
      await seedCategory();
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('CRUD persists fields, status enum and orders by name', () async {
      final zebra = buildEquipment(id: 'eq-z', name: 'Zebra mic');
      final alpha = buildEquipment(
        id: 'eq-a',
        name: 'Alpha caixa',
        status: EquipmentStatus.reserved,
        serialNumber: 'SN-9',
      );

      await repository.insert(zebra);
      await repository.insert(alpha);

      final listed = await repository.listAll();
      expect(listed.map((item) => item.name).toList(), [
        'Alpha caixa',
        'Zebra mic',
      ]);

      final loaded = await repository.findById('eq-a');
      expect(loaded?.status, EquipmentStatus.reserved);
      expect(loaded?.serialNumber, 'SN-9');

      final updated = alpha.copyWith(totalQuantity: 10);
      await repository.update(updated);
      expect((await repository.findById('eq-a'))?.totalQuantity, 10);

      await repository.delete('eq-a');
      expect(await repository.findById('eq-a'), isNull);
      expect((await repository.listAll()).single.id, 'eq-z');
    });

    test('FK restrict blocks orphan insert and category delete while in use',
        () async {
      await repository.insert(buildEquipment(id: 'eq-1', name: 'Caixa'));

      final orphan = Equipment(
        id: 'eq-bad',
        name: 'Sem categoria',
        categoryId: 'missing-cat',
        totalQuantity: 1,
        status: EquipmentStatus.available,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      await expectLater(repository.insert(orphan), throwsA(anything));
      await expectLater(categoryRepository.delete('cat-1'), throwsA(anything));
    });

    test('update and delete throw when equipment does not exist', () async {
      final missing = buildEquipment(id: 'missing', name: 'Fantasma');
      await expectLater(repository.update(missing), throwsStateError);
      await expectLater(repository.delete('missing'), throwsStateError);
    });

    test('close and reopen keeps persisted equipment', () async {
      await repository.insert(
        buildEquipment(id: 'eq-persisted', name: 'Persistido'),
      );
      await database.close();

      final reopenedDb = AppDatabase.forTesting(dbFile);
      addTearDown(reopenedDb.close);
      final reopenedRepository = DriftEquipmentRepository(reopenedDb);

      expect(
        (await reopenedRepository.listAll()).single.name,
        'Persistido',
      );
    });
  });
}
