/// Outcome of `EquipmentService.delete`.
enum EquipmentDeleteStatus { deleted, notFound, failure }

class EquipmentDeleteResult {
  const EquipmentDeleteResult({required this.status});

  final EquipmentDeleteStatus status;

  bool get isDeleted => status == EquipmentDeleteStatus.deleted;
}
