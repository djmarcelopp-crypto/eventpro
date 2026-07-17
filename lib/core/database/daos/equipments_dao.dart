part of '../app_database.dart';

@DriftAccessor(tables: [Equipments])
class EquipmentsDao extends DatabaseAccessor<AppDatabase>
    with _$EquipmentsDaoMixin {
  EquipmentsDao(super.db);

  Future<List<EquipmentRow>> getAllOrdered() {
    return (select(equipments)..orderBy([
          (row) => OrderingTerm.asc(row.name),
        ]))
        .get();
  }

  Future<EquipmentRow?> getById(String id) {
    return (select(
      equipments,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertRow(EquipmentsCompanion row) {
    return into(equipments).insert(row);
  }

  Future<bool> updateRow(EquipmentsCompanion row) {
    return update(equipments).replace(row);
  }

  Future<bool> deleteById(String id) {
    return (delete(
      equipments,
    )..where((row) => row.id.equals(id))).go().then((rows) => rows > 0);
  }
}
