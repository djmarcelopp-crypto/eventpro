part of '../app_database.dart';

@DriftAccessor(tables: [EquipmentCategories])
class EquipmentCategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$EquipmentCategoriesDaoMixin {
  EquipmentCategoriesDao(super.db);

  Future<List<EquipmentCategoryRow>> getAllOrdered() {
    return (select(equipmentCategories)..orderBy([
          (row) => OrderingTerm.asc(row.name),
        ]))
        .get();
  }

  Future<EquipmentCategoryRow?> getById(String id) {
    return (select(
      equipmentCategories,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertRow(EquipmentCategoriesCompanion row) {
    return into(equipmentCategories).insert(row);
  }

  Future<bool> updateRow(EquipmentCategoriesCompanion row) {
    return update(equipmentCategories).replace(row);
  }

  Future<bool> deleteById(String id) {
    return (delete(
      equipmentCategories,
    )..where((row) => row.id.equals(id))).go().then((rows) => rows > 0);
  }
}
