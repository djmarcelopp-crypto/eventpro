part of '../app_database.dart';

@DriftAccessor(tables: [VehicleTypes])
class VehicleTypesDao extends DatabaseAccessor<AppDatabase>
    with _$VehicleTypesDaoMixin {
  VehicleTypesDao(super.db);

  Future<List<VehicleTypeRow>> getAllOrdered() {
    return (select(vehicleTypes)..orderBy([
          (row) => OrderingTerm.asc(row.name),
        ]))
        .get();
  }

  Future<VehicleTypeRow?> getById(String id) {
    return (select(
      vehicleTypes,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertRow(VehicleTypesCompanion row) {
    return into(vehicleTypes).insert(row);
  }

  Future<bool> updateRow(VehicleTypesCompanion row) {
    return update(vehicleTypes).replace(row);
  }

  Future<bool> deleteById(String id) {
    return (delete(
      vehicleTypes,
    )..where((row) => row.id.equals(id))).go().then((rows) => rows > 0);
  }
}
