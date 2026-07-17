import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/equipment/data/repositories/drift_equipment_category_repository.dart';
import 'package:eventpro/features/equipment/models/equipment_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriftEquipmentCategoryRepository', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;
    late DriftEquipmentCategoryRepository repository;

    final createdAt = DateTime(2026, 7, 1, 9);
    final updatedAt = DateTime(2026, 7, 1, 9);

    EquipmentCategory buildCategory({
      required String id,
      required String name,
      String? description,
      bool active = true,
    }) {
      return EquipmentCategory(
        id: id,
        name: name,
        description: description,
        active: active,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    }

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'equipment_category_repo_test_',
      );
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      repository = DriftEquipmentCategoryRepository(database);
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('CRUD persists all fields and orders alphabetically by name', () async {
      final zebra = buildCategory(id: 'cat-z', name: 'Zeladoria');
      final audio = buildCategory(
        id: 'cat-a',
        name: 'Áudio',
        description: 'Som',
      );

      await repository.insert(zebra);
      await repository.insert(audio);

      final listed = await repository.listAll();
      expect(listed.map((category) => category.name).toList(), [
        'Zeladoria',
        'Áudio',
      ]);

      final loaded = await repository.findById('cat-a');
      expect(loaded?.description, 'Som');

      final updated = audio.copyWith(name: 'Áudio Pro');
      await repository.update(updated);
      expect((await repository.findById('cat-a'))?.name, 'Áudio Pro');

      await repository.delete('cat-a');
      expect(await repository.findById('cat-a'), isNull);
      expect((await repository.listAll()).single.id, 'cat-z');
    });

    test('update and delete throw when category does not exist', () async {
      final missing = buildCategory(id: 'missing', name: 'Fantasma');
      await expectLater(repository.update(missing), throwsStateError);
      await expectLater(repository.delete('missing'), throwsStateError);
    });

    test('close and reopen keeps persisted categories', () async {
      await repository.insert(
        buildCategory(id: 'cat-persisted', name: 'Persistida'),
      );
      await database.close();

      final reopenedDb = AppDatabase.forTesting(dbFile);
      addTearDown(reopenedDb.close);
      final reopenedRepository = DriftEquipmentCategoryRepository(reopenedDb);

      expect((await reopenedRepository.listAll()).single.name, 'Persistida');
    });
  });
}
