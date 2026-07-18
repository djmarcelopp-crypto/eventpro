import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/equipment.dart';
import '../utils/equipment_list_filter.dart';
import 'equipment_filters_provider.dart';
import 'equipment_provider.dart';

final filteredEquipmentProvider = Provider<AsyncValue<List<Equipment>>>((ref) {
  final itemsAsync = ref.watch(equipmentProvider);
  final filters = ref.watch(equipmentFiltersProvider);

  return itemsAsync.whenData(
    (items) => EquipmentListFilter.apply(items, filters),
  );
});
