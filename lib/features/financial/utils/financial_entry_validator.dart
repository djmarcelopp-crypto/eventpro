import '../models/financial_entry.dart';
import 'financial_validation_result.dart';

abstract class FinancialEntryValidator {
  static const descriptionRequiredError = 'Informe uma descrição';
  static const dateRequiredError = 'Informe a data do lançamento';
  static const categoryRequiredError = 'Selecione uma categoria';
  static const amountGreaterThanZeroError =
      'Informe um valor maior que zero';

  static FinancialValidationResult validateFields({
    String? description,
    int? amountCents,
    DateTime? date,
    String? categoryId,
  }) {
    final errors = <String>[];

    if (description == null || description.trim().isEmpty) {
      errors.add(descriptionRequiredError);
    }
    if (amountCents == null || amountCents <= 0) {
      errors.add(amountGreaterThanZeroError);
    }
    if (date == null) {
      errors.add(dateRequiredError);
    }
    if (categoryId == null || categoryId.trim().isEmpty) {
      errors.add(categoryRequiredError);
    }

    return FinancialValidationResult(errors: List.unmodifiable(errors));
  }

  static FinancialValidationResult validate(FinancialEntry entry) {
    return validateFields(
      description: entry.description,
      amountCents: entry.amountCents,
      date: entry.date,
      categoryId: entry.categoryId,
    );
  }
}
