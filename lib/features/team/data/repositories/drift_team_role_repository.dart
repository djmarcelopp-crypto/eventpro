import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/team/data/mappers/team_role_mapper.dart';
import 'package:eventpro/features/team/data/repositories/team_role_repository.dart';
import 'package:eventpro/features/team/models/team_role.dart';

/// Drift-backed persistence for [TeamRole]. No business rules — only
/// read/write via DAO + mapper.
class DriftTeamRoleRepository implements TeamRoleRepository {
  DriftTeamRoleRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<TeamRole>> listAll() async {
    final rows = await _database.teamRolesDao.getAllOrdered();
    return rows.map(TeamRoleMapper.toDomain).toList(growable: false);
  }

  @override
  Future<TeamRole?> findById(String id) async {
    final row = await _database.teamRolesDao.getById(id);
    if (row == null) {
      return null;
    }
    return TeamRoleMapper.toDomain(row);
  }

  @override
  Future<void> insert(TeamRole role) async {
    await _database.teamRolesDao.insertRow(
      TeamRoleMapper.toInsertCompanion(role),
    );
  }

  @override
  Future<void> update(TeamRole role) async {
    final updated = await _database.teamRolesDao.updateRow(
      TeamRoleMapper.toUpdateCompanion(role),
    );
    if (!updated) {
      throw StateError('TeamRole not found for update: ${role.id}');
    }
  }

  @override
  Future<void> delete(String id) async {
    final deleted = await _database.teamRolesDao.deleteById(id);
    if (!deleted) {
      throw StateError('TeamRole not found for delete: $id');
    }
  }
}
