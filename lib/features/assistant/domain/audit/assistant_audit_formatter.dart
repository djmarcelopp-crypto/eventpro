import '../../models/assistant_audit_presentation.dart';
import 'assistant_audit_result.dart';

/// Formats audit query results for [AssistantResponse].
abstract class AssistantAuditFormatter {
  AssistantAuditPresentation format(AssistantAuditResult result);
}
