import 'package:eventpro/features/quotes/providers/quote_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/quote_team_service.dart';
import 'quote_team_repository_provider.dart';
import 'team_clock_provider.dart';
import 'team_member_repository_provider.dart';
import 'team_role_repository_provider.dart';

final quoteTeamServiceProvider = Provider<QuoteTeamService>((ref) {
  return QuoteTeamService(
    quoteTeamRepository: ref.watch(quoteTeamRepositoryProvider),
    teamMemberRepository: ref.watch(teamMemberRepositoryProvider),
    teamRoleRepository: ref.watch(teamRoleRepositoryProvider),
    quoteRepository: ref.watch(quoteRepositoryProvider),
    clock: ref.watch(teamClockProvider),
  );
});
