import '../domain/audit/assistant_audit_event.dart';
import '../domain/audit/assistant_audit_gateway.dart';
import '../domain/audit/assistant_audit_query.dart';
import '../domain/audit/assistant_audit_repository.dart';
import 'in_memory_assistant_audit_repository.dart';

/// Local gateway over [AssistantAuditRepository].
class LocalAssistantAuditGateway implements AssistantAuditGateway {
  LocalAssistantAuditGateway({
    AssistantAuditRepository? repository,
  }) : _repository = repository ?? InMemoryAssistantAuditRepository();

  final AssistantAuditRepository _repository;

  /// Test/composition access to the backing store (not on the port).
  AssistantAuditRepository get repository => _repository;

  /// Optional test hook to force append failures.
  bool Function(AssistantAuditEvent event)? failAppendIf;

  @override
  AssistantAuditEvent append(AssistantAuditEvent event) {
    if (failAppendIf?.call(event) == true) {
      throw StateError('Forced audit append failure');
    }
    return _repository.append(event);
  }

  @override
  List<AssistantAuditEvent> query(AssistantAuditQuery query) =>
      _repository.query(query);

  @override
  int matchCount(AssistantAuditQuery query) => _repository.matchCount(query);
}
