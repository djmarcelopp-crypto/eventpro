import '../domain/context/assistant_context_builder.dart';
import '../domain/context/assistant_conversation_execution_context.dart';

/// Local context builder — assembles execution context; never executes.
class LocalAssistantContextBuilder implements AssistantContextBuilder {
  const LocalAssistantContextBuilder();

  @override
  AssistantConversationExecutionContext build(
    AssistantContextBuildRequest request,
  ) {
    final pending = request.pendingTurn;
    final trace = <String>[
      if (pending != null) 'pendingTurn:${pending.turnIndex}',
      if (request.inputId != null) 'inputId:${request.inputId}',
      if (request.normalizedInputText != null)
        'hasNormalizedText:${request.normalizedInputText!.isNotEmpty}',
      ...request.persistentMemoryHints,
    ];

    return AssistantConversationExecutionContext.fromConversation(
      conversation: request.conversation,
      requestId: request.requestId,
      builtAt: request.builtAt,
      correlationId: request.correlationId,
      normalizedInputText: request.normalizedInputText,
      inputId: request.inputId,
      intentLabel: request.intentLabel ?? pending?.intentLabel,
      commandIds: request.commandIds.isNotEmpty
          ? request.commandIds
          : (pending?.commandIds ?? const []),
      capabilityIds: request.capabilityIds.isNotEmpty
          ? request.capabilityIds
          : (pending?.capabilityIds ?? const []),
      workflowId: request.workflowId ?? pending?.workflowId,
      executionPlanId: request.executionPlanId,
      entityRefs: request.entityRefs.isNotEmpty
          ? request.entityRefs
          : (pending?.entityRefs ?? const []),
      traceHints: trace,
    );
  }
}
