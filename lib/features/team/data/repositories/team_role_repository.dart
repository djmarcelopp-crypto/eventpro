import 'package:eventpro/features/team/models/team_role.dart';

/// Domain contract for persisting [TeamRole] records.
///
/// Storage-agnostic: no Drift (or other) implementation in this checkpoint.
abstract class TeamRoleRepository {
  Future<List<TeamRole>> listAll();

  Future<TeamRole?> findById(String id);

  Future<void> insert(TeamRole role);

  Future<void> update(TeamRole role);

  Future<void> delete(String id);
}
