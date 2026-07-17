import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/equipment_filters.dart';
import '../models/equipment_status.dart';

class EquipmentFiltersNotifier extends Notifier<EquipmentFilters> {
  @override
  EquipmentFilters build() => EquipmentFilters.empty;

  void setCategoryId(String? categoryId) {
    state = state.copyWith(
      categoryId: categoryId,
      clearCategoryId: categoryId == null,
    );
  }

  void setStatus(EquipmentStatus? status) {
    state = state.copyWith(status: status, clearStatus: status == null);
  }

  void setNameQuery(String nameQuery) {
    state = state.copyWith(nameQuery: nameQuery);
  }

  void clear() {
    state = EquipmentFilters.empty;
  }
}

final equipmentFiltersProvider =
    NotifierProvider<EquipmentFiltersNotifier, EquipmentFilters>(
      EquipmentFiltersNotifier.new,
    );
