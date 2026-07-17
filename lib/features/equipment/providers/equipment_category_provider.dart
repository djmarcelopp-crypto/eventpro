import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/equipment_category_repository.dart';
import '../models/equipment_category.dart';
import '../models/equipment_category_delete_result.dart';
import '../models/equipment_category_write_result.dart';
import '../utils/equipment_category_service.dart';
import 'equipment_category_repository_provider.dart';
import 'equipment_category_service_provider.dart';

class EquipmentCategoryNotifier
    extends AsyncNotifier<List<EquipmentCategory>> {
  EquipmentCategoryRepository get _repository =>
      ref.read(equipmentCategoryRepositoryProvider);

  EquipmentCategoryService get _service =>
      ref.read(equipmentCategoryServiceProvider);

  @override
  Future<List<EquipmentCategory>> build() async {
    return _repository.listAll();
  }

  void hydrate(List<EquipmentCategory> categories) {
    state = AsyncValue.data(List<EquipmentCategory>.unmodifiable(categories));
  }

  EquipmentCategory? findById(String id) {
    final current = state.value;
    if (current == null) {
      return null;
    }
    for (final category in current) {
      if (category.id == id) {
        return category;
      }
    }
    return null;
  }

  Future<EquipmentCategoryWriteResult> addCategory(
    EquipmentCategory draft,
  ) async {
    final result = await _service.create(draft);
    if (result.isSuccess && result.category != null) {
      final current = state.value ?? const <EquipmentCategory>[];
      final next = [...current, result.category!]
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      state = AsyncValue.data(List<EquipmentCategory>.unmodifiable(next));
    }
    return result;
  }

  Future<EquipmentCategoryWriteResult> updateCategory(
    EquipmentCategory category,
  ) async {
    final result = await _service.update(category);
    if (result.isSuccess && result.category != null) {
      final current = state.value ?? const <EquipmentCategory>[];
      final next = [
        for (final item in current)
          if (item.id == result.category!.id) result.category! else item,
      ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      state = AsyncValue.data(List<EquipmentCategory>.unmodifiable(next));
    }
    return result;
  }

  Future<EquipmentCategoryDeleteResult> deleteCategory(String id) async {
    final result = await _service.delete(id);
    if (result.isDeleted) {
      final current = state.value ?? const <EquipmentCategory>[];
      state = AsyncValue.data(
        List<EquipmentCategory>.unmodifiable([
          for (final category in current)
            if (category.id != id) category,
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

/// EquipmentCategoryProvider — orchestrates [EquipmentCategoryService] only.
final equipmentCategoryProvider =
    AsyncNotifierProvider<EquipmentCategoryNotifier, List<EquipmentCategory>>(
      EquipmentCategoryNotifier.new,
    );
