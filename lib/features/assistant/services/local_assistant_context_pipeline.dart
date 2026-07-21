import '../domain/context/assistant_context_builder.dart';
import '../domain/context/assistant_context_pipeline.dart';
import '../domain/context/assistant_conversation.dart';
import '../domain/context/assistant_conversation_id.dart';
import '../domain/context/assistant_conversation_memory.dart';
import '../domain/context/assistant_conversation_summarizer.dart';
import '../domain/context/assistant_conversation_turn.dart';
import 'local_assistant_context_builder.dart';
import 'local_assistant_conversation_memory.dart';
import 'local_assistant_conversation_summarizer.dart';

/// Local Context Engine pipeline (AI-021).
///
/// Conversation → Memory → Context Builder → Execution Context
/// Does not run Intent / Command / Capability / Workflow / Gateway.
class LocalAssistantContextPipeline implements AssistantContextPipeline {
  LocalAssistantContextPipeline({
    AssistantConversationMemory? memory,
    AssistantContextBuilder? builder,
    AssistantConversationSummarizer? summarizer,
  })  : _memory = memory ?? LocalAssistantConversationMemory(),
        _builder = builder ?? const LocalAssistantContextBuilder(),
        _summarizer =
            summarizer ?? const LocalAssistantConversationSummarizer();

  final AssistantConversationMemory _memory;
  final AssistantContextBuilder _builder;
  final AssistantConversationSummarizer _summarizer;

  AssistantConversationMemory get memory => _memory;

  @override
  AssistantContextPipelineResult run(AssistantContextPipelineRequest request) {
    var conversation = _memory.getOrCreate(
      id: request.conversationId,
      now: request.now,
      metadata: request.metadata,
    );

    // Merge active request context into state without executing.
    conversation = _memory.replace(
      conversation.copyWith(
        metadata: request.metadata.sessionId != null ||
                request.metadata.correlationId != null
            ? request.metadata
            : conversation.metadata,
        state: conversation.state.copyWith(
          lastIntentLabel:
              request.intentLabel ?? conversation.state.lastIntentLabel,
          lastWorkflowId:
              request.workflowId ?? conversation.state.lastWorkflowId,
          lastCommandIds: request.commandIds.isNotEmpty
              ? request.commandIds
              : conversation.state.lastCommandIds,
          lastCapabilityIds: request.capabilityIds.isNotEmpty
              ? request.capabilityIds
              : conversation.state.lastCapabilityIds,
          lastEntityRefs: request.entityRefs.isNotEmpty
              ? request.entityRefs
              : conversation.state.lastEntityRefs,
          activeClientId: request.metadata.sessionId != null
              ? conversation.state.activeClientId
              : conversation.state.activeClientId,
          hints: [
            ...conversation.state.hints.where(
              (h) => !h.startsWith('requestId:'),
            ),
            'requestId:${request.requestId}',
          ],
        ),
        updatedAt: request.now,
      ),
    );

    if (request.commitTurn) {
      final turn = AssistantConversationTurn(
        turnIndex: conversation.turns.length,
        timestamp: request.now,
        requestId: request.requestId,
        inputId: request.inputId,
        normalizedText: request.normalizedInputText,
        intentLabel: request.intentLabel,
        commandIds: request.commandIds,
        capabilityIds: request.capabilityIds,
        workflowId: request.workflowId,
        entityRefs: request.entityRefs,
      );
      conversation = _memory.appendTurn(
        id: request.conversationId,
        turn: turn,
        now: request.now,
      );
      if (request.autoSummarize) {
        conversation = _summarizer.summarize(
          conversation,
          keepRecentTurns: request.keepRecentTurns,
          now: request.now,
        );
        conversation = _memory.replace(conversation);
      }
    }

    final executionContext = _builder.build(
      AssistantContextBuildRequest(
        conversation: conversation,
        requestId: request.requestId,
        builtAt: request.now,
        correlationId: request.correlationId,
        normalizedInputText: request.normalizedInputText,
        inputId: request.inputId,
        intentLabel: request.intentLabel,
        commandIds: request.commandIds,
        capabilityIds: request.capabilityIds,
        workflowId: request.workflowId,
        executionPlanId: request.executionPlanId,
        entityRefs: request.entityRefs,
      ),
    );

    return AssistantContextPipelineResult(
      conversation: conversation,
      executionContext: executionContext,
    );
  }

  @override
  AssistantConversation recordCompletedTurn({
    required AssistantConversationId conversationId,
    required AssistantConversationTurn turn,
    required DateTime now,
    bool autoSummarize = true,
    int keepRecentTurns = 5,
  }) {
    var conversation = _memory.appendTurn(
      id: conversationId,
      turn: turn,
      now: now,
    );
    if (autoSummarize) {
      conversation = _summarizer.summarize(
        conversation,
        keepRecentTurns: keepRecentTurns,
        now: now,
      );
      conversation = _memory.replace(conversation);
    }
    return conversation;
  }
}
