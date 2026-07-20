import 'assistant_audit_actor.dart';
import 'assistant_audit_event_id.dart';
import 'assistant_audit_event_type.dart';
import 'assistant_audit_metadata.dart';
import 'assistant_audit_target.dart';
import 'assistant_audit_warning.dart';

/// Immutable append-only audit event (in-memory trail — AI-015).
class AssistantAuditEvent {
  const AssistantAuditEvent({
    required this.eventId,
    required this.eventType,
    required this.timestamp,
    required this.sessionId,
    required this.correlationId,
    required this.actor,
    required this.target,
    required this.metadata,
    required this.outcome,
    this.warning,
    required this.sequence,
  });

  final AssistantAuditEventId eventId;
  final AssistantAuditEventType eventType;
  final DateTime timestamp;
  final String sessionId;
  final String correlationId;
  final AssistantAuditActor actor;
  final AssistantAuditTarget target;
  final AssistantAuditMetadata metadata;
  final String outcome;
  final AssistantAuditWarning? warning;

  /// Monotonic per-session sequence assigned by the repository on append.
  final int sequence;

  Map<String, Object?> toDeterministicMap() => {
        'eventId': eventId.value,
        'eventType': eventType.name,
        'timestamp': timestamp.toUtc().toIso8601String(),
        'sessionId': sessionId,
        'correlationId': correlationId,
        'actor': actor.toDeterministicMap(),
        'target': target.toDeterministicMap(),
        'metadata': metadata.toDeterministicMap(),
        'outcome': outcome,
        'warning': warning?.toDeterministicMap(),
        'sequence': sequence,
      };
}
