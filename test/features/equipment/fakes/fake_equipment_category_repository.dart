import 'package:eventpro/features/equipment/data/repositories/equipment_category_repository.dart';
import 'package:eventpro/features/equipment/models/equipment_category.dart';

class FakeEquipmentCategoryRepository implements EquipmentCategoryRepository {
  FakeEquipmentCategoryRepository({
    List<EquipmentCategory>? initialCategories,
  }) : _categories = List<EquipmentCategory>.from(
         initialCategories ?? const [],
       );

  final List<EquipmentCategory> _categories;

  /// Makes the next write (insert/update/delete) throw once, then resets
  /// itself. Reads are never affected.
  var shouldFailOnNextOperation = false;

  @override
  Future<List<EquipmentCategory>> listAll() async {
    return List<EquipmentCategory>.unmodifiable(_categories);
  }

  @override
  Future<EquipmentCategory?> findById(String id) async {
    for (final category in _categories) {
      if (category.id == id) {
        return category;
      }
    }
    return null;
  }

  @override
  Future<void> insert(EquipmentCategory category) async {
    _failIfRequested();
    _categories.add(category);
  }

  @override
  Future<void> update(EquipmentCategory category) async {
    _failIfRequested();
    final index = _categories.indexWhere((item) => item.id == category.id);
    if (index == -1) {
      throw StateError(
        'EquipmentCategory not found for update: ${category.id}',
      );
    }
    _categories[index] = category;
  }

  @override
  Future<void> delete(String id) async {
    _failIfRequested();
    final lengthBefore = _categories.length;
    _categories.removeWhere((category) => category.id == id);
    if (_categories.length == lengthBefore) {
      throw StateError('EquipmentCategory not found for delete: $id');
    }
  }

  void _failIfRequested() {
    if (!shouldFailOnNextOperation) {
      return;
    }
    shouldFailOnNextOperation = false;
    throw StateError('Simulated repository failure');
  }
}
