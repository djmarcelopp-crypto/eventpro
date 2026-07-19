import '../models/assistant_execution_request.dart';

/// Validates a controlled execution request before confirmation/dispatch.
abstract class AssistantExecutionValidator {
  AssistantExecutionValidationResult validate(AssistantExecutionRequest request);
}

class AssistantExecutionValidationResult {
  const AssistantExecutionValidationResult({
    required this.isValid,
    this.issues = const [],
  });

  final bool isValid;
  final List<String> issues;

  factory AssistantExecutionValidationResult.ok() =>
      const AssistantExecutionValidationResult(isValid: true);

  factory AssistantExecutionValidationResult.invalid(List<String> issues) =>
      AssistantExecutionValidationResult(isValid: false, issues: issues);
}
