import 'vehicle.dart';

/// Outcome of [VehicleService] create / update / delete.
enum VehicleOperationStatus {
  success,
  validationFailed,
  duplicatePlate,
  typeNotFound,
  typeInactive,
  notFound,
  deleted,
  failure,
}

/// Result of a [Vehicle] write/delete operation.
class VehicleOperationResult {
  const VehicleOperationResult._({
    required this.status,
    this.vehicle,
    this.errors = const [],
  });

  factory VehicleOperationResult.success(Vehicle vehicle) {
    return VehicleOperationResult._(
      status: VehicleOperationStatus.success,
      vehicle: vehicle,
    );
  }

  factory VehicleOperationResult.validationFailed(List<String> errors) {
    return VehicleOperationResult._(
      status: VehicleOperationStatus.validationFailed,
      errors: errors,
    );
  }

  factory VehicleOperationResult.duplicatePlate() {
    return const VehicleOperationResult._(
      status: VehicleOperationStatus.duplicatePlate,
    );
  }

  factory VehicleOperationResult.typeNotFound() {
    return const VehicleOperationResult._(
      status: VehicleOperationStatus.typeNotFound,
    );
  }

  factory VehicleOperationResult.typeInactive() {
    return const VehicleOperationResult._(
      status: VehicleOperationStatus.typeInactive,
    );
  }

  factory VehicleOperationResult.notFound() {
    return const VehicleOperationResult._(
      status: VehicleOperationStatus.notFound,
    );
  }

  factory VehicleOperationResult.deleted() {
    return const VehicleOperationResult._(
      status: VehicleOperationStatus.deleted,
    );
  }

  factory VehicleOperationResult.failure() {
    return const VehicleOperationResult._(
      status: VehicleOperationStatus.failure,
    );
  }

  final VehicleOperationStatus status;
  final Vehicle? vehicle;
  final List<String> errors;

  bool get isSuccess => status == VehicleOperationStatus.success;
  bool get isDeleted => status == VehicleOperationStatus.deleted;
}
