import 'equipment_status.dart';

/// Presentation filters for the equipment list (UI only — no stock rules).
class EquipmentFilters {
  const EquipmentFilters({
    this.categoryId,
    this.status,
    this.nameQuery = '',
  });

  static const empty = EquipmentFilters();

  final String? categoryId;
  final EquipmentStatus? status;
  final String nameQuery;

  bool get hasActiveFilters =>
      categoryId != null ||
      status != null ||
      nameQuery.trim().isNotEmpty;

  EquipmentFilters copyWith({
    String? categoryId,
    EquipmentStatus? status,
    String? nameQuery,
    bool clearCategoryId = false,
    bool clearStatus = false,
  }) {
    return EquipmentFilters(
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
      status: clearStatus ? null : (status ?? this.status),
      nameQuery: nameQuery ?? this.nameQuery,
    );
  }
}
