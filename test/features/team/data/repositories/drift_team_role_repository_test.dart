import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/team/data/repositories/drift_team_role_repository.dart';
import 'package:eventpro/features/team/models/team_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriftTeamRoleRepository', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;
    late DriftTeamRoleRepository repository;

    final createdAt = DateTime(2026, 7, 1, 9);
    final updatedAt = DateTime(2026, 7, 1, 9);

    TeamRole buildRole({
      required String id,
      required String name,
      bool active = true,
      String? description,
    }) {
      return TeamRole(
        id: id,
        name: name,
        description: description,
        active: active,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    }

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('team_role_repo_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      repository = DriftTeamRoleRepository(database);
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('CRUD persists fields and orders by name', () async {
      await repository.insert(buildRole(id: 'role-z', name: 'Zebra'));
      await repository.insert(
        buildRole(id: 'role-a', name: 'Alpha', description: 'Lead'),
      );

      final listed = await repository.listAll();
      expect(listed.map((item) => item.name).toList(), ['Alpha', 'Zebra']);

      final loaded = await repository.findById('role-a');
      expect(loaded?.description, 'Lead');

      final updated = loaded!.copyWith(active: false);
      await repository.update(updated);
      expect((await repository.findById('role-a'))?.active, isFalse);

      await repository.delete('role-a');
      expect(await repository.findById('role-a'), isNull);
      expect((await repository.listAll()).single.id, 'role-z');
    });

    test('update and delete throw when role does not exist', () async {
      final missing = buildRole(id: 'missing', name: 'Fantasma');
      await expectLater(repository.update(missing), throwsStateError);
      await expectLater(repository.delete('missing'), throwsStateError);
    });

    test('close and reopen keeps persisted role', () async {
      await repository.insert(buildRole(id: 'role-p', name: 'Persistido'));
      await database.close();

      final reopenedDb = AppDatabase.forTesting(dbFile);
      addTearDown(reopenedDb.close);
      final reopenedRepository = DriftTeamRoleRepository(reopenedDb);

      expect((await reopenedRepository.listAll()).single.name, 'Persistido');
    });
  });
}
