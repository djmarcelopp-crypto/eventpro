import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/vehicle_type_repository.dart';
import '../models/vehicle_type.dart';
import '../models/vehicle_type_operation_result.dart';
import '../utils/vehicle_type_service.dart';
import 'vehicle_type_repository_provider.dart';
import 'vehicle_type_service_provider.dart';

class VehicleTypeNotifier extends AsyncNotifier<List<VehicleType>> {
  VehicleTypeRepository get _repository =>
      ref.read(vehicleTypeRepositoryProvider);
  VehicleTypeService get _service => ref.read(vehicleTypeServiceProvider);

  @override
  Future<List<VehicleType>> build() async => _repository.listAll();

  VehicleType? findById(String id) {
    final current = state.value;
    if (current == null) return null;
    for (final type in current) {
      if (type.id == id) return type;
    }
    return null;
  }

  Future<VehicleTypeOperationResult> addType(VehicleType draft) async {
    final result = await _service.create(draft);
    if (result.isSuccess && result.type != null) {
      final current = state.value ?? const <VehicleType>[];
      final next = [...current, result.type!]
        ..sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
      state = AsyncValue.data(List.unmodifiable(next));
    }
    return result;
  }

  Future<VehicleTypeOperationResult> updateType(VehicleType type) async {
    final result = await _service.update(type);
    if (result.isSuccess && result.type != null) {
      final current = state.value ?? const <VehicleType>[];
      final next = [
        for (final item in current)
          if (item.id == result.type!.id) result.type! else item,
      ]..sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
      state = AsyncValue.data(List.unmodifiable(next));
    }
    return result;
  }

  Future<VehicleTypeOperationResult> deleteType(String id) async {
    final result = await _service.delete(id);
    if (result.isDeleted) {
      final current = state.value ?? const <VehicleType>[];
      state = AsyncValue.data(
        List.unmodifiable([
          for (final type in current)
            if (type.id != id) type,
        ]),
      );
    }
    return result;
  }

  Future<VehicleTypeOperationResult> setActive(String id, {required bool active}) {
    final existing = findById(id);
    if (existing == null) {
      return Future.value(VehicleTypeOperationResult.notFound());
    }
    return updateType(existing.copyWith(active: active));
  }
}

final vehicleTypeProvider =
    AsyncNotifierProvider<VehicleTypeNotifier, List<VehicleType>>(
      VehicleTypeNotifier.new,
    );
