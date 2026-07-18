import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/team/data/mappers/quote_team_member_mapper.dart';
import 'package:eventpro/features/team/data/repositories/quote_team_repository.dart';
import 'package:eventpro/features/team/models/quote_team_member.dart';

/// Drift-backed persistence for [QuoteTeamMember]. No business rules.
class DriftQuoteTeamRepository implements QuoteTeamRepository {
  DriftQuoteTeamRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<QuoteTeamMember>> listAll() async {
    final rows = await _database.quoteTeamMembersDao.getAllOrdered();
    return rows.map(QuoteTeamMemberMapper.toDomain).toList(growable: false);
  }

  @override
  Future<QuoteTeamMember?> findById(String id) async {
    final row = await _database.quoteTeamMembersDao.getById(id);
    if (row == null) {
      return null;
    }
    return QuoteTeamMemberMapper.toDomain(row);
  }

  @override
  Future<List<QuoteTeamMember>> listByQuoteId(String quoteId) async {
    final rows =
        await _database.quoteTeamMembersDao.getAllByQuoteId(quoteId);
    return rows.map(QuoteTeamMemberMapper.toDomain).toList(growable: false);
  }

  @override
  Future<void> insert(QuoteTeamMember item) async {
    await _database.quoteTeamMembersDao.insertRow(
      QuoteTeamMemberMapper.toInsertCompanion(item),
    );
  }

  @override
  Future<void> update(QuoteTeamMember item) async {
    final updated = await _database.quoteTeamMembersDao.updateRow(
      QuoteTeamMemberMapper.toUpdateCompanion(item),
    );
    if (!updated) {
      throw StateError('QuoteTeamMember not found for update: ${item.id}');
    }
  }

  @override
  Future<void> delete(String id) async {
    final deleted = await _database.quoteTeamMembersDao.deleteById(id);
    if (!deleted) {
      throw StateError('QuoteTeamMember not found for delete: $id');
    }
  }
}
