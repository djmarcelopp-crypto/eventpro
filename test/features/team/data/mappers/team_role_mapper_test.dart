import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/team/data/mappers/team_role_mapper.dart';
import 'package:eventpro/features/team/models/team_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TeamRoleMapper', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;

    final createdAt = DateTime(2026, 7, 1, 12);
    final updatedAt = DateTime(2026, 7, 2, 15);

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('team_role_mapper_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    Future<TeamRole> persistAndReload(TeamRole role) async {
      await database
          .into(database.teamRoles)
          .insert(TeamRoleMapper.toInsertCompanion(role));
      final row = await (database.select(database.teamRoles)
            ..where((tbl) => tbl.id.equals(role.id)))
          .getSingle();
      return TeamRoleMapper.toDomain(row);
    }

    test('round-trips all fields including nullable description', () async {
      final withDescription = TeamRole(
        id: 'role-1',
        name: 'DJ',
        description: 'Mixagem',
        active: true,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final restored = await persistAndReload(withDescription);
      expect(restored, withDescription);

      await database.teamRolesDao.deleteById('role-1');

      final withoutDescription = TeamRole(
        id: 'role-2',
        name: 'Sonoplasta',
        active: false,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final restored2 = await persistAndReload(withoutDescription);
      expect(restored2.description, isNull);
      expect(restored2.active, isFalse);
    });
  });
}
