/// Lifecycle status of a conversation (in-memory only).
enum AssistantConversationStatus {
  active,
  idle,
  summarized,
  closed,
}

extension AssistantConversationStatusX on AssistantConversationStatus {
  Map<String, Object?> toDeterministicMap() => {'status': name};
}
