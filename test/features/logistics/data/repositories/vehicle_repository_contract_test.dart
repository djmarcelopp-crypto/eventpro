import 'package:eventpro/features/logistics/data/repositories/vehicle_repository.dart';
import 'package:eventpro/features/logistics/data/repositories/vehicle_type_repository.dart';
import 'package:eventpro/features/logistics/models/vehicle.dart';
import 'package:eventpro/features/logistics/models/vehicle_status.dart';
import 'package:eventpro/features/logistics/models/vehicle_type.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory stubs that prove the repository contracts are implementable
/// without Drift / providers / UI.
class _MemoryVehicleRepository implements VehicleRepository {
  final Map<String, Vehicle> _items = {};

  @override
  Future<void> delete(String id) async {
    _items.remove(id);
  }

  @override
  Future<Vehicle?> findById(String id) async => _items[id];

  @override
  Future<void> insert(Vehicle vehicle) async {
    _items[vehicle.id] = vehicle;
  }

  @override
  Future<List<Vehicle>> listAll() async =>
      List.unmodifiable(_items.values.toList());

  @override
  Future<void> update(Vehicle vehicle) async {
    _items[vehicle.id] = vehicle;
  }
}

class _MemoryVehicleTypeRepository implements VehicleTypeRepository {
  final Map<String, VehicleType> _items = {};

  @override
  Future<void> delete(String id) async {
    _items.remove(id);
  }

  @override
  Future<VehicleType?> findById(String id) async => _items[id];

  @override
  Future<void> insert(VehicleType type) async {
    _items[type.id] = type;
  }

  @override
  Future<List<VehicleType>> listAll() async =>
      List.unmodifiable(_items.values.toList());

  @override
  Future<void> update(VehicleType type) async {
    _items[type.id] = type;
  }
}

void main() {
  group('VehicleRepository interface', () {
    test('in-memory implementation supports CRUD', () async {
      final repository = _MemoryVehicleRepository();
      final vehicle = Vehicle(
        id: 'v-1',
        plate: 'ABC1D23',
        vehicleTypeId: 'type-1',
        payloadCapacityKg: 800,
        volumeCapacityM3: 8,
        status: VehicleStatus.available,
        createdAt: DateTime(2026, 7, 17),
        updatedAt: DateTime(2026, 7, 17),
      );

      await repository.insert(vehicle);
      expect(await repository.findById('v-1'), vehicle);
      expect(await repository.listAll(), [vehicle]);

      final updated = vehicle.copyWith(plate: 'XYZ9Z99');
      await repository.update(updated);
      expect(await repository.findById('v-1'), updated);

      await repository.delete('v-1');
      expect(await repository.findById('v-1'), isNull);
      expect(await repository.listAll(), isEmpty);
    });
  });

  group('VehicleTypeRepository interface', () {
    test('in-memory implementation supports CRUD', () async {
      final repository = _MemoryVehicleTypeRepository();
      final type = VehicleType(
        id: 'type-1',
        name: 'Van',
        createdAt: DateTime(2026, 7, 17),
        updatedAt: DateTime(2026, 7, 17),
      );

      await repository.insert(type);
      expect(await repository.findById('type-1'), type);
      expect(await repository.listAll(), [type]);

      final updated = type.copyWith(name: 'Utilitário');
      await repository.update(updated);
      expect(await repository.findById('type-1'), updated);

      await repository.delete('type-1');
      expect(await repository.findById('type-1'), isNull);
      expect(await repository.listAll(), isEmpty);
    });
  });
}
