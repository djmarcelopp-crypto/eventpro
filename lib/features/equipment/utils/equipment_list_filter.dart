import '../models/equipment.dart';
import '../models/equipment_filters.dart';

/// Applies presentation filters to an equipment list. No stock / booking logic.
abstract class EquipmentListFilter {
  static List<Equipment> apply(
    List<Equipment> items,
    EquipmentFilters filters,
  ) {
    final query = filters.nameQuery.trim().toLowerCase();
    return [
      for (final item in items)
        if (_matches(item, filters, query)) item,
    ];
  }

  static bool _matches(
    Equipment item,
    EquipmentFilters filters,
    String query,
  ) {
    if (filters.categoryId != null && item.categoryId != filters.categoryId) {
      return false;
    }
    if (filters.status != null && item.status != filters.status) {
      return false;
    }
    if (query.isNotEmpty && !item.name.toLowerCase().contains(query)) {
      return false;
    }
    return true;
  }
}
