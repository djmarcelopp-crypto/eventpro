/// Result of validating a Logistics domain entity, shared between
/// [VehicleTypeValidator] and [VehicleValidator].
class LogisticsValidationResult {
  const LogisticsValidationResult({required this.errors});

  final List<String> errors;

  bool get isValid => errors.isEmpty;
}
