import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/equipment/data/mappers/equipment_category_mapper.dart';
import 'package:eventpro/features/equipment/data/repositories/equipment_category_repository.dart';
import 'package:eventpro/features/equipment/models/equipment_category.dart';

/// Drift-backed persistence for [EquipmentCategory]. No business rules —
/// only read/write via DAO + mapper.
class DriftEquipmentCategoryRepository
    implements EquipmentCategoryRepository {
  DriftEquipmentCategoryRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<EquipmentCategory>> listAll() async {
    final rows = await _database.equipmentCategoriesDao.getAllOrdered();
    return rows.map(EquipmentCategoryMapper.toDomain).toList(growable: false);
  }

  @override
  Future<EquipmentCategory?> findById(String id) async {
    final row = await _database.equipmentCategoriesDao.getById(id);
    if (row == null) {
      return null;
    }
    return EquipmentCategoryMapper.toDomain(row);
  }

  @override
  Future<void> insert(EquipmentCategory category) async {
    await _database.equipmentCategoriesDao.insertRow(
      EquipmentCategoryMapper.toInsertCompanion(category),
    );
  }

  @override
  Future<void> update(EquipmentCategory category) async {
    final updated = await _database.equipmentCategoriesDao.updateRow(
      EquipmentCategoryMapper.toUpdateCompanion(category),
    );
    if (!updated) {
      throw StateError(
        'EquipmentCategory not found for update: ${category.id}',
      );
    }
  }

  @override
  Future<void> delete(String id) async {
    final deleted = await _database.equipmentCategoriesDao.deleteById(id);
    if (!deleted) {
      throw StateError('EquipmentCategory not found for delete: $id');
    }
  }
}
