import '../models/vehicle.dart';
import '../models/vehicle_status.dart';
import 'logistics_validation_result.dart';

abstract class VehicleValidator {
  static const plateRequiredError = 'Informe a placa do veículo';
  static const typeRequiredError = 'Selecione um tipo de veículo';
  static const payloadCapacityNonNegativeError =
      'Informe uma capacidade de carga maior ou igual a zero';
  static const volumeCapacityNonNegativeError =
      'Informe uma capacidade de volume maior ou igual a zero';
  static const statusRequiredError = 'Selecione um status';
  static const statusInvalidError = 'Status inválido';

  static LogisticsValidationResult validateFields({
    String? plate,
    String? vehicleTypeId,
    double? payloadCapacityKg,
    double? volumeCapacityM3,
    VehicleStatus? status,
    String? statusName,
  }) {
    final errors = <String>[];

    if (plate == null || plate.trim().isEmpty) {
      errors.add(plateRequiredError);
    }

    if (vehicleTypeId == null || vehicleTypeId.trim().isEmpty) {
      errors.add(typeRequiredError);
    }

    if (payloadCapacityKg == null || payloadCapacityKg < 0) {
      errors.add(payloadCapacityNonNegativeError);
    }

    if (volumeCapacityM3 == null || volumeCapacityM3 < 0) {
      errors.add(volumeCapacityNonNegativeError);
    }

    if (status == null) {
      if (statusName == null || statusName.trim().isEmpty) {
        errors.add(statusRequiredError);
      } else if (!VehicleStatus.values
          .any((value) => value.name == statusName)) {
        errors.add(statusInvalidError);
      }
    }

    return LogisticsValidationResult(errors: List.unmodifiable(errors));
  }

  static LogisticsValidationResult validate(Vehicle vehicle) {
    return validateFields(
      plate: vehicle.plate,
      vehicleTypeId: vehicle.vehicleTypeId,
      payloadCapacityKg: vehicle.payloadCapacityKg,
      volumeCapacityM3: vehicle.volumeCapacityM3,
      status: vehicle.status,
    );
  }
}
