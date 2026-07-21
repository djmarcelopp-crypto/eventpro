import '../domain/context/assistant_conversation.dart';
import '../domain/context/assistant_conversation_status.dart';
import '../domain/context/assistant_conversation_summarizer.dart';
import '../domain/context/assistant_conversation_summary.dart';

/// Deterministic summarizer — collapses older turns without LLM.
class LocalAssistantConversationSummarizer
    implements AssistantConversationSummarizer {
  const LocalAssistantConversationSummarizer();

  @override
  AssistantConversation summarize(
    AssistantConversation conversation, {
    int keepRecentTurns = 5,
    DateTime? now,
  }) {
    if (conversation.turns.length <= keepRecentTurns) {
      return conversation;
    }

    final summary = buildSummary(
      conversation,
      keepRecentTurns: keepRecentTurns,
      now: now,
    );
    final recent = conversation.turns
        .sublist(conversation.turns.length - keepRecentTurns);

    return conversation.copyWith(
      turns: List.unmodifiable(recent),
      summary: summary,
      state: conversation.state.copyWith(summary: summary),
      status: AssistantConversationStatus.summarized,
      updatedAt: now ?? conversation.updatedAt,
      version: conversation.version + 1,
    );
  }

  @override
  AssistantConversationSummary buildSummary(
    AssistantConversation conversation, {
    int keepRecentTurns = 5,
    DateTime? now,
  }) {
    if (conversation.turns.length <= keepRecentTurns) {
      return conversation.summary;
    }

    final older = conversation.turns
        .sublist(0, conversation.turns.length - keepRecentTurns);

    final intents = <String>{
      ...conversation.summary.intentLabels,
      for (final t in older)
        if (t.intentLabel != null && t.intentLabel!.trim().isNotEmpty)
          t.intentLabel!.trim(),
    };
    final commands = <String>{
      ...conversation.summary.commandIds,
      for (final t in older) ...t.commandIds,
    };
    final capabilities = <String>{
      ...conversation.summary.capabilityIds,
      for (final t in older) ...t.capabilityIds,
    };
    final entities = <String>{
      ...conversation.summary.entityRefs,
      for (final t in older) ...t.entityRefs,
    };
    final workflows = <String>{
      ...conversation.summary.workflowIds,
      for (final t in older)
        if (t.workflowId != null && t.workflowId!.trim().isNotEmpty)
          t.workflowId!.trim(),
    };

    final priorText = conversation.summary.text.trim();
    final parts = <String>[
      if (priorText.isNotEmpty) priorText,
      'turns=${older.length}',
      if (intents.isNotEmpty) 'intents=${intents.join(",")}',
      if (commands.isNotEmpty) 'commands=${commands.join(",")}',
      if (capabilities.isNotEmpty) 'capabilities=${capabilities.join(",")}',
      if (entities.isNotEmpty) 'entities=${entities.join(",")}',
      if (workflows.isNotEmpty) 'workflows=${workflows.join(",")}',
    ];

    return AssistantConversationSummary(
      text: parts.join(' | '),
      intentLabels: intents.toList(growable: false)..sort(),
      commandIds: commands.toList(growable: false)..sort(),
      capabilityIds: capabilities.toList(growable: false)..sort(),
      entityRefs: entities.toList(growable: false)..sort(),
      workflowIds: workflows.toList(growable: false)..sort(),
      coveredTurnCount:
          conversation.summary.coveredTurnCount + older.length,
      updatedAt: now ?? DateTime.now().toUtc(),
    );
  }
}
