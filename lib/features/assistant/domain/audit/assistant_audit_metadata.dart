/// Minimal safe metadata for an audit event (no secrets, no full payloads).
class AssistantAuditMetadata {
  const AssistantAuditMetadata({
    this.tokenFingerprint,
    this.planFingerprint,
    this.outcomeCode,
    this.errorCode,
    this.sequence,
    this.extra = const {},
  });

  /// Hash/fingerprint of confirmation token — never the raw token.
  final String? tokenFingerprint;
  final String? planFingerprint;
  final String? outcomeCode;
  final String? errorCode;
  final int? sequence;
  final Map<String, String> extra;

  Map<String, Object?> toDeterministicMap() => {
        'tokenFingerprint': tokenFingerprint,
        'planFingerprint': planFingerprint,
        'outcomeCode': outcomeCode,
        'errorCode': errorCode,
        'sequence': sequence,
        'extra': extra,
      };
}
