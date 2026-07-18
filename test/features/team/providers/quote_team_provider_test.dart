import 'package:eventpro/features/team/models/quote_team_write_result.dart';
import 'package:eventpro/features/team/models/team_member_status.dart';
import 'package:eventpro/features/team/providers/quote_team_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../quotes/fakes/fake_quote_repository.dart';
import '../fakes/fake_quote_team_repository.dart';
import '../fakes/fake_team_member_repository.dart';
import '../fakes/fake_team_role_repository.dart';
import '../fakes/team_repository_test_overrides.dart';
import '../team_test_helpers.dart';

void main() {
  group('QuoteTeamNotifier', () {
    late FakeQuoteTeamRepository linkRepository;
    late FakeTeamMemberRepository memberRepository;
    late FakeTeamRoleRepository roleRepository;
    late FakeQuoteRepository quoteRepository;
    late ProviderContainer container;
    final fixedNow = DateTime(2030, 1, 1, 12);

    setUp(() async {
      linkRepository = FakeQuoteTeamRepository();
      memberRepository = FakeTeamMemberRepository(
        initialMembers: [
          buildTestMember(),
          buildTestMember(
            id: 'member-2',
            name: 'Bruno',
            dailyRate: 15_000,
          ),
        ],
      );
      roleRepository = FakeTeamRoleRepository(
        initialRoles: [buildTestRole()],
      );
      quoteRepository = FakeQuoteRepository(
        initialQuotes: [buildTestQuote()],
      );
      container = ProviderContainer(
        overrides: teamRepositoryOverrides(
          memberRepository: memberRepository,
          roleRepository: roleRepository,
          quoteTeamRepository: linkRepository,
          quoteRepository: quoteRepository,
          clock: () => fixedNow,
        ),
      );
      await container.read(quoteTeamProvider('quote-1').future);
    });

    tearDown(() => container.dispose());

    test('add and remove update state and summary cost', () async {
      final added = await container
          .read(quoteTeamProvider('quote-1').notifier)
          .add(teamMemberId: 'member-1');
      expect(added.isSuccess, isTrue);
      expect(added.status, QuoteTeamWriteStatus.success);

      await container
          .read(quoteTeamProvider('quote-1').notifier)
          .add(teamMemberId: 'member-2');

      final summary =
          container.read(quoteTeamProvider('quote-1').notifier).summary;
      expect(summary.lineCount, 2);
      expect(summary.totalCostCents, 40_000);

      final duplicate = await container
          .read(quoteTeamProvider('quote-1').notifier)
          .add(teamMemberId: 'member-1');
      expect(duplicate.status, QuoteTeamWriteStatus.duplicateMember);

      final removed = await container
          .read(quoteTeamProvider('quote-1').notifier)
          .remove(added.item!.id);
      expect(removed.isDeleted, isTrue);
      expect(container.read(quoteTeamProvider('quote-1')).value, hasLength(1));
    });

    test('rejects inactive member', () async {
      await memberRepository.update(
        buildTestMember(status: TeamMemberStatus.inactive),
      );

      final result = await container
          .read(quoteTeamProvider('quote-1').notifier)
          .add(teamMemberId: 'member-1');

      expect(result.status, QuoteTeamWriteStatus.memberInactive);
    });
  });
}
