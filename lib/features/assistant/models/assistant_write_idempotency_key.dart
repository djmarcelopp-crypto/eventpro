/// Opaque idempotency key required for real write execution.
class AssistantWriteIdempotencyKey {
  const AssistantWriteIdempotencyKey(this.value);

  final String value;

  bool get isValid => value.trim().isNotEmpty;

  /// Stable non-reversible fingerprint for audits (not the raw key).
  String get auditFingerprint {
    final normalized = value.trim();
    var hash = 0x811c9dc5;
    for (final code in normalized.codeUnits) {
      hash ^= code;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash.toRadixString(16).padLeft(8, '0');
  }

  /// Deterministic draft id derived from the key (persistent uniqueness via quote.id).
  String get derivedDraftId {
    final normalized = value.trim();
    var hash = 0xcbf29ce484222325;
    for (final code in normalized.codeUnits) {
      hash ^= code;
      hash = (hash * 0x100000001b3) & 0x7fffffffffffffff;
    }
    final hex = hash.toRadixString(16).padLeft(16, '0');
    return 'asst-quote-$hex';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantWriteIdempotencyKey && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'AssistantWriteIdempotencyKey(*)';
}
