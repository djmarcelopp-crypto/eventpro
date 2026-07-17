import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TeamRolesDao / TeamMembersDao', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('team_dao_test_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('DAO CRUD for roles and members', () async {
      final rolesDao = database.teamRolesDao;
      final membersDao = database.teamMembersDao;

      await rolesDao.insertRow(
        TeamRolesCompanion.insert(
          id: 'role-1',
          name: 'DJ',
          active: true,
          createdAt: 1_700_000_000_000,
          updatedAt: 1_700_000_000_000,
        ),
      );

      expect((await rolesDao.getAllOrdered()).single.name, 'DJ');
      expect((await rolesDao.getById('role-1'))?.id, 'role-1');

      await membersDao.insertRow(
        TeamMembersCompanion.insert(
          id: 'member-1',
          name: 'Ana',
          phone: '11999999999',
          roleId: 'role-1',
          dailyRate: 25_000,
          status: 'active',
          createdAt: 1_700_000_000_000,
          updatedAt: 1_700_000_000_000,
        ),
      );

      expect((await membersDao.getAllOrdered()).single.dailyRate, 25_000);
      expect((await membersDao.getById('member-1'))?.status, 'active');

      final updated = await membersDao.updateRow(
        TeamMembersCompanion.insert(
          id: 'member-1',
          name: 'Ana Silva',
          phone: '11999999999',
          roleId: 'role-1',
          dailyRate: 30_000,
          status: 'unavailable',
          createdAt: 1_700_000_000_000,
          updatedAt: 1_700_000_100_000,
        ),
      );
      expect(updated, isTrue);
      expect((await membersDao.getById('member-1'))?.name, 'Ana Silva');

      expect(await membersDao.deleteById('member-1'), isTrue);
      expect(await membersDao.getById('member-1'), isNull);
      expect(await rolesDao.deleteById('role-1'), isTrue);
    });
  });
}
