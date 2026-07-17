import 'package:eventpro/features/quotes/providers/quote_repository_provider.dart';
import 'package:eventpro/features/team/providers/quote_team_repository_provider.dart';
import 'package:eventpro/features/team/providers/team_clock_provider.dart';
import 'package:eventpro/features/team/providers/team_member_repository_provider.dart';
import 'package:eventpro/features/team/providers/team_role_repository_provider.dart';
import 'package:flutter_riverpod/misc.dart';

import '../../quotes/fakes/fake_quote_repository.dart';
import 'fake_quote_team_repository.dart';
import 'fake_team_member_repository.dart';
import 'fake_team_role_repository.dart';

List<Override> teamRepositoryOverrides({
  FakeTeamMemberRepository? memberRepository,
  FakeTeamRoleRepository? roleRepository,
  FakeQuoteTeamRepository? quoteTeamRepository,
  FakeQuoteRepository? quoteRepository,
  DateTime Function()? clock,
}) {
  return [
    teamMemberRepositoryProvider.overrideWithValue(
      memberRepository ?? FakeTeamMemberRepository(),
    ),
    teamRoleRepositoryProvider.overrideWithValue(
      roleRepository ?? FakeTeamRoleRepository(),
    ),
    quoteTeamRepositoryProvider.overrideWithValue(
      quoteTeamRepository ?? FakeQuoteTeamRepository(),
    ),
    quoteRepositoryProvider.overrideWithValue(
      quoteRepository ?? FakeQuoteRepository(),
    ),
    if (clock != null) teamClockProvider.overrideWithValue(clock),
  ];
}
