import 'package:eventpro/features/team/models/team_member.dart';
import 'package:eventpro/features/team/models/team_member_status.dart';
import 'package:eventpro/features/team/models/team_role.dart';
import 'package:eventpro/features/team/models/team_role_operation_result.dart';
import 'package:eventpro/features/team/utils/team_role_service.dart';
import 'package:eventpro/features/team/utils/team_role_validator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_team_member_repository.dart';
import '../fakes/fake_team_role_repository.dart';

void main() {
  group('TeamRoleService', () {
    late FakeTeamRoleRepository roleRepository;
    late FakeTeamMemberRepository memberRepository;
    final fixedNow = DateTime(2030, 1, 1, 12, 0);
    final earlier = DateTime(2020, 1, 1);

    TeamRoleService buildService({DateTime? now}) {
      return TeamRoleService(
        roleRepository: roleRepository,
        memberRepository: memberRepository,
        clock: () => now ?? fixedNow,
      );
    }

    TeamRole buildDraft({
      String id = '',
      String name = 'DJ',
      String? description,
      bool active = true,
      DateTime? createdAt,
      DateTime? updatedAt,
    }) {
      return TeamRole(
        id: id,
        name: name,
        description: description,
        active: active,
        createdAt: createdAt ?? earlier,
        updatedAt: updatedAt ?? earlier,
      );
    }

    setUp(() {
      roleRepository = FakeTeamRoleRepository();
      memberRepository = FakeTeamMemberRepository();
    });

    group('create', () {
      test('persists a valid role using the injectable clock', () async {
        final result = await buildService().create(buildDraft());

        expect(result.isSuccess, isTrue);
        expect(result.role!.id, isNotEmpty);
        expect(result.role!.createdAt, fixedNow);
        expect(result.role!.updatedAt, fixedNow);
        expect(await roleRepository.findById(result.role!.id), isNotNull);
      });

      test('rejects blank name without persisting', () async {
        final result = await buildService().create(buildDraft(name: ' '));

        expect(
          result.status,
          TeamRoleOperationStatus.validationFailed,
        );
        expect(
          result.errors,
          contains(TeamRoleValidator.nameRequiredError),
        );
        expect(await roleRepository.listAll(), isEmpty);
      });

      test('rejects duplicate name case-insensitively', () async {
        await buildService().create(buildDraft(name: 'DJ'));

        final result = await buildService().create(buildDraft(name: ' dj '));

        expect(result.status, TeamRoleOperationStatus.duplicateName);
        expect(await roleRepository.listAll(), hasLength(1));
      });
    });

    group('update', () {
      test('preserves createdAt and refreshes updatedAt via clock', () async {
        final created =
            (await buildService(now: earlier).create(buildDraft())).role!;
        final later = DateTime(2031, 3, 10);
        final service = buildService(now: later);

        final result = await service.update(
          created.copyWith(name: 'DJ Principal'),
        );

        expect(result.isSuccess, isTrue);
        expect(result.role!.createdAt, earlier);
        expect(result.role!.updatedAt, later);
        expect(result.role!.name, 'DJ Principal');
      });

      test('rejects duplicate name belonging to another role', () async {
        final first =
            (await buildService().create(buildDraft(name: 'DJ'))).role!;
        final second =
            (await buildService().create(buildDraft(name: 'Sono'))).role!;

        final result = await buildService().update(
          second.copyWith(name: 'dj'),
        );

        expect(result.status, TeamRoleOperationStatus.duplicateName);
        expect(
          (await roleRepository.findById(second.id))!.name,
          'Sono',
        );
        expect(first.name, 'DJ');
      });

      test('returns notFound for unknown id', () async {
        final result = await buildService().update(
          buildDraft(id: 'missing', name: 'Fantasma'),
        );

        expect(result.status, TeamRoleOperationStatus.notFound);
      });
    });

    group('activation', () {
      test('activates a deactivated role', () async {
        final created = (await buildService(now: earlier).create(
          buildDraft(active: false),
        ))
            .role!;
        final later = DateTime(2031, 4, 1);

        final result = await buildService(now: later).activate(created.id);

        expect(result.isSuccess, isTrue);
        expect(result.role!.active, isTrue);
        expect(result.role!.createdAt, earlier);
        expect(result.role!.updatedAt, later);
      });

      test('deactivates an active role', () async {
        final created =
            (await buildService(now: earlier).create(buildDraft())).role!;
        final later = DateTime(2031, 4, 2);

        final result = await buildService(now: later).deactivate(created.id);

        expect(result.isSuccess, isTrue);
        expect(result.role!.active, isFalse);
        expect(result.role!.createdAt, earlier);
        expect(result.role!.updatedAt, later);
      });
    });

    group('delete', () {
      test('deletes a role with no linked members', () async {
        final created =
            (await buildService().create(buildDraft())).role!;

        final result = await buildService().delete(created.id);

        expect(result.status, TeamRoleOperationStatus.deleted);
        expect(result.isDeleted, isTrue);
        expect(await roleRepository.findById(created.id), isNull);
      });

      test('blocks deletion when a member uses the role', () async {
        final created =
            (await buildService().create(buildDraft())).role!;
        await memberRepository.insert(
          TeamMember(
            id: 'member-1',
            name: 'Ana',
            phone: '11999999999',
            roleId: created.id,
            dailyRate: 25_000,
            status: TeamMemberStatus.active,
            createdAt: earlier,
            updatedAt: earlier,
          ),
        );

        final result = await buildService().delete(created.id);

        expect(result.status, TeamRoleOperationStatus.blockedByUsage);
        expect(result.isBlockedByUsage, isTrue);
        expect(result.blockingMemberCount, 1);
        expect(await roleRepository.findById(created.id), isNotNull);
      });

      test('returns notFound for unknown id', () async {
        final result = await buildService().delete('missing');

        expect(result.status, TeamRoleOperationStatus.notFound);
      });
    });
  });
}
