import 'package:eventpro/features/logistics/models/vehicle_type.dart';

/// Domain contract for persisting [VehicleType] records.
///
/// Storage-agnostic: no Drift (or other) implementation in this checkpoint.
abstract class VehicleTypeRepository {
  Future<List<VehicleType>> listAll();

  Future<VehicleType?> findById(String id);

  Future<void> insert(VehicleType type);

  Future<void> update(VehicleType type);

  Future<void> delete(String id);
}
