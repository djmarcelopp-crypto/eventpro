import '../domain/audit/assistant_audit_event.dart';
import '../domain/audit/assistant_audit_gateway.dart';
import '../domain/audit/assistant_audit_query.dart';
import '../domain/audit/assistant_audit_repository.dart';
import 'in_memory_assistant_audit_repository.dart';

/// Local gateway over [AssistantAuditRepository].
class LocalAssistantAuditGateway implements AssistantAuditGateway {
  LocalAssistantAuditGateway({
    AssistantAuditRepository? repository,
  }) : repository = repository ?? InMemoryAssistantAuditRepository();

  @override
  final AssistantAuditRepository repository;

  /// Optional test hook to force append failures.
  bool Function(AssistantAuditEvent event)? failAppendIf;

  @override
  AssistantAuditEvent append(AssistantAuditEvent event) {
    if (failAppendIf?.call(event) == true) {
      throw StateError('Forced audit append failure');
    }
    return repository.append(event);
  }

  @override
  List<AssistantAuditEvent> query(AssistantAuditQuery query) =>
      repository.query(query);
}
