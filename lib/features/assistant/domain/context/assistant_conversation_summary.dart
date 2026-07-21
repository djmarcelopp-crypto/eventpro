/// Deterministic, non-LLM summary of older conversation turns.
class AssistantConversationSummary {
  const AssistantConversationSummary({
    this.text = '',
    this.intentLabels = const [],
    this.commandIds = const [],
    this.capabilityIds = const [],
    this.entityRefs = const [],
    this.workflowIds = const [],
    this.coveredTurnCount = 0,
    this.updatedAt,
  });

  static const empty = AssistantConversationSummary();

  final String text;
  final List<String> intentLabels;
  final List<String> commandIds;
  final List<String> capabilityIds;
  final List<String> entityRefs;
  final List<String> workflowIds;
  final int coveredTurnCount;
  final DateTime? updatedAt;

  bool get isEmpty =>
      text.trim().isEmpty &&
      intentLabels.isEmpty &&
      commandIds.isEmpty &&
      coveredTurnCount == 0;

  Map<String, Object?> toDeterministicMap() => {
        'text': text,
        'intentLabels': intentLabels,
        'commandIds': commandIds,
        'capabilityIds': capabilityIds,
        'entityRefs': entityRefs,
        'workflowIds': workflowIds,
        'coveredTurnCount': coveredTurnCount,
        'updatedAt': updatedAt?.toUtc().toIso8601String(),
      };
}
