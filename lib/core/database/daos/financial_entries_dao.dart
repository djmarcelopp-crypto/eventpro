part of '../app_database.dart';

@DriftAccessor(tables: [FinancialEntries])
class FinancialEntriesDao extends DatabaseAccessor<AppDatabase>
    with _$FinancialEntriesDaoMixin {
  FinancialEntriesDao(super.db);

  Future<List<FinancialEntryRow>> getAllOrdered() {
    return (select(financialEntries)..orderBy([
          (row) => OrderingTerm.asc(row.date),
        ]))
        .get();
  }

  Future<FinancialEntryRow?> getById(String id) {
    return (select(
      financialEntries,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertRow(FinancialEntriesCompanion row) {
    return into(financialEntries).insert(row);
  }

  Future<bool> updateRow(FinancialEntriesCompanion row) {
    return update(financialEntries).replace(row);
  }

  Future<bool> deleteById(String id) {
    return (delete(
      financialEntries,
    )..where((row) => row.id.equals(id))).go().then((rows) => rows > 0);
  }
}
