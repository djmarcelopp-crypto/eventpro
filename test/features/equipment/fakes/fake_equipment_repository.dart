import 'package:eventpro/features/equipment/data/repositories/equipment_repository.dart';
import 'package:eventpro/features/equipment/models/equipment.dart';

class FakeEquipmentRepository implements EquipmentRepository {
  FakeEquipmentRepository({List<Equipment>? initialEquipment})
    : _items = List<Equipment>.from(initialEquipment ?? const []);

  final List<Equipment> _items;

  /// Makes the next write (insert/update/delete) throw once, then resets
  /// itself. Reads are never affected.
  var shouldFailOnNextOperation = false;

  @override
  Future<List<Equipment>> listAll() async {
    return List<Equipment>.unmodifiable(_items);
  }

  @override
  Future<Equipment?> findById(String id) async {
    for (final item in _items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  @override
  Future<void> insert(Equipment equipment) async {
    _failIfRequested();
    _items.add(equipment);
  }

  @override
  Future<void> update(Equipment equipment) async {
    _failIfRequested();
    final index = _items.indexWhere((item) => item.id == equipment.id);
    if (index == -1) {
      throw StateError('Equipment not found for update: ${equipment.id}');
    }
    _items[index] = equipment;
  }

  @override
  Future<void> delete(String id) async {
    _failIfRequested();
    final lengthBefore = _items.length;
    _items.removeWhere((item) => item.id == id);
    if (_items.length == lengthBefore) {
      throw StateError('Equipment not found for delete: $id');
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
