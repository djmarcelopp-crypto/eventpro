part of '../app_database.dart';

@DriftAccessor(tables: [ContractTemplates])
class ContractTemplatesDao extends DatabaseAccessor<AppDatabase>
    with _$ContractTemplatesDaoMixin {
  ContractTemplatesDao(super.db);

  Future<List<ContractTemplateRow>> getAllOrdered() {
    return (select(contractTemplates)..orderBy([
          (row) => OrderingTerm.asc(row.name),
        ]))
        .get();
  }

  Future<ContractTemplateRow?> getById(String id) {
    return (select(
      contractTemplates,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertRow(ContractTemplatesCompanion row) {
    return into(contractTemplates).insert(row);
  }

  Future<bool> updateRow(ContractTemplatesCompanion row) {
    return update(contractTemplates).replace(row);
  }

  Future<bool> deleteById(String id) {
    return (delete(
      contractTemplates,
    )..where((row) => row.id.equals(id))).go().then((rows) => rows > 0);
  }
}
