import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/team/data/mappers/team_member_mapper.dart';
import 'package:eventpro/features/team/data/mappers/team_role_mapper.dart';
import 'package:eventpro/features/team/models/team_member.dart';
import 'package:eventpro/features/team/models/team_member_status.dart';
import 'package:eventpro/features/team/models/team_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TeamMemberMapper', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;

    final createdAt = DateTime(2026, 7, 1, 12);
    final updatedAt = DateTime(2026, 7, 2, 15);

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('team_member_mapper_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      await database.into(database.teamRoles).insert(
            TeamRoleMapper.toInsertCompanion(
              TeamRole(
                id: 'role-1',
                name: 'DJ',
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

    Future<TeamMember> persistAndReload(TeamMember member) async {
      await database
          .into(database.teamMembers)
          .insert(TeamMemberMapper.toInsertCompanion(member));
      final row = await (database.select(database.teamMembers)
            ..where((tbl) => tbl.id.equals(member.id)))
          .getSingle();
      return TeamMemberMapper.toDomain(row);
    }

    test('round-trips fields, status name and empty observations as null',
        () async {
      final original = TeamMember(
        id: 'member-1',
        name: 'Ana',
        phone: '11999999999',
        email: 'ana@example.com',
        roleId: 'role-1',
        observations: 'Nota',
        dailyRate: 25_000,
        status: TeamMemberStatus.unavailable,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final companion = TeamMemberMapper.toInsertCompanion(original);
      expect(companion.status.value, 'unavailable');
      expect(companion.observations.value, 'Nota');

      final restored = await persistAndReload(original);
      expect(restored, original);

      await database.teamMembersDao.deleteById('member-1');

      final emptyObs = TeamMember(
        id: 'member-2',
        name: 'Bruno',
        phone: '11888888888',
        roleId: 'role-1',
        observations: '',
        dailyRate: 0,
        status: TeamMemberStatus.active,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final emptyCompanion = TeamMemberMapper.toInsertCompanion(emptyObs);
      expect(emptyCompanion.observations.value, isNull);

      final restoredEmpty = await persistAndReload(emptyObs);
      expect(restoredEmpty.observations, '');
      expect(restoredEmpty.email, isNull);
    });
  });
}
