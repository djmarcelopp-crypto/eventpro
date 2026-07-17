import 'vehicle_type.dart';

/// Outcome of [VehicleTypeService] create / update / delete / activation.
enum VehicleTypeOperationStatus {
  success,
  validationFailed,
  duplicateName,
  notFound,
  deleted,
  blockedByUsage,
  failure,
}

/// Result of a [VehicleType] operation.
class VehicleTypeOperationResult {
  const VehicleTypeOperationResult._({
    required this.status,
    this.type,
    this.errors = const [],
    this.blockingVehicleCount = 0,
  });

  factory VehicleTypeOperationResult.success(VehicleType type) {
    return VehicleTypeOperationResult._(
      status: VehicleTypeOperationStatus.success,
      type: type,
    );
  }

  factory VehicleTypeOperationResult.validationFailed(List<String> errors) {
    return VehicleTypeOperationResult._(
      status: VehicleTypeOperationStatus.validationFailed,
      errors: errors,
    );
  }

  factory VehicleTypeOperationResult.duplicateName() {
    return const VehicleTypeOperationResult._(
      status: VehicleTypeOperationStatus.duplicateName,
    );
  }

  factory VehicleTypeOperationResult.notFound() {
    return const VehicleTypeOperationResult._(
      status: VehicleTypeOperationStatus.notFound,
    );
  }

  factory VehicleTypeOperationResult.deleted() {
    return const VehicleTypeOperationResult._(
      status: VehicleTypeOperationStatus.deleted,
    );
  }

  factory VehicleTypeOperationResult.blockedByUsage({
    required int blockingVehicleCount,
  }) {
    return VehicleTypeOperationResult._(
      status: VehicleTypeOperationStatus.blockedByUsage,
      blockingVehicleCount: blockingVehicleCount,
    );
  }

  factory VehicleTypeOperationResult.failure() {
    return const VehicleTypeOperationResult._(
      status: VehicleTypeOperationStatus.failure,
    );
  }

  final VehicleTypeOperationStatus status;
  final VehicleType? type;
  final List<String> errors;
  final int blockingVehicleCount;

  bool get isSuccess => status == VehicleTypeOperationStatus.success;
  bool get isDeleted => status == VehicleTypeOperationStatus.deleted;
  bool get isBlockedByUsage =>
      status == VehicleTypeOperationStatus.blockedByUsage;
}
