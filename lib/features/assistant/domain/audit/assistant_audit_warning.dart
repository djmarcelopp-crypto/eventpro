/// Structured audit warning (codes only — no stack traces to the user).
class AssistantAuditWarning {
  const AssistantAuditWarning({
    required this.code,
    required this.message,
  });

  static const appendFailed = 'auditAppendFailed';
  static const appendFailedBeforeExecution = 'auditAppendFailedBeforeExecution';
  static const appendFailedAfterWrite = 'auditAppendFailedAfterWrite';
  static const missingSession = 'auditMissingSession';
  static const limitApplied = 'auditLimitApplied';

  final String code;
  final String message;

  Map<String, Object?> toDeterministicMap() => {
        'code': code,
        'message': message,
      };
}
