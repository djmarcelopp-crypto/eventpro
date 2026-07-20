/// Resolved audit-query intent (AI-015).
sealed class AssistantAuditIntent {
  const AssistantAuditIntent();
}

/// AUDIT_STATUS — session / correlation / type history.
final class AuditStatusIntent extends AssistantAuditIntent {
  const AuditStatusIntent({
    this.latestOnly = false,
    this.byType,
  });

  final bool latestOnly;

  /// Optional folded type name filter (e.g. "executionCompleted").
  final String? byType;
}
