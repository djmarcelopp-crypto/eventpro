import '../domain/audit/assistant_audit_gateway.dart';
import '../domain/audit/assistant_audit_query.dart';
import '../domain/audit/assistant_audit_query_service.dart';
import '../domain/audit/assistant_audit_result.dart';
import '../domain/audit/assistant_audit_warning.dart';

/// Applies filters + mandatory limit and returns an immutable result.
class LocalAssistantAuditQueryService implements AssistantAuditQueryService {
  LocalAssistantAuditQueryService({
    required AssistantAuditGateway gateway,
  }) : _gateway = gateway;

  final AssistantAuditGateway _gateway;

  @override
  AssistantAuditResult query(AssistantAuditQuery query) {
    final effective = AssistantAuditQuery(
      requestId: query.requestId,
      sessionId: query.sessionId,
      correlationId: query.correlationId,
      eventType: query.eventType,
      latestOnly: query.latestOnly,
      limit: query.effectiveLimit,
    );

    final events = _gateway.query(effective);
    final totalMatched = _gateway.matchCount(effective);

    final warnings = <AssistantAuditWarning>[
      if (totalMatched > events.length)
        const AssistantAuditWarning(
          code: AssistantAuditWarning.limitApplied,
          message: 'Limite padrão de auditoria aplicado à consulta.',
        ),
      if (effective.sessionId == null || effective.sessionId!.trim().isEmpty)
        const AssistantAuditWarning(
          code: AssistantAuditWarning.missingSession,
          message: 'Consulta sem sessionId — escopo amplo ou vazio.',
        ),
    ];

    return AssistantAuditResult(
      requestId: query.requestId,
      events: events,
      totalMatched: totalMatched,
      returnedCount: events.length,
      query: effective,
      warnings: warnings,
      summary: events.isEmpty
          ? 'Nenhum evento de auditoria encontrado.'
          : 'Encontrados ${events.length} evento(s) de auditoria '
              '(total correspondente: $totalMatched).',
      valid: true,
    );
  }
}
