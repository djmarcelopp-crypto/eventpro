import 'assistant_audit_event.dart';
import 'assistant_audit_query.dart';

/// Port for appending and querying audit events.
///
/// AR-002: does not expose a concrete repository — callers use port methods only.
abstract class AssistantAuditGateway {
  AssistantAuditEvent append(AssistantAuditEvent event);

  List<AssistantAuditEvent> query(AssistantAuditQuery query);

  /// Full match count without applying query limit (DIP — no concrete repo).
  int matchCount(AssistantAuditQuery query);
}
