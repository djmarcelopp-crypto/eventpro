import 'dart:convert';

import 'hmac_sha256_assistant_audit_token_fingerprinter.dart';

/// Ephemeral key material for **local in-memory** audit only.
///
/// Not a production secret. Callers that persist or ship beyond the process
/// MUST inject managed key material into
/// [HmacSha256AssistantAuditTokenFingerprinter].
abstract final class AssistantAuditLocalKeyMaterial {
  /// Opaque ≥32-byte material for process-local audit fingerprints.
  static final List<int> inMemoryEphemeral = List<int>.unmodifiable(
    utf8.encode(
      'eventpro.assistant.audit.hmac.local-in-memory.v1.ephemeral-only',
    ),
  );
}
