import 'assistant_audit_query.dart';
import 'assistant_audit_result.dart';

/// Runs deterministic audit queries with default limits.
abstract class AssistantAuditQueryService {
  AssistantAuditResult query(AssistantAuditQuery query);
}
