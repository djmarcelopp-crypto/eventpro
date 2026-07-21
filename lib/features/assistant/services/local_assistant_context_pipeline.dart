import '../domain/context/assistant_context_builder.dart';
import '../domain/context/assistant_context_pipeline.dart';
import '../domain/context/assistant_conversation.dart';
import '../domain/context/assistant_conversation_id.dart';
import '../domain/context/assistant_conversation_memory.dart';
import '../domain/context/assistant_conversation_summarizer.dart';
import '../domain/context/assistant_conversation_turn.dart';
import '../domain/memory/assistant_memory_keys.dart';
import '../domain/memory/assistant_memory_search.dart';
import 'local_assistant_context_builder.dart';
import 'local_assistant_conversation_memory.dart';
import 'local_assistant_conversation_summarizer.dart';
import 'local_assistant_persistent_memory.dart';

/// Local Context Engine pipeline (AI-021 + optional AI-024).
///
/// Conversation → [opt] Persistent Memory → Context Builder → Execution Context
/// Does not run Intent / Command / Capability / Workflow / Gateway.
class LocalAssistantContextPipeline implements AssistantContextPipeline {
  LocalAssistantContextPipeline({
    AssistantConversationMemory? memory,
    AssistantContextBuilder? builder,
    AssistantConversationSummarizer? summarizer,
    LocalAssistantPersistentMemory? persistentMemory,
  })  : _memory = memory ?? LocalAssistantConversationMemory(),
        _builder = builder ?? const LocalAssistantContextBuilder(),
        _summarizer =
            summarizer ?? const LocalAssistantConversationSummarizer(),
        _persistentMemory = persistentMemory;

  final AssistantConversationMemory _memory;
  final AssistantContextBuilder _builder;
  final AssistantConversationSummarizer _summarizer;

  /// Opt-in Persistent Memory Engine (AI-024). Null keeps AI-021 behavior.
  final LocalAssistantPersistentMemory? _persistentMemory;

  AssistantConversationMemory get memory => _memory;

  LocalAssistantPersistentMemory? get persistentMemory => _persistentMemory;

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

    final persistentHints = _buildPersistentMemoryHints(
      sessionId: request.metadata.sessionId,
    );

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
        persistentMemoryHints: persistentHints,
      ),
    );

    return AssistantContextPipelineResult(
      conversation: conversation,
      executionContext: executionContext,
    );
  }

  List<String> _buildPersistentMemoryHints({String? sessionId}) {
    final engine = _persistentMemory;
    if (engine == null) return const [];

    final result = engine.searchSync(
      AssistantMemorySearch(
        sessionId: sessionId,
        keys: const [
          AssistantMemoryKeys.lastClient,
          AssistantMemoryKeys.lastQuote,
          AssistantMemoryKeys.lastEvent,
          AssistantMemoryKeys.lastSupplier,
          AssistantMemoryKeys.lastDecision,
          AssistantMemoryKeys.lastWorkflow,
          AssistantMemoryKeys.lastCapability,
          AssistantMemoryKeys.lastEntity,
        ],
        limit: 16,
      ),
    );
    if (result.isEmpty) return const ['persistentMemory:0'];

    return [
      'persistentMemory:${result.entries.length}',
      for (final e in result.entries)
        'mem:${e.key}:${e.value ?? ''}:${e.metadata.confidence.toStringAsFixed(2)}',
    ];
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
