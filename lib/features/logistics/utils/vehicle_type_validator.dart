import '../models/vehicle_type.dart';
import 'logistics_validation_result.dart';

abstract class VehicleTypeValidator {
  static const nameRequiredError = 'Informe um nome para o tipo de veículo';

  static LogisticsValidationResult validateFields({String? name}) {
    final errors = <String>[];

    if (name == null || name.trim().isEmpty) {
      errors.add(nameRequiredError);
    }

    return LogisticsValidationResult(errors: List.unmodifiable(errors));
  }

  static LogisticsValidationResult validate(VehicleType type) {
    return validateFields(name: type.name);
  }
}
