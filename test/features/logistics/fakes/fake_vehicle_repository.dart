import 'package:eventpro/features/logistics/data/repositories/vehicle_repository.dart';
import 'package:eventpro/features/logistics/models/vehicle.dart';

class FakeVehicleRepository implements VehicleRepository {
  FakeVehicleRepository({List<Vehicle>? initialVehicles})
      : _vehicles = List<Vehicle>.from(initialVehicles ?? const []);

  final List<Vehicle> _vehicles;
  var shouldFailOnNextOperation = false;

  @override
  Future<List<Vehicle>> listAll() async {
    return List<Vehicle>.unmodifiable(_vehicles);
  }

  @override
  Future<Vehicle?> findById(String id) async {
    for (final vehicle in _vehicles) {
      if (vehicle.id == id) {
        return vehicle;
      }
    }
    return null;
  }

  @override
  Future<void> insert(Vehicle vehicle) async {
    _failIfRequested();
    _vehicles.add(vehicle);
  }

  @override
  Future<void> update(Vehicle vehicle) async {
    _failIfRequested();
    final index = _vehicles.indexWhere((current) => current.id == vehicle.id);
    if (index == -1) {
      throw StateError('Vehicle not found for update: ${vehicle.id}');
    }
    _vehicles[index] = vehicle;
  }

  @override
  Future<void> delete(String id) async {
    _failIfRequested();
    final lengthBefore = _vehicles.length;
    _vehicles.removeWhere((vehicle) => vehicle.id == id);
    if (_vehicles.length == lengthBefore) {
      throw StateError('Vehicle not found for delete: $id');
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
