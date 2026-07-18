/// Result of validating an Equipment domain entity, shared between
/// [EquipmentCategoryValidator] and [EquipmentValidator].
class EquipmentValidationResult {
  const EquipmentValidationResult({required this.errors});

  final List<String> errors;

  bool get isValid => errors.isEmpty;
}
