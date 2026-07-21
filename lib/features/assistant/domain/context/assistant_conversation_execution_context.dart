import 'assistant_conversation.dart';
import 'assistant_conversation_id.dart';
import 'assistant_conversation_snapshot.dart';
import 'assistant_conversation_summary.dart';
import 'assistant_conversation_turn.dart';

/// Built execution context for one turn (Context Engine AI-021).
///
/// Distinct from write-path `models/assistant_execution_context.dart`.
/// This type carries conversational memory into interpretation — it does
/// **not** authorize writes or execute commands.
class AssistantConversationExecutionContext {
  const AssistantConversationExecutionContext({
    required this.conversationId,
    required this.requestId,
    required this.builtAt,
    required this.snapshot,
    this.correlationId,
    this.normalizedInputText,
    this.inputId,
    this.intentLabel,
    this.commandIds = const [],
    this.capabilityIds = const [],
    this.workflowId,
    this.executionPlanId,
    this.entityRefs = const [],
    this.summary = AssistantConversationSummary.empty,
    this.traceHints = const [],
  });

  final AssistantConversationId conversationId;
  final String requestId;
  final DateTime builtAt;
  final AssistantConversationSnapshot snapshot;
  final String? correlationId;
  final String? normalizedInputText;
  final String? inputId;
  final String? intentLabel;
  final List<String> commandIds;
  final List<String> capabilityIds;
  final String? workflowId;
  final String? executionPlanId;
  final List<String> entityRefs;
  final AssistantConversationSummary summary;
  final List<String> traceHints;

  factory AssistantConversationExecutionContext.fromConversation({
    required AssistantConversation conversation,
    required String requestId,
    required DateTime builtAt,
    String? correlationId,
    String? normalizedInputText,
    String? inputId,
    String? intentLabel,
    List<String> commandIds = const [],
    List<String> capabilityIds = const [],
    String? workflowId,
    String? executionPlanId,
    List<String> entityRefs = const [],
    List<String> traceHints = const [],
  }) {
    final snapshot = conversation.toSnapshot();
    return AssistantConversationExecutionContext(
      conversationId: conversation.id,
      requestId: requestId,
      builtAt: builtAt,
      snapshot: snapshot,
      correlationId: correlationId ?? conversation.metadata.correlationId,
      normalizedInputText: normalizedInputText,
      inputId: inputId,
      intentLabel: intentLabel ?? conversation.state.lastIntentLabel,
      commandIds: commandIds.isNotEmpty
          ? commandIds
          : conversation.state.lastCommandIds,
      capabilityIds: capabilityIds.isNotEmpty
          ? capabilityIds
          : conversation.state.lastCapabilityIds,
      workflowId: workflowId ?? conversation.state.lastWorkflowId,
      executionPlanId: executionPlanId,
      entityRefs:
          entityRefs.isNotEmpty ? entityRefs : conversation.state.lastEntityRefs,
      summary: conversation.summary,
      traceHints: [
        'conversationId:${conversation.id.value}',
        'conversationVersion:${conversation.version}',
        ...traceHints,
      ],
    );
  }

  Map<String, Object?> toDeterministicMap() => {
        'conversationId': conversationId.toDeterministicMap(),
        'requestId': requestId,
        'builtAt': builtAt.toUtc().toIso8601String(),
        'snapshot': snapshot.toDeterministicMap(),
        'correlationId': correlationId,
        'normalizedInputText': normalizedInputText,
        'inputId': inputId,
        'intentLabel': intentLabel,
        'commandIds': commandIds,
        'capabilityIds': capabilityIds,
        'workflowId': workflowId,
        'executionPlanId': executionPlanId,
        'entityRefs': entityRefs,
        'summary': summary.toDeterministicMap(),
        'traceHints': traceHints,
      };
}

/// Alias used in architecture docs for the Context Engine output.
typedef AssistantExecutionContextBundle = AssistantConversationExecutionContext;
