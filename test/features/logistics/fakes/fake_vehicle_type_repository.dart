import 'package:eventpro/features/logistics/data/repositories/vehicle_type_repository.dart';
import 'package:eventpro/features/logistics/models/vehicle_type.dart';

class FakeVehicleTypeRepository implements VehicleTypeRepository {
  FakeVehicleTypeRepository({List<VehicleType>? initialTypes})
      : _types = List<VehicleType>.from(initialTypes ?? const []);

  final List<VehicleType> _types;
  var shouldFailOnNextOperation = false;

  @override
  Future<List<VehicleType>> listAll() async {
    return List<VehicleType>.unmodifiable(_types);
  }

  @override
  Future<VehicleType?> findById(String id) async {
    for (final type in _types) {
      if (type.id == id) {
        return type;
      }
    }
    return null;
  }

  @override
  Future<void> insert(VehicleType type) async {
    _failIfRequested();
    _types.add(type);
  }

  @override
  Future<void> update(VehicleType type) async {
    _failIfRequested();
    final index = _types.indexWhere((current) => current.id == type.id);
    if (index == -1) {
      throw StateError('VehicleType not found for update: ${type.id}');
    }
    _types[index] = type;
  }

  @override
  Future<void> delete(String id) async {
    _failIfRequested();
    final lengthBefore = _types.length;
    _types.removeWhere((type) => type.id == id);
    if (_types.length == lengthBefore) {
      throw StateError('VehicleType not found for delete: $id');
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
