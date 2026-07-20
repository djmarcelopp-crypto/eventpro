import 'assistant_audit_actor.dart';
import 'assistant_audit_event.dart';
import 'assistant_audit_event_type.dart';
import 'assistant_audit_target.dart';
import 'assistant_audit_warning.dart';

/// Builds sanitized audit events — does not persist.
abstract class AssistantAuditEventFactory {
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
  });

  /// Stable cryptographic fingerprint for confirmation tokens (via injected
  /// [AssistantAuditTokenFingerprinter] in local implementations).
  String tokenFingerprint(String rawToken);

  /// Stable correlation id for a confirmation/execution cycle.
  String correlationIdFor({
    required String sessionId,
    required String tokenFingerprint,
  });
}
