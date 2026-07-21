/// Classification of assistant operational memory (AI-024).
enum AssistantMemoryType {
  conversation,
  preference,
  entity,
  business,
  workflow,
  reasoning,
  userPreference,
  temporary,
  permanent,
  system,
}

extension AssistantMemoryTypeX on AssistantMemoryType {
  Map<String, Object?> toDeterministicMap() => {'type': name};
}

/// Scope of a memory entry.
enum AssistantMemoryScope {
  session,
  user,
  company,
  global,
  system,
}

extension AssistantMemoryScopeX on AssistantMemoryScope {
  Map<String, Object?> toDeterministicMap() => {'scope': name};
}

/// Lifecycle status of a memory entry.
enum AssistantMemoryStatus {
  active,
  archived,
  expired,
  forgotten,
}

extension AssistantMemoryStatusX on AssistantMemoryStatus {
  Map<String, Object?> toDeterministicMap() => {'status': name};
}
