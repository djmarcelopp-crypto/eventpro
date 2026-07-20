/// Audit metadata for a transaction execution turn.
class AssistantTransactionExecutionMetadata {
  const AssistantTransactionExecutionMetadata({
    required this.requestId,
    required this.generatedAt,
    this.sessionId,
    this.token,
    this.operationKind,
    this.planFingerprint,
    this.idempotencyKey,
    this.draftId,
  });

  final String requestId;
  final DateTime generatedAt;
  final String? sessionId;
  final String? token;
  final String? operationKind;
  final String? planFingerprint;
  final String? idempotencyKey;
  final String? draftId;

  Map<String, Object?> toDeterministicMap() => {
        'requestId': requestId,
        'generatedAt': generatedAt.toUtc().toIso8601String(),
        'sessionId': sessionId,
        'token': token,
        'operationKind': operationKind,
        'planFingerprint': planFingerprint,
        'idempotencyKey': idempotencyKey,
        'draftId': draftId,
      };
}
