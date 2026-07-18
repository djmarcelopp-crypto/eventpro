import '../models/contract_template.dart';
import 'contract_validation_result.dart';

abstract class ContractTemplateValidator {
  static const nameRequiredError = 'Informe um nome para o modelo de contrato';

  static ContractValidationResult validateFields({String? name}) {
    final errors = <String>[];
    if (name == null || name.trim().isEmpty) {
      errors.add(nameRequiredError);
    }
    return ContractValidationResult(errors: List.unmodifiable(errors));
  }

  static ContractValidationResult validate(ContractTemplate template) {
    return validateFields(name: template.name);
  }
}
