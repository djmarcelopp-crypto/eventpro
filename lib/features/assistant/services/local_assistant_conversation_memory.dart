import '../domain/context/assistant_conversation.dart';
import '../domain/context/assistant_conversation_id.dart';
import '../domain/context/assistant_conversation_memory.dart';
import '../domain/context/assistant_conversation_metadata.dart';
import '../domain/context/assistant_conversation_state.dart';
import '../domain/context/assistant_conversation_status.dart';
import '../domain/context/assistant_conversation_turn.dart';

/// Process-local conversation memory (AI-021). No Drift / no permanence.
class LocalAssistantConversationMemory implements AssistantConversationMemory {
  LocalAssistantConversationMemory({this.maxTurnsPerConversation = 50});

  final int maxTurnsPerConversation;
  final Map<String, AssistantConversation> _store = {};

  @override
  int get conversationCount => _store.length;

  @override
  AssistantConversation getOrCreate({
    required AssistantConversationId id,
    required DateTime now,
    AssistantConversationMetadata metadata =
        const AssistantConversationMetadata(),
  }) {
    final existing = _store[id.value];
    if (existing != null) return existing;

    final created = AssistantConversation(
      id: id,
      createdAt: now,
      updatedAt: now,
      metadata: metadata,
      status: AssistantConversationStatus.active,
    );
    _store[id.value] = created;
    return created;
  }

  @override
  AssistantConversation? find(AssistantConversationId id) => _store[id.value];

  @override
  AssistantConversation appendTurn({
    required AssistantConversationId id,
    required AssistantConversationTurn turn,
    required DateTime now,
  }) {
    final current = _store[id.value];
    if (current == null) {
      throw StateError('Conversation ${id.value} not found in memory.');
    }

    var turns = [...current.turns, turn];
    if (turns.length > maxTurnsPerConversation) {
      turns = turns.sublist(turns.length - maxTurnsPerConversation);
    }

    final state = current.state.copyWith(
      lastIntentLabel: turn.intentLabel ?? current.state.lastIntentLabel,
      lastWorkflowId: turn.workflowId ?? current.state.lastWorkflowId,
      lastCommandIds:
          turn.commandIds.isNotEmpty ? turn.commandIds : current.state.lastCommandIds,
      lastCapabilityIds: turn.capabilityIds.isNotEmpty
          ? turn.capabilityIds
          : current.state.lastCapabilityIds,
      lastEntityRefs:
          turn.entityRefs.isNotEmpty ? turn.entityRefs : current.state.lastEntityRefs,
    );

    final updated = current.copyWith(
      turns: List.unmodifiable(turns),
      state: state,
      updatedAt: now,
      version: current.version + 1,
      status: AssistantConversationStatus.active,
    );
    _store[id.value] = updated;
    return updated;
  }

  @override
  AssistantConversation replace(AssistantConversation conversation) {
    _store[conversation.id.value] = conversation;
    return conversation;
  }

  @override
  void clear(AssistantConversationId id) => _store.remove(id.value);

  @override
  void clearAll() => _store.clear();
}
