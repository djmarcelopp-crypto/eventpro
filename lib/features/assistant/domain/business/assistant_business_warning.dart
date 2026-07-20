/// Non-fatal warning attached to a business operation result.
class AssistantBusinessWarning {
  const AssistantBusinessWarning({
    required this.code,
    required this.message,
  });

  static const unknownOperation = 'unknown_operation';
  static const missingParameter = 'missing_parameter';
  static const missingReference = 'missing_reference';
  static const stubOnly = 'stub_only';
  static const notRegistered = 'not_registered';

  final String code;
  final String message;

  Map<String, Object?> toDeterministicMap() => {
        'code': code,
        'message': message,
      };
}
