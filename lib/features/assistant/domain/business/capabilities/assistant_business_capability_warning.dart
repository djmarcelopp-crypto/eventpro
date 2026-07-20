/// Soft issue from capability resolution (never an ERP error).
class AssistantBusinessCapabilityWarning {
  const AssistantBusinessCapabilityWarning({
    required this.code,
    required this.message,
  });

  static const notFound = 'capability_not_found';
  static const missingInput = 'missing_required_input';
  static const unmetConstraint = 'unmet_constraint';
  static const notReady = 'capability_not_ready';

  final String code;
  final String message;

  Map<String, Object?> toDeterministicMap() => {
        'code': code,
        'message': message,
      };
}
