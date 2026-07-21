import 'assistant_conversation.dart';
import 'assistant_conversation_summary.dart';

/// Deterministic conversation summarizer (no LLM).
abstract class AssistantConversationSummarizer {
  /// Collapse older turns into a summary, keeping [keepRecentTurns] intact.
  AssistantConversation summarize(
    AssistantConversation conversation, {
    int keepRecentTurns = 5,
    DateTime? now,
  });

  AssistantConversationSummary buildSummary(
    AssistantConversation conversation, {
    int keepRecentTurns = 5,
    DateTime? now,
  });
}
