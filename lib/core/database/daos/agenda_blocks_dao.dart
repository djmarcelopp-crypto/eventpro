part of '../app_database.dart';

@DriftAccessor(tables: [AgendaBlocks])
class AgendaBlocksDao extends DatabaseAccessor<AppDatabase>
    with _$AgendaBlocksDaoMixin {
  AgendaBlocksDao(super.db);

  Future<List<AgendaBlockRow>> getAllOrdered() {
    return (select(agendaBlocks)..orderBy([
          (row) => OrderingTerm.asc(row.start),
        ]))
        .get();
  }

  Future<AgendaBlockRow?> getById(String id) {
    return (select(
      agendaBlocks,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertRow(AgendaBlocksCompanion row) {
    return into(agendaBlocks).insert(row);
  }

  Future<bool> updateRow(AgendaBlocksCompanion row) {
    return update(agendaBlocks).replace(row);
  }

  Future<bool> deleteById(String id) {
    return (delete(
      agendaBlocks,
    )..where((row) => row.id.equals(id))).go().then((rows) => rows > 0);
  }
}
