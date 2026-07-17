/// Result of validating a Financial domain entity, shared between
/// [FinancialCategoryValidator] and [FinancialEntryValidator].
class FinancialValidationResult {
  const FinancialValidationResult({required this.errors});

  final List<String> errors;

  bool get isValid => errors.isEmpty;
}
