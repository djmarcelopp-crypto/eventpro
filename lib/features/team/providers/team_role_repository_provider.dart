import 'package:eventpro/core/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/drift_team_role_repository.dart';
import '../data/repositories/team_role_repository.dart';

final teamRoleRepositoryProvider = Provider<TeamRoleRepository>((ref) {
  return DriftTeamRoleRepository(ref.watch(appDatabaseProvider));
});
