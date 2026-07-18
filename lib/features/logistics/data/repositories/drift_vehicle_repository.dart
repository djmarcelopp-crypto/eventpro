import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/logistics/data/mappers/vehicle_mapper.dart';
import 'package:eventpro/features/logistics/data/repositories/vehicle_repository.dart';
import 'package:eventpro/features/logistics/models/vehicle.dart';

/// Drift-backed persistence for [Vehicle]. No business rules — only
/// read/write via DAO + mapper.
class DriftVehicleRepository implements VehicleRepository {
  DriftVehicleRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<Vehicle>> listAll() async {
    final rows = await _database.vehiclesDao.getAllOrdered();
    return rows.map(VehicleMapper.toDomain).toList(growable: false);
  }

  @override
  Future<Vehicle?> findById(String id) async {
    final row = await _database.vehiclesDao.getById(id);
    if (row == null) {
      return null;
    }
    return VehicleMapper.toDomain(row);
  }

  @override
  Future<void> insert(Vehicle vehicle) async {
    await _database.vehiclesDao.insertRow(
      VehicleMapper.toInsertCompanion(vehicle),
    );
  }

  @override
  Future<void> update(Vehicle vehicle) async {
    final updated = await _database.vehiclesDao.updateRow(
      VehicleMapper.toUpdateCompanion(vehicle),
    );
    if (!updated) {
      throw StateError('Vehicle not found for update: ${vehicle.id}');
    }
  }

  @override
  Future<void> delete(String id) async {
    final deleted = await _database.vehiclesDao.deleteById(id);
    if (!deleted) {
      throw StateError('Vehicle not found for delete: $id');
    }
  }
}
