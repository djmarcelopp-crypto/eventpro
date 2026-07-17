part of '../app_database.dart';

@DriftAccessor(tables: [TeamMembers])
class TeamMembersDao extends DatabaseAccessor<AppDatabase>
    with _$TeamMembersDaoMixin {
  TeamMembersDao(super.db);

  Future<List<TeamMemberRow>> getAllOrdered() {
    return (select(teamMembers)..orderBy([
          (row) => OrderingTerm.asc(row.name),
        ]))
        .get();
  }

  Future<TeamMemberRow?> getById(String id) {
    return (select(
      teamMembers,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertRow(TeamMembersCompanion row) {
    return into(teamMembers).insert(row);
  }

  Future<bool> updateRow(TeamMembersCompanion row) {
    return update(teamMembers).replace(row);
  }

  Future<bool> deleteById(String id) {
    return (delete(
      teamMembers,
    )..where((row) => row.id.equals(id))).go().then((rows) => rows > 0);
  }
}
