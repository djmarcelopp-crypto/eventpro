import 'quote_vehicle.dart';

enum QuoteVehicleWriteStatus {
  success,
  validationFailed,
  quoteNotFound,
  vehicleNotFound,
  vehicleUnavailable,
  driverNotFound,
  driverInactive,
  duplicateVehicle,
  invalidSchedule,
  notFound,
  failure,
}

class QuoteVehicleWriteResult {
  const QuoteVehicleWriteResult._({
    required this.status,
    this.item,
    this.errors = const [],
  });

  factory QuoteVehicleWriteResult.success(QuoteVehicle item) {
    return QuoteVehicleWriteResult._(
      status: QuoteVehicleWriteStatus.success,
      item: item,
    );
  }

  factory QuoteVehicleWriteResult.validationFailed(List<String> errors) {
    return QuoteVehicleWriteResult._(
      status: QuoteVehicleWriteStatus.validationFailed,
      errors: errors,
    );
  }

  factory QuoteVehicleWriteResult.quoteNotFound() {
    return const QuoteVehicleWriteResult._(
      status: QuoteVehicleWriteStatus.quoteNotFound,
    );
  }

  factory QuoteVehicleWriteResult.vehicleNotFound() {
    return const QuoteVehicleWriteResult._(
      status: QuoteVehicleWriteStatus.vehicleNotFound,
    );
  }

  factory QuoteVehicleWriteResult.vehicleUnavailable() {
    return const QuoteVehicleWriteResult._(
      status: QuoteVehicleWriteStatus.vehicleUnavailable,
    );
  }

  factory QuoteVehicleWriteResult.driverNotFound() {
    return const QuoteVehicleWriteResult._(
      status: QuoteVehicleWriteStatus.driverNotFound,
    );
  }

  factory QuoteVehicleWriteResult.driverInactive() {
    return const QuoteVehicleWriteResult._(
      status: QuoteVehicleWriteStatus.driverInactive,
    );
  }

  factory QuoteVehicleWriteResult.duplicateVehicle() {
    return const QuoteVehicleWriteResult._(
      status: QuoteVehicleWriteStatus.duplicateVehicle,
    );
  }

  factory QuoteVehicleWriteResult.invalidSchedule() {
    return const QuoteVehicleWriteResult._(
      status: QuoteVehicleWriteStatus.invalidSchedule,
    );
  }

  factory QuoteVehicleWriteResult.notFound() {
    return const QuoteVehicleWriteResult._(
      status: QuoteVehicleWriteStatus.notFound,
    );
  }

  factory QuoteVehicleWriteResult.failure() {
    return const QuoteVehicleWriteResult._(
      status: QuoteVehicleWriteStatus.failure,
    );
  }

  final QuoteVehicleWriteStatus status;
  final QuoteVehicle? item;
  final List<String> errors;

  bool get isSuccess => status == QuoteVehicleWriteStatus.success;
}

enum QuoteVehicleDeleteStatus { deleted, notFound, failure }

class QuoteVehicleDeleteResult {
  const QuoteVehicleDeleteResult({required this.status});

  final QuoteVehicleDeleteStatus status;

  bool get isDeleted => status == QuoteVehicleDeleteStatus.deleted;
}
