part of '../app_database.dart';

@DriftAccessor(tables: [TeamRoles])
class TeamRolesDao extends DatabaseAccessor<AppDatabase>
    with _$TeamRolesDaoMixin {
  TeamRolesDao(super.db);

  Future<List<TeamRoleRow>> getAllOrdered() {
    return (select(teamRoles)..orderBy([
          (row) => OrderingTerm.asc(row.name),
        ]))
        .get();
  }

  Future<TeamRoleRow?> getById(String id) {
    return (select(
      teamRoles,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertRow(TeamRolesCompanion row) {
    return into(teamRoles).insert(row);
  }

  Future<bool> updateRow(TeamRolesCompanion row) {
    return update(teamRoles).replace(row);
  }

  Future<bool> deleteById(String id) {
    return (delete(
      teamRoles,
    )..where((row) => row.id.equals(id))).go().then((rows) => rows > 0);
  }
}
