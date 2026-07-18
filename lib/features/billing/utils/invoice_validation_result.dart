/// Result of validating invoice / invoice item domain fields.
class InvoiceValidationResult {
  const InvoiceValidationResult({this.errors = const []});

  final List<String> errors;

  bool get isValid => errors.isEmpty;
}
