import 'assistant_audit_event.dart';
import 'assistant_audit_query.dart';
import 'assistant_audit_repository.dart';

/// Port for appending and querying audit events.
abstract class AssistantAuditGateway {
  AssistantAuditRepository get repository;

  AssistantAuditEvent append(AssistantAuditEvent event);

  List<AssistantAuditEvent> query(AssistantAuditQuery query);
}
