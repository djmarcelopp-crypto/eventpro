import 'package:eventpro/features/team/models/team_member.dart';
import 'package:eventpro/features/team/models/team_member_status.dart';
import 'package:eventpro/features/team/models/team_operation_result.dart';
import 'package:eventpro/features/team/models/team_role.dart';
import 'package:eventpro/features/team/utils/team_member_service.dart';
import 'package:eventpro/features/team/utils/team_member_validator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_team_member_repository.dart';
import '../fakes/fake_team_role_repository.dart';

void main() {
  group('TeamMemberService', () {
    late FakeTeamRoleRepository roleRepository;
    late FakeTeamMemberRepository memberRepository;
    final fixedNow = DateTime(2030, 1, 1, 12, 0);
    final earlier = DateTime(2020, 1, 1);

    TeamMemberService buildService({DateTime? now}) {
      return TeamMemberService(
        memberRepository: memberRepository,
        roleRepository: roleRepository,
        clock: () => now ?? fixedNow,
      );
    }

    TeamRole buildRole({
      String id = 'role-1',
      bool active = true,
    }) {
      return TeamRole(
        id: id,
        name: 'DJ',
        active: active,
        createdAt: earlier,
        updatedAt: earlier,
      );
    }

    TeamMember buildDraft({
      String id = '',
      String name = 'Ana Silva',
      String phone = '11999999999',
      String roleId = 'role-1',
      int dailyRate = 25_000,
      TeamMemberStatus status = TeamMemberStatus.active,
      DateTime? createdAt,
      DateTime? updatedAt,
    }) {
      return TeamMember(
        id: id,
        name: name,
        phone: phone,
        roleId: roleId,
        dailyRate: dailyRate,
        status: status,
        createdAt: createdAt ?? earlier,
        updatedAt: updatedAt ?? earlier,
      );
    }

    setUp(() async {
      roleRepository = FakeTeamRoleRepository();
      memberRepository = FakeTeamMemberRepository();
      await roleRepository.insert(buildRole());
    });

    group('create', () {
      test('persists a valid member using the injectable clock', () async {
        final result = await buildService().create(buildDraft());

        expect(result.isSuccess, isTrue);
        expect(result.member!.id, isNotEmpty);
        expect(result.member!.createdAt, fixedNow);
        expect(result.member!.updatedAt, fixedNow);
        expect(result.member!.status, TeamMemberStatus.active);
        expect(await memberRepository.findById(result.member!.id), isNotNull);
      });

      test('rejects blank name without persisting', () async {
        final result = await buildService().create(buildDraft(name: ' '));

        expect(result.status, TeamOperationStatus.validationFailed);
        expect(
          result.errors,
          contains(TeamMemberValidator.nameRequiredError),
        );
        expect(await memberRepository.listAll(), isEmpty);
      });

      test('rejects an unknown roleId', () async {
        final result = await buildService().create(
          buildDraft(roleId: 'missing-role'),
        );

        expect(result.status, TeamOperationStatus.roleNotFound);
        expect(await memberRepository.listAll(), isEmpty);
      });

      test('rejects an inactive role', () async {
        await roleRepository.update(buildRole(active: false));

        final result = await buildService().create(buildDraft());

        expect(result.status, TeamOperationStatus.roleInactive);
        expect(await memberRepository.listAll(), isEmpty);
      });

      test('rejects invalid daily rate', () async {
        final result = await buildService().create(buildDraft(dailyRate: -1));

        expect(result.status, TeamOperationStatus.validationFailed);
        expect(
          result.errors,
          contains(TeamMemberValidator.dailyRateNonNegativeError),
        );
        expect(await memberRepository.listAll(), isEmpty);
      });

      test('rejects invalid status name via the shared validator', () async {
        // Entity status is a closed enum; invalid raw names are rejected by
        // the same validator the service uses for field checks.
        final fields = TeamMemberValidator.validateFields(
          name: 'Ana',
          roleId: 'role-1',
          dailyRate: 1000,
          statusName: 'not-a-status',
        );

        expect(fields.isValid, isFalse);
        expect(
          fields.errors,
          contains(TeamMemberValidator.statusInvalidError),
        );

        final result = await buildService().create(
          buildDraft(status: TeamMemberStatus.unavailable),
        );
        expect(result.isSuccess, isTrue);
        expect(result.member!.status, TeamMemberStatus.unavailable);
      });
    });

    group('update', () {
      test('preserves createdAt and refreshes updatedAt via clock', () async {
        final created =
            (await buildService(now: earlier).create(buildDraft())).member!;
        final later = DateTime(2031, 6, 15, 8);

        final result = await buildService(now: later).update(
          created.copyWith(name: 'Ana Costa', dailyRate: 30_000),
        );

        expect(result.isSuccess, isTrue);
        expect(result.member!.id, created.id);
        expect(result.member!.createdAt, earlier);
        expect(result.member!.updatedAt, later);
        expect(result.member!.name, 'Ana Costa');
        expect(result.member!.dailyRate, 30_000);
      });

      test('returns notFound for unknown id', () async {
        final result = await buildService().update(
          buildDraft(id: 'missing', name: 'Fantasma'),
        );

        expect(result.status, TeamOperationStatus.notFound);
      });

      test('rejects inactive role on update', () async {
        final created =
            (await buildService().create(buildDraft())).member!;
        await roleRepository.update(buildRole(active: false));

        final result = await buildService().update(
          created.copyWith(name: 'Novo nome'),
        );

        expect(result.status, TeamOperationStatus.roleInactive);
      });
    });

    group('delete', () {
      test('deletes an existing member', () async {
        final created =
            (await buildService().create(buildDraft())).member!;

        final result = await buildService().delete(created.id);

        expect(result.status, TeamOperationStatus.deleted);
        expect(result.isDeleted, isTrue);
        expect(await memberRepository.findById(created.id), isNull);
      });

      test('returns notFound for unknown id', () async {
        final result = await buildService().delete('missing');

        expect(result.status, TeamOperationStatus.notFound);
      });
    });
  });
}
