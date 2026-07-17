import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/team_role_service.dart';
import 'team_clock_provider.dart';
import 'team_member_repository_provider.dart';
import 'team_role_repository_provider.dart';

final teamRoleServiceProvider = Provider<TeamRoleService>((ref) {
  return TeamRoleService(
    roleRepository: ref.watch(teamRoleRepositoryProvider),
    memberRepository: ref.watch(teamMemberRepositoryProvider),
    clock: ref.watch(teamClockProvider),
  );
});
