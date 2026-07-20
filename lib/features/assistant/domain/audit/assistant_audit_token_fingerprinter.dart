/// Cryptographic fingerprinting of confirmation tokens for audit metadata.
///
/// Domain port — no Flutter, no key material, no plaintext storage.
abstract class AssistantAuditTokenFingerprinter {
  /// Deterministic fingerprint for [rawToken]. Never returns the raw token.
  String fingerprint(String rawToken);
}
