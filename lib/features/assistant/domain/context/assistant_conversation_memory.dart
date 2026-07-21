import 'assistant_conversation.dart';
import 'assistant_conversation_id.dart';
import 'assistant_conversation_metadata.dart';
import 'assistant_conversation_turn.dart';

/// In-memory conversation history port (no Drift / no permanence).
abstract class AssistantConversationMemory {
  AssistantConversation getOrCreate({
    required AssistantConversationId id,
    required DateTime now,
    AssistantConversationMetadata metadata =
        const AssistantConversationMetadata(),
  });

  AssistantConversation? find(AssistantConversationId id);

  AssistantConversation appendTurn({
    required AssistantConversationId id,
    required AssistantConversationTurn turn,
    required DateTime now,
  });

  AssistantConversation replace(AssistantConversation conversation);

  void clear(AssistantConversationId id);

  void clearAll();

  int get conversationCount;
}
