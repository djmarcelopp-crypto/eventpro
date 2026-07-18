part of '../app_database.dart';

@DriftAccessor(tables: [Vehicles])
class VehiclesDao extends DatabaseAccessor<AppDatabase>
    with _$VehiclesDaoMixin {
  VehiclesDao(super.db);

  Future<List<VehicleRow>> getAllOrdered() {
    return (select(vehicles)..orderBy([
          (row) => OrderingTerm.asc(row.plate),
        ]))
        .get();
  }

  Future<VehicleRow?> getById(String id) {
    return (select(
      vehicles,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertRow(VehiclesCompanion row) {
    return into(vehicles).insert(row);
  }

  Future<bool> updateRow(VehiclesCompanion row) {
    return update(vehicles).replace(row);
  }

  Future<bool> deleteById(String id) {
    return (delete(
      vehicles,
    )..where((row) => row.id.equals(id))).go().then((rows) => rows > 0);
  }
}
