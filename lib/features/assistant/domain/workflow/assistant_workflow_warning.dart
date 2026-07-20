/// Structured warning for workflow planning/execution.
class AssistantWorkflowWarning {
  const AssistantWorkflowWarning({
    required this.code,
    required this.message,
  });

  static const missingHandler = 'workflowMissingHandler';
  static const stepFailed = 'workflowStepFailed';
  static const interrupted = 'workflowInterrupted';
  static const dependencyMissing = 'workflowDependencyMissing';
  static const emptyWorkflow = 'workflowEmpty';
  static const unknownIntent = 'workflowUnknownIntent';

  final String code;
  final String message;

  Map<String, Object?> toDeterministicMap() => {
        'code': code,
        'message': message,
      };
}
