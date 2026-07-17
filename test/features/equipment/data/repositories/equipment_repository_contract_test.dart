import 'package:eventpro/features/equipment/data/repositories/equipment_category_repository.dart';
import 'package:eventpro/features/equipment/data/repositories/equipment_repository.dart';
import 'package:eventpro/features/equipment/models/equipment.dart';
import 'package:eventpro/features/equipment/models/equipment_category.dart';
import 'package:eventpro/features/equipment/models/equipment_status.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory stubs that prove the repository contracts are implementable
/// without Drift / providers / UI.
class _MemoryEquipmentRepository implements EquipmentRepository {
  final Map<String, Equipment> _items = {};

  @override
  Future<void> delete(String id) async {
    _items.remove(id);
  }

  @override
  Future<Equipment?> findById(String id) async => _items[id];

  @override
  Future<void> insert(Equipment equipment) async {
    _items[equipment.id] = equipment;
  }

  @override
  Future<List<Equipment>> listAll() async =>
      List.unmodifiable(_items.values.toList());

  @override
  Future<void> update(Equipment equipment) async {
    _items[equipment.id] = equipment;
  }
}

class _MemoryEquipmentCategoryRepository
    implements EquipmentCategoryRepository {
  final Map<String, EquipmentCategory> _items = {};

  @override
  Future<void> delete(String id) async {
    _items.remove(id);
  }

  @override
  Future<EquipmentCategory?> findById(String id) async => _items[id];

  @override
  Future<void> insert(EquipmentCategory category) async {
    _items[category.id] = category;
  }

  @override
  Future<List<EquipmentCategory>> listAll() async =>
      List.unmodifiable(_items.values.toList());

  @override
  Future<void> update(EquipmentCategory category) async {
    _items[category.id] = category;
  }
}

void main() {
  group('EquipmentRepository interface', () {
    test('in-memory implementation supports CRUD', () async {
      final repository = _MemoryEquipmentRepository();
      final equipment = Equipment(
        id: 'eq-1',
        name: 'Caixa',
        categoryId: 'cat-1',
        totalQuantity: 2,
        status: EquipmentStatus.available,
        createdAt: DateTime(2026, 7, 1),
        updatedAt: DateTime(2026, 7, 1),
      );

      await repository.insert(equipment);
      expect(await repository.findById('eq-1'), equipment);
      expect(await repository.listAll(), [equipment]);

      final updated = equipment.copyWith(name: 'Caixa Pro');
      await repository.update(updated);
      expect(await repository.findById('eq-1'), updated);

      await repository.delete('eq-1');
      expect(await repository.findById('eq-1'), isNull);
      expect(await repository.listAll(), isEmpty);
    });
  });

  group('EquipmentCategoryRepository interface', () {
    test('in-memory implementation supports CRUD', () async {
      final repository = _MemoryEquipmentCategoryRepository();
      const category = EquipmentCategory(id: 'cat-1', name: 'Som');

      await repository.insert(category);
      expect(await repository.findById('cat-1'), category);
      expect(await repository.listAll(), [category]);

      final updated = category.copyWith(name: 'Áudio');
      await repository.update(updated);
      expect(await repository.findById('cat-1'), updated);

      await repository.delete('cat-1');
      expect(await repository.findById('cat-1'), isNull);
      expect(await repository.listAll(), isEmpty);
    });
  });
}
