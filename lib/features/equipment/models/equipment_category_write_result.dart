import 'equipment_category.dart';

/// Outcome of `EquipmentCategoryService.create`/`update`.
enum EquipmentCategoryWriteStatus {
  success,
  validationFailed,
  notFound,
  failure,
}

/// Result of a write operation (create/update) on an [EquipmentCategory].
class EquipmentCategoryWriteResult {
  const EquipmentCategoryWriteResult._({
    required this.status,
    this.category,
    this.errors = const [],
  });

  factory EquipmentCategoryWriteResult.success(EquipmentCategory category) {
    return EquipmentCategoryWriteResult._(
      status: EquipmentCategoryWriteStatus.success,
      category: category,
    );
  }

  factory EquipmentCategoryWriteResult.validationFailed(List<String> errors) {
    return EquipmentCategoryWriteResult._(
      status: EquipmentCategoryWriteStatus.validationFailed,
      errors: errors,
    );
  }

  factory EquipmentCategoryWriteResult.notFound() {
    return const EquipmentCategoryWriteResult._(
      status: EquipmentCategoryWriteStatus.notFound,
    );
  }

  factory EquipmentCategoryWriteResult.failure() {
    return const EquipmentCategoryWriteResult._(
      status: EquipmentCategoryWriteStatus.failure,
    );
  }

  final EquipmentCategoryWriteStatus status;
  final EquipmentCategory? category;
  final List<String> errors;

  bool get isSuccess => status == EquipmentCategoryWriteStatus.success;
}
