part of '../app_database.dart';

@DriftAccessor(tables: [QuoteTeamMembers])
class QuoteTeamMembersDao extends DatabaseAccessor<AppDatabase>
    with _$QuoteTeamMembersDaoMixin {
  QuoteTeamMembersDao(super.db);

  Future<List<QuoteTeamMemberRow>> getAllOrdered() {
    return (select(quoteTeamMembers)..orderBy([
          (row) => OrderingTerm.asc(row.createdAt),
        ]))
        .get();
  }

  Future<QuoteTeamMemberRow?> getById(String id) {
    return (select(
      quoteTeamMembers,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<List<QuoteTeamMemberRow>> getAllByQuoteId(String quoteId) {
    return (select(quoteTeamMembers)
          ..where((row) => row.quoteId.equals(quoteId))
          ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
        .get();
  }

  Future<void> insertRow(QuoteTeamMembersCompanion row) {
    return into(quoteTeamMembers).insert(row);
  }

  Future<bool> updateRow(QuoteTeamMembersCompanion row) {
    return update(quoteTeamMembers).replace(row);
  }

  Future<bool> deleteById(String id) {
    return (delete(
      quoteTeamMembers,
    )..where((row) => row.id.equals(id))).go().then((rows) => rows > 0);
  }
}
