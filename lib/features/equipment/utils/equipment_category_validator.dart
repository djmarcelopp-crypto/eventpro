import '../models/equipment_category.dart';
import 'equipment_validation_result.dart';

abstract class EquipmentCategoryValidator {
  static const nameRequiredError = 'Informe um nome para a categoria';

  static EquipmentValidationResult validateFields({String? name}) {
    final errors = <String>[];

    if (name == null || name.trim().isEmpty) {
      errors.add(nameRequiredError);
    }

    return EquipmentValidationResult(errors: List.unmodifiable(errors));
  }

  static EquipmentValidationResult validate(EquipmentCategory category) {
    return validateFields(name: category.name);
  }
}
