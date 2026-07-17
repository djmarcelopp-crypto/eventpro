import '../models/equipment.dart';
import '../models/equipment_status.dart';
import 'equipment_validation_result.dart';

abstract class EquipmentValidator {
  static const nameRequiredError = 'Informe um nome para o equipamento';
  static const categoryRequiredError = 'Selecione uma categoria';
  static const quantityGreaterThanZeroError =
      'Informe uma quantidade maior que zero';
  static const statusRequiredError = 'Selecione um status';

  static EquipmentValidationResult validateFields({
    String? name,
    String? categoryId,
    int? totalQuantity,
    EquipmentStatus? status,
  }) {
    final errors = <String>[];

    if (name == null || name.trim().isEmpty) {
      errors.add(nameRequiredError);
    }
    if (categoryId == null || categoryId.trim().isEmpty) {
      errors.add(categoryRequiredError);
    }
    if (totalQuantity == null || totalQuantity <= 0) {
      errors.add(quantityGreaterThanZeroError);
    }
    if (status == null) {
      errors.add(statusRequiredError);
    }

    return EquipmentValidationResult(errors: List.unmodifiable(errors));
  }

  static EquipmentValidationResult validate(Equipment equipment) {
    return validateFields(
      name: equipment.name,
      categoryId: equipment.categoryId,
      totalQuantity: equipment.totalQuantity,
      status: equipment.status,
    );
  }
}
