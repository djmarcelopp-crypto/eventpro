import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/logistics/data/mappers/vehicle_type_mapper.dart';
import 'package:eventpro/features/logistics/data/repositories/vehicle_type_repository.dart';
import 'package:eventpro/features/logistics/models/vehicle_type.dart';

/// Drift-backed persistence for [VehicleType]. No business rules — only
/// read/write via DAO + mapper.
class DriftVehicleTypeRepository implements VehicleTypeRepository {
  DriftVehicleTypeRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<VehicleType>> listAll() async {
    final rows = await _database.vehicleTypesDao.getAllOrdered();
    return rows.map(VehicleTypeMapper.toDomain).toList(growable: false);
  }

  @override
  Future<VehicleType?> findById(String id) async {
    final row = await _database.vehicleTypesDao.getById(id);
    if (row == null) {
      return null;
    }
    return VehicleTypeMapper.toDomain(row);
  }

  @override
  Future<void> insert(VehicleType type) async {
    await _database.vehicleTypesDao.insertRow(
      VehicleTypeMapper.toInsertCompanion(type),
    );
  }

  @override
  Future<void> update(VehicleType type) async {
    final updated = await _database.vehicleTypesDao.updateRow(
      VehicleTypeMapper.toUpdateCompanion(type),
    );
    if (!updated) {
      throw StateError('VehicleType not found for update: ${type.id}');
    }
  }

  @override
  Future<void> delete(String id) async {
    final deleted = await _database.vehicleTypesDao.deleteById(id);
    if (!deleted) {
      throw StateError('VehicleType not found for delete: $id');
    }
  }
}
