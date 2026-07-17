import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/equipment_repository.dart';
import '../models/equipment.dart';
import '../models/equipment_delete_result.dart';
import '../models/equipment_write_result.dart';
import '../utils/equipment_service.dart';
import 'equipment_repository_provider.dart';
import 'equipment_service_provider.dart';

class EquipmentNotifier extends AsyncNotifier<List<Equipment>> {
  EquipmentRepository get _repository => ref.read(equipmentRepositoryProvider);

  EquipmentService get _service => ref.read(equipmentServiceProvider);

  @override
  Future<List<Equipment>> build() async {
    return _repository.listAll();
  }

  void hydrate(List<Equipment> items) {
    state = AsyncValue.data(List<Equipment>.unmodifiable(items));
  }

  Equipment? findById(String id) {
    final current = state.value;
    if (current == null) {
      return null;
    }
    for (final item in current) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  Future<EquipmentWriteResult> addEquipment(Equipment draft) async {
    final result = await _service.create(draft);
    if (result.isSuccess && result.equipment != null) {
      final current = state.value ?? const <Equipment>[];
      final next = [...current, result.equipment!]
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      state = AsyncValue.data(List<Equipment>.unmodifiable(next));
    }
    return result;
  }

  Future<EquipmentWriteResult> updateEquipment(Equipment equipment) async {
    final result = await _service.update(equipment);
    if (result.isSuccess && result.equipment != null) {
      final current = state.value ?? const <Equipment>[];
      final next = [
        for (final item in current)
          if (item.id == result.equipment!.id) result.equipment! else item,
      ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      state = AsyncValue.data(List<Equipment>.unmodifiable(next));
    }
    return result;
  }

  Future<EquipmentDeleteResult> deleteEquipment(String id) async {
    final result = await _service.delete(id);
    if (result.isDeleted) {
      final current = state.value ?? const <Equipment>[];
      state = AsyncValue.data(
        List<Equipment>.unmodifiable([
          for (final item in current)
            if (item.id != id) item,
        ]),
      );
    }
    return result;
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.listAll);
  }
}

/// EquipmentProvider — orchestrates [EquipmentService] only.
final equipmentProvider =
    AsyncNotifierProvider<EquipmentNotifier, List<Equipment>>(
      EquipmentNotifier.new,
    );
