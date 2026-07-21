/// Explicit ownership map for conversational state (AR-002).
///
/// | Concern | Owner | Writes | Reads |
/// |---------|-------|--------|-------|
/// | sessionId / correlationId | [AssistantTurnIdentity] on effectiveRequest | Intake / caller | All pipelines |
/// | Quote-read follow-ups (lastResult, focus) | AI-010 SessionRegistry | Conversation planner after successful read | AI-010 planner, smart actions |
/// | Cross-pipeline memory (turns, summary, cmd/cap labels) | AI-021 ConversationMemory | Context pipeline (opt-in commit) | Context Builder / hints |
/// | Confirmation pending / token | ConfirmationSessionRegistry | Confirmation planner | TX execution |
/// | Workflow step bag | AssistantWorkflowContext | Step handlers | Later steps |
///
/// Rules:
/// - AI-010 does **not** write AI-021 memory.
/// - AI-021 does **not** write AI-010 [AssistantConversationContext].
/// - Both share [sessionId] when the caller provides one; AI-021 may use
///   `req:{requestId}` as conversationId without creating an AI-010 session.
abstract final class AssistantConversationOwnership {
  static const ai010QuoteRead = 'ai010.quote_read_session';
  static const ai021ContextEngine = 'ai021.conversation_memory';
  static const confirmationLifecycle = 'ai013.confirmation_session';
  static const turnIdentity = 'ar002.turn_identity';
}
