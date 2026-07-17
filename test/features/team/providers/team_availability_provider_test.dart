import 'package:eventpro/features/team/models/team_availability.dart';
import 'package:eventpro/features/team/providers/team_availability_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_quote_team_repository.dart';
import '../fakes/fake_team_member_repository.dart';
import '../fakes/fake_team_role_repository.dart';
import '../fakes/team_repository_test_overrides.dart';
import '../team_test_helpers.dart';

void main() {
  group('teamAvailabilityProvider', () {
    test('exposes available members and empty summary conflicts', () async {
      final container = ProviderContainer(
        overrides: teamRepositoryOverrides(
          memberRepository: FakeTeamMemberRepository(
            initialMembers: [buildTestMember()],
          ),
          roleRepository: FakeTeamRoleRepository(
            initialRoles: [buildTestRole()],
          ),
          quoteTeamRepository: FakeQuoteTeamRepository(),
        ),
      );
      addTearDown(container.dispose);

      final items = await container.read(teamAvailabilityProvider.future);
      expect(items, hasLength(1));
      expect(items.single.status, TeamAvailabilityStatus.available);

      final summary =
          await container.read(teamAvailabilitySummaryProvider.future);
      expect(summary.totalMembers, 1);
      expect(summary.availableCount, 1);
      expect(summary.conflictCount, 0);
      expect(summary.availabilityPercent, 100);
    });
  });
}
