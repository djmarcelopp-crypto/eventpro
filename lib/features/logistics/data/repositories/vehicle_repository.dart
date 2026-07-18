import 'package:eventpro/features/logistics/models/vehicle.dart';

/// Domain contract for persisting [Vehicle] records.
///
/// Storage-agnostic: no Drift (or other) implementation in this checkpoint.
abstract class VehicleRepository {
  Future<List<Vehicle>> listAll();

  Future<Vehicle?> findById(String id);

  Future<void> insert(Vehicle vehicle);

  Future<void> update(Vehicle vehicle);

  Future<void> delete(String id);
}
