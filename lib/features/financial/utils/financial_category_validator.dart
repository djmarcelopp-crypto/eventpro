import '../models/financial_category.dart';
import 'financial_validation_result.dart';

abstract class FinancialCategoryValidator {
  static const nameRequiredError = 'Informe um nome para a categoria';

  static FinancialValidationResult validateFields({String? name}) {
    final errors = <String>[];

    if (name == null || name.trim().isEmpty) {
      errors.add(nameRequiredError);
    }

    return FinancialValidationResult(errors: List.unmodifiable(errors));
  }

  static FinancialValidationResult validate(FinancialCategory category) {
    return validateFields(name: category.name);
  }
}
