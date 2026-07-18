import 'package:eventpro/features/team/models/team_member.dart';
import 'package:eventpro/features/team/models/team_member_status.dart';
import 'package:eventpro/features/team/models/team_operation_result.dart';
import 'package:eventpro/features/team/models/team_role_operation_result.dart';
import 'package:eventpro/features/team/providers/filtered_team_members_provider.dart';
import 'package:eventpro/features/team/providers/team_filters_provider.dart';
import 'package:eventpro/features/team/providers/team_member_provider.dart';
import 'package:eventpro/features/team/providers/team_role_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_team_member_repository.dart';
import '../fakes/fake_team_role_repository.dart';
import '../fakes/team_repository_test_overrides.dart';
import '../team_test_helpers.dart';

void main() {
  group('TeamMemberNotifier / TeamRoleNotifier', () {
    late FakeTeamMemberRepository memberRepository;
    late FakeTeamRoleRepository roleRepository;
    late ProviderContainer container;
    final fixedNow = DateTime(2030, 1, 1, 12);

    setUp(() async {
      memberRepository = FakeTeamMemberRepository();
      roleRepository = FakeTeamRoleRepository(
        initialRoles: [buildTestRole()],
      );
      container = ProviderContainer(
        overrides: teamRepositoryOverrides(
          memberRepository: memberRepository,
          roleRepository: roleRepository,
          clock: () => fixedNow,
        ),
      );
      await container.read(teamMemberProvider.future);
      await container.read(teamRoleProvider.future);
    });

    tearDown(() => container.dispose());

    test('addMember persists via service and updates state', () async {
      final result = await container.read(teamMemberProvider.notifier).addMember(
            TeamMember(
              id: '',
              name: 'Bruno',
              phone: '11888888888',
              roleId: 'role-dj',
              dailyRate: 20_000,
              status: TeamMemberStatus.active,
              createdAt: fixedNow,
              updatedAt: fixedNow,
            ),
          );

      expect(result.isSuccess, isTrue);
      expect(result.status, TeamOperationStatus.success);
      final items = container.read(teamMemberProvider).value!;
      expect(items, hasLength(1));
      expect(items.first.name, 'Bruno');
      expect(items.first.id, isNotEmpty);
    });

    test('updateMember and deleteMember update state', () async {
      final created = await container
          .read(teamMemberProvider.notifier)
          .addMember(buildTestMember(id: '', name: 'Carla'));
      final member = created.member!;

      final updated = await container
          .read(teamMemberProvider.notifier)
          .updateMember(
            member.copyWith(
              name: 'Carla Costa',
              status: TeamMemberStatus.unavailable,
            ),
          );
      expect(updated.isSuccess, isTrue);
      expect(
        container.read(teamMemberProvider).value!.first.name,
        'Carla Costa',
      );

      final deleted = await container
          .read(teamMemberProvider.notifier)
          .deleteMember(member.id);
      expect(deleted.isDeleted, isTrue);
      expect(container.read(teamMemberProvider).value, isEmpty);
    });

    test('filters apply role, status and name query', () async {
      container.read(teamMemberProvider.notifier).hydrate([
        buildTestMember(id: '1', name: 'Ana DJ'),
        buildTestMember(
          id: '2',
          name: 'Bruno Som',
          status: TeamMemberStatus.unavailable,
        ),
        buildTestMember(
          id: '3',
          name: 'Ana Luz',
          roleId: 'other',
        ),
      ]);

      container.read(teamFiltersProvider.notifier).setNameQuery('ana');
      expect(
        container.read(filteredTeamMembersProvider).value!.map((e) => e.id),
        ['1', '3'],
      );

      container
          .read(teamFiltersProvider.notifier)
          .setStatus(TeamMemberStatus.active);
      expect(
        container.read(filteredTeamMembersProvider).value!.map((e) => e.id),
        ['1', '3'],
      );

      container.read(teamFiltersProvider.notifier).setRoleId('role-dj');
      expect(
        container.read(filteredTeamMembersProvider).value!.map((e) => e.id),
        ['1'],
      );
    });

    test('activateRole and deactivateRole update state', () async {
      final role = container.read(teamRoleProvider).value!.first;

      final deactivated = await container
          .read(teamRoleProvider.notifier)
          .deactivateRole(role.id);
      expect(deactivated.isSuccess, isTrue);
      expect(container.read(teamRoleProvider).value!.first.active, isFalse);

      final activated = await container
          .read(teamRoleProvider.notifier)
          .activateRole(role.id);
      expect(activated.isSuccess, isTrue);
      expect(container.read(teamRoleProvider).value!.first.active, isTrue);
      expect(activated.status, TeamRoleOperationStatus.success);
    });
  });
}
