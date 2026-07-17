import 'equipment.dart';

/// Outcome of `EquipmentService.create`/`update`.
enum EquipmentWriteStatus {
  success,
  validationFailed,
  categoryNotFound,
  categoryInactive,
  notFound,
  failure,
}

/// Result of a write operation (create/update) on an [Equipment].
class EquipmentWriteResult {
  const EquipmentWriteResult._({
    required this.status,
    this.equipment,
    this.errors = const [],
  });

  factory EquipmentWriteResult.success(Equipment equipment) {
    return EquipmentWriteResult._(
      status: EquipmentWriteStatus.success,
      equipment: equipment,
    );
  }

  factory EquipmentWriteResult.validationFailed(List<String> errors) {
    return EquipmentWriteResult._(
      status: EquipmentWriteStatus.validationFailed,
      errors: errors,
    );
  }

  factory EquipmentWriteResult.categoryNotFound() {
    return const EquipmentWriteResult._(
      status: EquipmentWriteStatus.categoryNotFound,
    );
  }

  factory EquipmentWriteResult.categoryInactive() {
    return const EquipmentWriteResult._(
      status: EquipmentWriteStatus.categoryInactive,
    );
  }

  factory EquipmentWriteResult.notFound() {
    return const EquipmentWriteResult._(
      status: EquipmentWriteStatus.notFound,
    );
  }

  factory EquipmentWriteResult.failure() {
    return const EquipmentWriteResult._(
      status: EquipmentWriteStatus.failure,
    );
  }

  final EquipmentWriteStatus status;
  final Equipment? equipment;
  final List<String> errors;

  bool get isSuccess => status == EquipmentWriteStatus.success;
}
