import 'package:eventpro/features/equipment/models/equipment_category.dart';

/// Domain contract for persisting [EquipmentCategory] records.
///
/// Storage-agnostic: no Drift (or other) implementation in this checkpoint.
abstract class EquipmentCategoryRepository {
  Future<List<EquipmentCategory>> listAll();

  Future<EquipmentCategory?> findById(String id);

  Future<void> insert(EquipmentCategory category);

  Future<void> update(EquipmentCategory category);

  Future<void> delete(String id);
}
