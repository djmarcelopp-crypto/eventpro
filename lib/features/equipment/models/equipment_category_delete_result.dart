/// Outcome of `EquipmentCategoryService.delete`.
enum EquipmentCategoryDeleteStatus {
  deleted,
  notFound,
  blockedByUsage,
  failure,
}

class EquipmentCategoryDeleteResult {
  const EquipmentCategoryDeleteResult({
    required this.status,
    this.blockingEquipmentCount = 0,
  });

  final EquipmentCategoryDeleteStatus status;

  /// Number of [Equipment] records still referencing this category.
  /// Only meaningful when [status] is [EquipmentCategoryDeleteStatus.blockedByUsage].
  final int blockingEquipmentCount;

  bool get isDeleted => status == EquipmentCategoryDeleteStatus.deleted;
  bool get isBlockedByUsage =>
      status == EquipmentCategoryDeleteStatus.blockedByUsage;
}
