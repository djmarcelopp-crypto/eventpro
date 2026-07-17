import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/team/data/mappers/team_member_mapper.dart';
import 'package:eventpro/features/team/data/repositories/team_member_repository.dart';
import 'package:eventpro/features/team/models/team_member.dart';

/// Drift-backed persistence for [TeamMember]. No business rules — only
/// read/write via DAO + mapper.
class DriftTeamMemberRepository implements TeamMemberRepository {
  DriftTeamMemberRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<TeamMember>> listAll() async {
    final rows = await _database.teamMembersDao.getAllOrdered();
    return rows.map(TeamMemberMapper.toDomain).toList(growable: false);
  }

  @override
  Future<TeamMember?> findById(String id) async {
    final row = await _database.teamMembersDao.getById(id);
    if (row == null) {
      return null;
    }
    return TeamMemberMapper.toDomain(row);
  }

  @override
  Future<void> insert(TeamMember member) async {
    await _database.teamMembersDao.insertRow(
      TeamMemberMapper.toInsertCompanion(member),
    );
  }

  @override
  Future<void> update(TeamMember member) async {
    final updated = await _database.teamMembersDao.updateRow(
      TeamMemberMapper.toUpdateCompanion(member),
    );
    if (!updated) {
      throw StateError('TeamMember not found for update: ${member.id}');
    }
  }

  @override
  Future<void> delete(String id) async {
    final deleted = await _database.teamMembersDao.deleteById(id);
    if (!deleted) {
      throw StateError('TeamMember not found for delete: $id');
    }
  }
}
