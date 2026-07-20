import '../domain/audit/assistant_audit_actor.dart';
import '../domain/audit/assistant_audit_event.dart';
import '../domain/audit/assistant_audit_event_factory.dart';
import '../domain/audit/assistant_audit_event_id.dart';
import '../domain/audit/assistant_audit_event_type.dart';
import '../domain/audit/assistant_audit_metadata.dart';
import '../domain/audit/assistant_audit_target.dart';
import '../domain/audit/assistant_audit_token_fingerprinter.dart';
import '../domain/audit/assistant_audit_warning.dart';
import 'assistant_audit_local_key_material.dart';
import 'hmac_sha256_assistant_audit_token_fingerprinter.dart';

/// Deterministic factory — sanitizes tokens and never persists.
class LocalAssistantAuditEventFactory implements AssistantAuditEventFactory {
  LocalAssistantAuditEventFactory({
    DateTime Function()? clock,
    String Function()? idFactory,
    AssistantAuditTokenFingerprinter? tokenFingerprinter,
  })  : _clock = clock ?? DateTime.now,
        _idFactory = idFactory,
        _tokenFingerprinter = tokenFingerprinter ??
            HmacSha256AssistantAuditTokenFingerprinter(
              keyMaterial: AssistantAuditLocalKeyMaterial.inMemoryEphemeral,
            );

  final DateTime Function() _clock;
  final String Function()? _idFactory;
  final AssistantAuditTokenFingerprinter _tokenFingerprinter;
  int _seq = 0;

  /// Exposed for tests asserting injection wiring.
  AssistantAuditTokenFingerprinter get tokenFingerprinter =>
      _tokenFingerprinter;

  @override
  AssistantAuditEvent build({
    required AssistantAuditEventType eventType,
    required String sessionId,
    required String correlationId,
    required String outcome,
    AssistantAuditActor? actor,
    AssistantAuditTarget? target,
    String? rawToken,
    String? planFingerprint,
    String? outcomeCode,
    String? errorCode,
    Map<String, String>? extra,
    AssistantAuditWarning? warning,
  }) {
    final fingerprint =
        rawToken == null || rawToken.isEmpty ? null : tokenFingerprint(rawToken);
    final safeExtra = _sanitizeExtra(extra);
    return AssistantAuditEvent(
      eventId: AssistantAuditEventId(
        _idFactory?.call() ?? 'aud-${_clock().millisecondsSinceEpoch}-${++_seq}',
      ),
      eventType: eventType,
      timestamp: _clock().toUtc(),
      sessionId: sessionId,
      correlationId: correlationId,
      actor: actor ??
          const AssistantAuditActor(
            kind: AssistantAuditActorKind.assistant,
            label: 'assistant',
          ),
      target: target ??
          const AssistantAuditTarget(kind: 'transactionCycle'),
      metadata: AssistantAuditMetadata(
        tokenFingerprint: fingerprint,
        planFingerprint: planFingerprint,
        outcomeCode: outcomeCode,
        errorCode: errorCode,
        extra: safeExtra,
      ),
      outcome: outcome,
      warning: warning,
      sequence: 0,
    );
  }

  @override
  String tokenFingerprint(String rawToken) =>
      _tokenFingerprinter.fingerprint(rawToken);

  @override
  String correlationIdFor({
    required String sessionId,
    required String tokenFingerprint,
  }) =>
      'corr-$sessionId-$tokenFingerprint';

  Map<String, String> _sanitizeExtra(Map<String, String>? extra) {
    if (extra == null || extra.isEmpty) return const {};
    final out = <String, String>{};
    for (final entry in extra.entries) {
      final key = entry.key.toLowerCase();
      if (key.contains('token') ||
          key.contains('password') ||
          key.contains('secret') ||
          key.contains('credential') ||
          key.contains('rawtext') ||
          key.contains('message') ||
          key.contains('payload') ||
          key.contains('stack')) {
        continue;
      }
      final value = entry.value;
      if (value.length > 120) {
        out[entry.key] = '${value.substring(0, 117)}...';
      } else {
        out[entry.key] = value;
      }
    }
    return Map.unmodifiable(out);
  }
}
