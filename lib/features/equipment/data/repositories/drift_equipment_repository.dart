import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/equipment/data/mappers/equipment_mapper.dart';
import 'package:eventpro/features/equipment/data/repositories/equipment_repository.dart';
import 'package:eventpro/features/equipment/models/equipment.dart';

/// Drift-backed persistence for [Equipment]. No business rules — only
/// read/write via DAO + mapper.
class DriftEquipmentRepository implements EquipmentRepository {
  DriftEquipmentRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<Equipment>> listAll() async {
    final rows = await _database.equipmentsDao.getAllOrdered();
    return rows.map(EquipmentMapper.toDomain).toList(growable: false);
  }

  @override
  Future<Equipment?> findById(String id) async {
    final row = await _database.equipmentsDao.getById(id);
    if (row == null) {
      return null;
    }
    return EquipmentMapper.toDomain(row);
  }

  @override
  Future<void> insert(Equipment equipment) async {
    await _database.equipmentsDao.insertRow(
      EquipmentMapper.toInsertCompanion(equipment),
    );
  }

  @override
  Future<void> update(Equipment equipment) async {
    final updated = await _database.equipmentsDao.updateRow(
      EquipmentMapper.toUpdateCompanion(equipment),
    );
    if (!updated) {
      throw StateError('Equipment not found for update: ${equipment.id}');
    }
  }

  @override
  Future<void> delete(String id) async {
    final deleted = await _database.equipmentsDao.deleteById(id);
    if (!deleted) {
      throw StateError('Equipment not found for delete: $id');
    }
  }
}
