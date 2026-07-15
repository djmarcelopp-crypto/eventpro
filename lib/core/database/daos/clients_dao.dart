part of '../app_database.dart';

@DriftAccessor(tables: [Clients])
class ClientsDao extends DatabaseAccessor<AppDatabase> with _$ClientsDaoMixin {
  ClientsDao(super.db);

  Future<List<ClientRow>> getAllOrdered() {
    return (select(clients)..orderBy([
          (row) => OrderingTerm.asc(row.createdAt),
          (row) => OrderingTerm.asc(row.id),
        ]))
        .get();
  }

  Future<ClientRow?> getById(String id) {
    return (select(
      clients,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertRow(ClientsCompanion row) {
    return into(clients).insert(row);
  }

  Future<bool> updateRow(ClientsCompanion row) {
    return update(clients).replace(row).then((_) => true);
  }

  Future<bool> deleteById(String id) {
    return (delete(
      clients,
    )..where((row) => row.id.equals(id))).go().then((rows) => rows > 0);
  }
}
