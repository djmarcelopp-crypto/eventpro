import 'assistant_conversation.dart';
import 'assistant_conversation_execution_context.dart';
import 'assistant_conversation_turn.dart';

/// Inputs for building a turn execution context (no side effects).
class AssistantContextBuildRequest {
  const AssistantContextBuildRequest({
    required this.conversation,
    required this.requestId,
    required this.builtAt,
    this.correlationId,
    this.normalizedInputText,
    this.inputId,
    this.intentLabel,
    this.commandIds = const [],
    this.capabilityIds = const [],
    this.workflowId,
    this.executionPlanId,
    this.entityRefs = const [],
    this.pendingTurn,
  });

  final AssistantConversation conversation;
  final String requestId;
  final DateTime builtAt;
  final String? correlationId;
  final String? normalizedInputText;
  final String? inputId;
  final String? intentLabel;
  final List<String> commandIds;
  final List<String> capabilityIds;
  final String? workflowId;
  final String? executionPlanId;
  final List<String> entityRefs;

  /// Optional turn being prepared (not yet committed to memory).
  final AssistantConversationTurn? pendingTurn;
}

/// Builds [AssistantConversationExecutionContext] without executing anything.
abstract class AssistantContextBuilder {
  AssistantConversationExecutionContext build(AssistantContextBuildRequest request);
}
