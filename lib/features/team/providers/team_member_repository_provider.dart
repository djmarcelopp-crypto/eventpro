import 'package:eventpro/core/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/drift_team_member_repository.dart';
import '../data/repositories/team_member_repository.dart';

final teamMemberRepositoryProvider = Provider<TeamMemberRepository>((ref) {
  return DriftTeamMemberRepository(ref.watch(appDatabaseProvider));
});
