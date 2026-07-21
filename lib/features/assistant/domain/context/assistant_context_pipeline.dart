import 'assistant_conversation.dart';
import 'assistant_conversation_execution_context.dart';
import 'assistant_conversation_id.dart';
import 'assistant_conversation_metadata.dart';
import 'assistant_conversation_turn.dart';

/// Pipeline request for the Context Engine (AI-021).
class AssistantContextPipelineRequest {
  const AssistantContextPipelineRequest({
    required this.conversationId,
    required this.requestId,
    required this.now,
    this.metadata = const AssistantConversationMetadata(),
    this.correlationId,
    this.normalizedInputText,
    this.inputId,
    this.intentLabel,
    this.commandIds = const [],
    this.capabilityIds = const [],
    this.workflowId,
    this.executionPlanId,
    this.entityRefs = const [],
    this.commitTurn = false,
    this.autoSummarize = true,
    this.keepRecentTurns = 5,
  });

  final AssistantConversationId conversationId;
  final String requestId;
  final DateTime now;
  final AssistantConversationMetadata metadata;
  final String? correlationId;
  final String? normalizedInputText;
  final String? inputId;
  final String? intentLabel;
  final List<String> commandIds;
  final List<String> capabilityIds;
  final String? workflowId;
  final String? executionPlanId;
  final List<String> entityRefs;
  final bool commitTurn;
  final bool autoSummarize;
  final int keepRecentTurns;
}

/// Result of running the context pipeline (does not run Intent/Command/…).
class AssistantContextPipelineResult {
  const AssistantContextPipelineResult({
    required this.conversation,
    required this.executionContext,
  });

  final AssistantConversation conversation;
  final AssistantConversationExecutionContext executionContext;
}

/// Conversation → Memory → Context Builder → Execution Context.
abstract class AssistantContextPipeline {
  AssistantContextPipelineResult run(AssistantContextPipelineRequest request);

  /// Record a completed turn after interpretation (additive memory update).
  AssistantConversation recordCompletedTurn({
    required AssistantConversationId conversationId,
    required AssistantConversationTurn turn,
    required DateTime now,
    bool autoSummarize = true,
    int keepRecentTurns = 5,
  });
}
