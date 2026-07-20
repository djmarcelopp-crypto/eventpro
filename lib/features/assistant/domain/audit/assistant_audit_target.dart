/// What the audit event refers to (IDs / kinds only — no ERP payloads).
class AssistantAuditTarget {
  const AssistantAuditTarget({
    required this.kind,
    this.operationKind,
    this.referenceId,
  });

  /// e.g. confirmation | transactionExecution
  final String kind;
  final String? operationKind;
  final String? referenceId;

  Map<String, Object?> toDeterministicMap() => {
        'kind': kind,
        'operationKind': operationKind,
        'referenceId': referenceId,
      };
}
