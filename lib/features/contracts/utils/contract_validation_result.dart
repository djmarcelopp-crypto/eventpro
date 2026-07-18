/// Result of validating contract / template domain fields.
class ContractValidationResult {
  const ContractValidationResult({this.errors = const []});

  final List<String> errors;

  bool get isValid => errors.isEmpty;
}
