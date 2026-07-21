/// One immutable conversational turn recorded in memory.
class AssistantConversationTurn {
  const AssistantConversationTurn({
    required this.turnIndex,
    required this.timestamp,
    this.requestId,
    this.inputId,
    this.rawText,
    this.normalizedText,
    this.intentLabel,
    this.commandIds = const [],
    this.capabilityIds = const [],
    this.workflowId,
    this.entityRefs = const [],
    this.notes = const [],
  });

  final int turnIndex;
  final DateTime timestamp;
  final String? requestId;
  final String? inputId;
  final String? rawText;
  final String? normalizedText;
  final String? intentLabel;
  final List<String> commandIds;
  final List<String> capabilityIds;
  final String? workflowId;
  final List<String> entityRefs;
  final List<String> notes;

  Map<String, Object?> toDeterministicMap() => {
        'turnIndex': turnIndex,
        'timestamp': timestamp.toUtc().toIso8601String(),
        'requestId': requestId,
        'inputId': inputId,
        'rawText': rawText,
        'normalizedText': normalizedText,
        'intentLabel': intentLabel,
        'commandIds': commandIds,
        'capabilityIds': capabilityIds,
        'workflowId': workflowId,
        'entityRefs': entityRefs,
        'notes': notes,
      };
}
