/// Role of a message in a model conversation (AI-025).
enum AssistantModelRole {
  system,
  user,
  assistant,
  tool,
}

extension AssistantModelRoleX on AssistantModelRole {
  Map<String, Object?> toDeterministicMap() => {'role': name};
}

/// Declared capabilities of a model / provider (AI-025 CP-4).
enum AssistantModelCapability {
  text,
  vision,
  audio,
  tools,
  json,
  streaming,
  functionCalling,
  reasoning,
}

extension AssistantModelCapabilityX on AssistantModelCapability {
  Map<String, Object?> toDeterministicMap() => {'capability': name};
}
