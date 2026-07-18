part of '../app_database.dart';

@DriftAccessor(tables: [Contracts])
class ContractsDao extends DatabaseAccessor<AppDatabase>
    with _$ContractsDaoMixin {
  ContractsDao(super.db);

  Future<List<ContractRow>> getAllOrdered() {
    return (select(contracts)..orderBy([
          (row) => OrderingTerm.desc(row.createdAt),
        ]))
        .get();
  }

  Future<ContractRow?> getById(String id) {
    return (select(
      contracts,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<List<ContractRow>> getByQuoteId(String quoteId) {
    return (select(contracts)
          ..where((row) => row.quoteId.equals(quoteId))
          ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]))
        .get();
  }

  Future<void> insertRow(ContractsCompanion row) {
    return into(contracts).insert(row);
  }

  Future<bool> updateRow(ContractsCompanion row) {
    return update(contracts).replace(row);
  }

  Future<bool> deleteById(String id) {
    return (delete(
      contracts,
    )..where((row) => row.id.equals(id))).go().then((rows) => rows > 0);
  }
}
