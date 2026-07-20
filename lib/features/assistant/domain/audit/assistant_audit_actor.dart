/// Who initiated the audited action (no PII).
enum AssistantAuditActorKind {
  user,
  system,
  assistant,
}

class AssistantAuditActor {
  const AssistantAuditActor({
    required this.kind,
    this.label = 'assistant',
  });

  final AssistantAuditActorKind kind;

  /// Non-PII label (e.g. "assistant", "user").
  final String label;

  Map<String, Object?> toDeterministicMap() => {
        'kind': kind.name,
        'label': label,
      };
}
