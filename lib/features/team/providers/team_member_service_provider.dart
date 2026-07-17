import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/team_member_service.dart';
import 'team_clock_provider.dart';
import 'team_member_repository_provider.dart';
import 'team_role_repository_provider.dart';

final teamMemberServiceProvider = Provider<TeamMemberService>((ref) {
  return TeamMemberService(
    memberRepository: ref.watch(teamMemberRepositoryProvider),
    roleRepository: ref.watch(teamRoleRepositoryProvider),
    clock: ref.watch(teamClockProvider),
  );
});
