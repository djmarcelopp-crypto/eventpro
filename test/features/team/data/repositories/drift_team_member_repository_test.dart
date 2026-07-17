import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/team/data/repositories/drift_team_member_repository.dart';
import 'package:eventpro/features/team/data/repositories/drift_team_role_repository.dart';
import 'package:eventpro/features/team/models/team_member.dart';
import 'package:eventpro/features/team/models/team_member_status.dart';
import 'package:eventpro/features/team/models/team_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriftTeamMemberRepository', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;
    late DriftTeamMemberRepository repository;
    late DriftTeamRoleRepository roleRepository;

    final createdAt = DateTime(2026, 7, 1, 9);
    final updatedAt = DateTime(2026, 7, 1, 9);

    Future<void> seedRole() async {
      await roleRepository.insert(
        TeamRole(
          id: 'role-1',
          name: 'DJ',
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      );
    }

    TeamMember buildMember({
      required String id,
      required String name,
      TeamMemberStatus status = TeamMemberStatus.active,
      int dailyRate = 20_000,
      String roleId = 'role-1',
    }) {
      return TeamMember(
        id: id,
        name: name,
        phone: '11999999999',
        roleId: roleId,
        dailyRate: dailyRate,
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    }

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('team_member_repo_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      repository = DriftTeamMemberRepository(database);
      roleRepository = DriftTeamRoleRepository(database);
      await seedRole();
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('CRUD persists fields, status enum and orders by name', () async {
      final zebra = buildMember(id: 'm-z', name: 'Zebra');
      final alpha = buildMember(
        id: 'm-a',
        name: 'Alpha',
        status: TeamMemberStatus.inactive,
        dailyRate: 35_000,
      );

      await repository.insert(zebra);
      await repository.insert(alpha);

      final listed = await repository.listAll();
      expect(listed.map((item) => item.name).toList(), ['Alpha', 'Zebra']);

      final loaded = await repository.findById('m-a');
      expect(loaded?.status, TeamMemberStatus.inactive);
      expect(loaded?.dailyRate, 35_000);

      final updated = alpha.copyWith(dailyRate: 40_000);
      await repository.update(updated);
      expect((await repository.findById('m-a'))?.dailyRate, 40_000);

      await repository.delete('m-a');
      expect(await repository.findById('m-a'), isNull);
      expect((await repository.listAll()).single.id, 'm-z');
    });

    test('FK restrict blocks orphan insert and role delete while in use',
        () async {
      await repository.insert(buildMember(id: 'm-1', name: 'Ana'));

      final orphan = buildMember(
        id: 'm-bad',
        name: 'Sem role',
        roleId: 'missing-role',
      );
      await expectLater(repository.insert(orphan), throwsA(anything));
      await expectLater(roleRepository.delete('role-1'), throwsA(anything));
    });

    test('update and delete throw when member does not exist', () async {
      final missing = buildMember(id: 'missing', name: 'Fantasma');
      await expectLater(repository.update(missing), throwsStateError);
      await expectLater(repository.delete('missing'), throwsStateError);
    });

    test('close and reopen keeps persisted member', () async {
      await repository.insert(buildMember(id: 'm-p', name: 'Persistido'));
      await database.close();

      final reopenedDb = AppDatabase.forTesting(dbFile);
      addTearDown(reopenedDb.close);
      final reopenedRepository = DriftTeamMemberRepository(reopenedDb);

      expect(
        (await reopenedRepository.listAll()).single.name,
        'Persistido',
      );
    });
  });
}
