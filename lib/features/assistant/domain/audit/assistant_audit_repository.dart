import 'assistant_audit_event.dart';
import 'assistant_audit_event_type.dart';
import 'assistant_audit_query.dart';

/// Append-only audit repository (no update/delete of events).
abstract class AssistantAuditRepository {
  /// Appends [event] assigning the next monotonic sequence for its session.
  /// Returns the stored event (with sequence). Throws on failure.
  AssistantAuditEvent append(AssistantAuditEvent event);

  /// Chronological query (ascending by sequence / timestamp).
  List<AssistantAuditEvent> query(AssistantAuditQuery query);

  /// Full match count without applying [AssistantAuditQuery.limit].
  int matchCount(AssistantAuditQuery query);

  int countBySession(String sessionId);

  int countByCorrelation(String correlationId);

  int countByType(AssistantAuditEventType type);

  void reset({String? sessionId});
}
