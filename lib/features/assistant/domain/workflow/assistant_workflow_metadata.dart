/// Metadata for a workflow plan/execution turn.
class AssistantWorkflowMetadata {
  const AssistantWorkflowMetadata({
    required this.workflowId,
    required this.generatedAt,
    this.recipe,
    this.stepCount = 0,
    this.completedStepCount = 0,
    this.interrupted = false,
  });

  final String workflowId;
  final DateTime generatedAt;
  final String? recipe;
  final int stepCount;
  final int completedStepCount;
  final bool interrupted;

  Map<String, Object?> toDeterministicMap() => {
        'workflowId': workflowId,
        'generatedAt': generatedAt.toUtc().toIso8601String(),
        'recipe': recipe,
        'stepCount': stepCount,
        'completedStepCount': completedStepCount,
        'interrupted': interrupted,
      };
}
