import '../domain/audit/assistant_audit_event_type.dart';
import '../models/assistant_audit_intent.dart';
import '../models/assistant_read_status_lexicon.dart';
import '../models/assistant_request.dart';
import 'assistant_capabilities.dart';

/// Deterministic resolver for AUDIT_STATUS intents.
class LocalAssistantAuditIntentResolver {
  const LocalAssistantAuditIntentResolver();

  AssistantAuditIntent? resolve({
    required AssistantRequest request,
    required AssistantCapabilities capabilities,
  }) {
    if (!capabilities.canPlanAuditTrail &&
        !capabilities.canExecuteAuditTrail) {
      return null;
    }

    final folded = AssistantReadStatusLexicon.fold(request.rawText)
        .replaceAll(RegExp(r'[?!.]+$'), '')
        .trim();

    if (!_isAudit(folded)) return null;

    return AuditStatusIntent(
      latestOnly: folded.contains('ultimo evento'),
      byType: _typeHint(folded),
    );
  }

  static bool _isAudit(String folded) =>
      folded.contains('historico de auditoria') ||
      folded.contains('auditoria da sessao') ||
      folded.contains('mostrar auditoria') ||
      folded.contains('consultar auditoria') ||
      folded.contains('status da auditoria') ||
      folded.contains('eventos de auditoria') ||
      folded == 'auditoria' ||
      folded == 'audit status' ||
      folded.contains('audit status');

  static String? _typeHint(String folded) {
    for (final type in AssistantAuditEventType.values) {
      final name = type.name.toLowerCase();
      if (folded.contains(name)) return type.name;
    }
    return null;
  }
}
