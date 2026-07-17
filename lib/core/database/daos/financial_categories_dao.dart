part of '../app_database.dart';

@DriftAccessor(tables: [FinancialCategories])
class FinancialCategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$FinancialCategoriesDaoMixin {
  FinancialCategoriesDao(super.db);

  Future<List<FinancialCategoryRow>> getAllOrdered() {
    return (select(financialCategories)..orderBy([
          (row) => OrderingTerm.asc(row.name),
        ]))
        .get();
  }

  Future<FinancialCategoryRow?> getById(String id) {
    return (select(
      financialCategories,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertRow(FinancialCategoriesCompanion row) {
    return into(financialCategories).insert(row);
  }

  Future<bool> updateRow(FinancialCategoriesCompanion row) {
    return update(financialCategories).replace(row);
  }

  Future<bool> deleteById(String id) {
    return (delete(
      financialCategories,
    )..where((row) => row.id.equals(id))).go().then((rows) => rows > 0);
  }
}
