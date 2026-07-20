import '../domain/audit/assistant_audit_result.dart';

/// Natural-language + structured presentation of an audit query.
class AssistantAuditPresentation {
  const AssistantAuditPresentation({
    required this.naturalLanguage,
    required this.structured,
    this.warnings = const [],
  });

  final String naturalLanguage;
  final Map<String, Object?> structured;
  final List<String> warnings;

  factory AssistantAuditPresentation.fromResult(
    AssistantAuditResult result, {
    required String naturalLanguage,
  }) {
    return AssistantAuditPresentation(
      naturalLanguage: naturalLanguage,
      structured: result.toDeterministicMap(),
      warnings: result.warnings.map((w) => w.message).toList(growable: false),
    );
  }
}
