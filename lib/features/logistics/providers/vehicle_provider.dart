import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/vehicle_repository.dart';
import '../models/vehicle.dart';
import '../models/vehicle_operation_result.dart';
import '../utils/vehicle_service.dart';
import 'vehicle_repository_provider.dart';
import 'vehicle_service_provider.dart';

class VehicleNotifier extends AsyncNotifier<List<Vehicle>> {
  VehicleRepository get _repository => ref.read(vehicleRepositoryProvider);
  VehicleService get _service => ref.read(vehicleServiceProvider);

  @override
  Future<List<Vehicle>> build() async => _repository.listAll();

  Vehicle? findById(String id) {
    final current = state.value;
    if (current == null) return null;
    for (final vehicle in current) {
      if (vehicle.id == id) return vehicle;
    }
    return null;
  }

  Future<VehicleOperationResult> addVehicle(Vehicle draft) async {
    final result = await _service.create(draft);
    if (result.isSuccess && result.vehicle != null) {
      final current = state.value ?? const <Vehicle>[];
      final next = [...current, result.vehicle!]
        ..sort(
          (a, b) => a.plate.toLowerCase().compareTo(b.plate.toLowerCase()),
        );
      state = AsyncValue.data(List.unmodifiable(next));
    }
    return result;
  }

  Future<VehicleOperationResult> updateVehicle(Vehicle vehicle) async {
    final result = await _service.update(vehicle);
    if (result.isSuccess && result.vehicle != null) {
      final current = state.value ?? const <Vehicle>[];
      final next = [
        for (final item in current)
          if (item.id == result.vehicle!.id) result.vehicle! else item,
      ]..sort(
          (a, b) => a.plate.toLowerCase().compareTo(b.plate.toLowerCase()),
        );
      state = AsyncValue.data(List.unmodifiable(next));
    }
    return result;
  }

  Future<VehicleOperationResult> deleteVehicle(String id) async {
    final result = await _service.delete(id);
    if (result.isDeleted) {
      final current = state.value ?? const <Vehicle>[];
      state = AsyncValue.data(
        List.unmodifiable([
          for (final vehicle in current)
            if (vehicle.id != id) vehicle,
        ]),
      );
    }
    return result;
  }
}

final vehicleProvider =
    AsyncNotifierProvider<VehicleNotifier, List<Vehicle>>(VehicleNotifier.new);
