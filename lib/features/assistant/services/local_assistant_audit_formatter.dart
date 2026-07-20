import '../domain/audit/assistant_audit_formatter.dart';
import '../domain/audit/assistant_audit_result.dart';
import '../models/assistant_audit_presentation.dart';

/// Deterministic NL + structured formatter for audit queries.
class LocalAssistantAuditFormatter implements AssistantAuditFormatter {
  const LocalAssistantAuditFormatter();

  @override
  AssistantAuditPresentation format(AssistantAuditResult result) {
    final nl = result.summary ??
        (result.events.isEmpty
            ? 'Nenhum evento de auditoria encontrado.'
            : 'Auditoria: ${result.returnedCount} evento(s).');
    return AssistantAuditPresentation.fromResult(
      result,
      naturalLanguage: nl,
    );
  }
}
