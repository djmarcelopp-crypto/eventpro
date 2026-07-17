import 'package:eventpro/features/team/models/quote_team_delete_result.dart';
import 'package:eventpro/features/team/models/quote_team_write_result.dart';
import 'package:eventpro/features/team/models/team_member.dart';
import 'package:eventpro/features/team/models/team_member_status.dart';
import 'package:eventpro/features/team/models/team_role.dart';
import 'package:eventpro/features/team/utils/quote_team_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../quotes/fakes/fake_quote_repository.dart';
import '../../quotes/quotes_test_helpers.dart';
import '../fakes/fake_quote_team_repository.dart';
import '../fakes/fake_team_member_repository.dart';
import '../fakes/fake_team_role_repository.dart';

void main() {
  group('QuoteTeamService', () {
    late FakeQuoteTeamRepository linkRepository;
    late FakeTeamMemberRepository memberRepository;
    late FakeTeamRoleRepository roleRepository;
    late FakeQuoteRepository quoteRepository;
    final fixedNow = DateTime(2030, 1, 1, 12);
    final earlier = DateTime(2020, 1, 1);

    QuoteTeamService buildService({DateTime? now}) {
      return QuoteTeamService(
        quoteTeamRepository: linkRepository,
        teamMemberRepository: memberRepository,
        teamRoleRepository: roleRepository,
        quoteRepository: quoteRepository,
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

    TeamMember buildMember({
      String id = 'member-1',
      String roleId = 'role-1',
      int dailyRate = 25_000,
      TeamMemberStatus status = TeamMemberStatus.active,
    }) {
      return TeamMember(
        id: id,
        name: 'Ana',
        phone: '11999999999',
        roleId: roleId,
        dailyRate: dailyRate,
        status: status,
        createdAt: earlier,
        updatedAt: earlier,
      );
    }

    setUp(() async {
      linkRepository = FakeQuoteTeamRepository();
      memberRepository = FakeTeamMemberRepository();
      roleRepository = FakeTeamRoleRepository();
      quoteRepository = FakeQuoteRepository(
        initialQuotes: [buildMinimalQuoteAddDraft(id: 'quote-1')],
      );
      await roleRepository.insert(buildRole());
      await roleRepository.insert(buildRole(id: 'role-2'));
      await memberRepository.insert(buildMember());
      await memberRepository.insert(
        buildMember(id: 'member-2', roleId: 'role-2', dailyRate: 15_000),
      );
    });

    test('adds member to quote snapshotting role and daily rate', () async {
      final result = await buildService().add(
        quoteId: 'quote-1',
        teamMemberId: 'member-1',
        notes: '  Lead  ',
      );

      expect(result.isSuccess, isTrue);
      expect(result.item!.quoteId, 'quote-1');
      expect(result.item!.teamMemberId, 'member-1');
      expect(result.item!.roleId, 'role-1');
      expect(result.item!.dailyRate, 25_000);
      expect(result.item!.notes, 'Lead');
      expect(result.item!.createdAt, fixedNow);
      expect(result.item!.updatedAt, fixedNow);
    });

    test('lists team and computes total cost via summary', () async {
      final service = buildService();
      await service.add(quoteId: 'quote-1', teamMemberId: 'member-1');
      await service.add(quoteId: 'quote-1', teamMemberId: 'member-2');

      final listed = await service.listForQuote('quote-1');
      expect(listed, hasLength(2));

      final summary = await service.summaryForQuote('quote-1');
      expect(summary.lineCount, 2);
      expect(summary.totalCostCents, 40_000);
      expect(await service.totalCostCentsForQuote('quote-1'), 40_000);
    });

    test('removes a linked member', () async {
      final added = (await buildService().add(
        quoteId: 'quote-1',
        teamMemberId: 'member-1',
      ))
          .item!;

      final result = await buildService().remove(added.id);

      expect(result.status, QuoteTeamDeleteStatus.deleted);
      expect(await linkRepository.listAll(), isEmpty);
    });

    test('rejects duplicate member on the same quote', () async {
      await buildService().add(quoteId: 'quote-1', teamMemberId: 'member-1');

      final result = await buildService().add(
        quoteId: 'quote-1',
        teamMemberId: 'member-1',
      );

      expect(result.status, QuoteTeamWriteStatus.duplicateMember);
      expect(await linkRepository.listAll(), hasLength(1));
    });

    test('rejects unknown quote', () async {
      final result = await buildService().add(
        quoteId: 'missing-quote',
        teamMemberId: 'member-1',
      );

      expect(result.status, QuoteTeamWriteStatus.quoteNotFound);
    });

    test('rejects nonexistent member', () async {
      final result = await buildService().add(
        quoteId: 'quote-1',
        teamMemberId: 'missing-member',
      );

      expect(result.status, QuoteTeamWriteStatus.memberNotFound);
    });

    test('rejects inactive member', () async {
      await memberRepository.update(
        buildMember(status: TeamMemberStatus.inactive),
      );

      final result = await buildService().add(
        quoteId: 'quote-1',
        teamMemberId: 'member-1',
      );

      expect(result.status, QuoteTeamWriteStatus.memberInactive);
    });

    test('rejects nonexistent role', () async {
      await memberRepository.update(buildMember(roleId: 'missing-role'));

      final result = await buildService().add(
        quoteId: 'quote-1',
        teamMemberId: 'member-1',
      );

      expect(result.status, QuoteTeamWriteStatus.roleNotFound);
    });

    test('rejects inactive role', () async {
      await roleRepository.update(buildRole(active: false));

      final result = await buildService().add(
        quoteId: 'quote-1',
        teamMemberId: 'member-1',
      );

      expect(result.status, QuoteTeamWriteStatus.roleInactive);
    });
  });
}
