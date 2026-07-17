import 'package:eventpro/features/quotes/providers/quote_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/team_availability_service.dart';
import 'quote_team_repository_provider.dart';
import 'team_member_repository_provider.dart';

final teamAvailabilityServiceProvider = Provider<TeamAvailabilityService>((
  ref,
) {
  return TeamAvailabilityService(
    memberRepository: ref.watch(teamMemberRepositoryProvider),
    quoteTeamRepository: ref.watch(quoteTeamRepositoryProvider),
    quoteRepository: ref.watch(quoteRepositoryProvider),
  );
});
