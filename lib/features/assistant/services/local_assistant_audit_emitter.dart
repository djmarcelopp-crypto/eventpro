import '../domain/audit/assistant_audit_event.dart';
import '../domain/audit/assistant_audit_event_factory.dart';
import '../domain/audit/assistant_audit_event_type.dart';
import '../domain/audit/assistant_audit_gateway.dart';
import '../domain/audit/assistant_audit_target.dart';
import '../domain/audit/assistant_audit_warning.dart';
import '../domain/transaction_execution/assistant_transaction_execution_outcome.dart';
import '../domain/transaction_execution/assistant_transaction_execution_result.dart';
import '../models/assistant_confirmation_outcome.dart';
import '../models/assistant_confirmation_result.dart';

/// Orchestrator-side audit emission helpers (planners never call this).
class LocalAssistantAuditEmitter {
  LocalAssistantAuditEmitter({
    required AssistantAuditGateway gateway,
    required AssistantAuditEventFactory factory,
  })  : _gateway = gateway,
        _factory = factory;

  final AssistantAuditGateway _gateway;
  final AssistantAuditEventFactory _factory;

  String correlationFor({
    required String sessionId,
    String? rawToken,
  }) {
    if (rawToken == null || rawToken.isEmpty) {
      return 'corr-$sessionId-none';
    }
    return _factory.correlationIdFor(
      sessionId: sessionId,
      tokenFingerprint: _factory.tokenFingerprint(rawToken),
    );
  }

  /// Returns null on success, or a warning when append fails.
  AssistantAuditWarning? tryAppend(AssistantAuditEvent event) {
    try {
      _gateway.append(event);
      return null;
    } catch (_) {
      return const AssistantAuditWarning(
        code: AssistantAuditWarning.appendFailed,
        message: 'Falha ao registrar evento de auditoria.',
      );
    }
  }

  AssistantAuditWarning? emitConfirmation(
    AssistantConfirmationResult result, {
    required String sessionId,
  }) {
    final type = switch (result.outcome) {
      AssistantConfirmationOutcome.previewCreated =>
        AssistantAuditEventType.confirmationCreated,
      AssistantConfirmationOutcome.confirmed =>
        AssistantAuditEventType.confirmationConfirmed,
      AssistantConfirmationOutcome.cancelled =>
        AssistantAuditEventType.confirmationCancelled,
      AssistantConfirmationOutcome.expired =>
        AssistantAuditEventType.confirmationExpired,
      AssistantConfirmationOutcome.missing ||
      AssistantConfirmationOutcome.invalid =>
        AssistantAuditEventType.confirmationStatusChecked,
    };

    // Status checks that still show an active pending map to statusChecked.
    final isStatus =
        result.outcome == AssistantConfirmationOutcome.previewCreated &&
            result.summary?.contains('pendente') == true;
    final eventType = isStatus
        ? AssistantAuditEventType.confirmationStatusChecked
        : type;

    final rawToken = result.metadata.token ?? result.pending?.token.value;
    final event = _factory.build(
      eventType: eventType,
      sessionId: sessionId,
      correlationId: correlationFor(sessionId: sessionId, rawToken: rawToken),
      outcome: result.outcome.name,
      rawToken: rawToken,
      planFingerprint: result.pending?.approvedPlanFingerprint,
      outcomeCode: result.outcome.name,
      target: AssistantAuditTarget(
        kind: 'confirmation',
        operationKind: result.pending?.operationKind.name,
      ),
    );
    return tryAppend(event);
  }

  /// Appends executionRequested. On failure returns warning (caller must block write).
  AssistantAuditWarning? emitExecutionRequested({
    required String sessionId,
    required String rawToken,
    String? planFingerprint,
    String? operationKind,
  }) {
    final event = _factory.build(
      eventType: AssistantAuditEventType.executionRequested,
      sessionId: sessionId,
      correlationId: correlationFor(sessionId: sessionId, rawToken: rawToken),
      outcome: 'requested',
      rawToken: rawToken,
      planFingerprint: planFingerprint,
      target: AssistantAuditTarget(
        kind: 'transactionExecution',
        operationKind: operationKind,
      ),
    );
    final failure = tryAppend(event);
    if (failure == null) return null;
    return const AssistantAuditWarning(
      code: AssistantAuditWarning.appendFailedBeforeExecution,
      message:
          'Falha de auditoria antes da execução — escrita bloqueada.',
    );
  }

  AssistantAuditWarning? emitExecutionRejected(
    AssistantTransactionExecutionResult result, {
    required String sessionId,
    String? rawToken,
    String? planFingerprint,
  }) {
    final event = _factory.build(
      eventType: AssistantAuditEventType.executionRejected,
      sessionId: sessionId,
      correlationId: correlationFor(sessionId: sessionId, rawToken: rawToken),
      outcome: result.outcome.name,
      rawToken: rawToken,
      planFingerprint: planFingerprint,
      outcomeCode: result.outcome.name,
      errorCode: result.warnings.isEmpty ? null : result.warnings.first.code,
      target: const AssistantAuditTarget(kind: 'transactionExecution'),
    );
    return tryAppend(event);
  }

  /// Post-write append. Failure returns after-write warning (does not undo write).
  AssistantAuditWarning? emitExecutionFinished(
    AssistantTransactionExecutionResult result, {
    required String sessionId,
    required String rawToken,
    String? planFingerprint,
  }) {
    final type =
        result.outcome == AssistantTransactionExecutionOutcome.writeFailed
            ? AssistantAuditEventType.executionWriteFailed
            : AssistantAuditEventType.executionCompleted;
    final event = _factory.build(
      eventType: type,
      sessionId: sessionId,
      correlationId: correlationFor(sessionId: sessionId, rawToken: rawToken),
      outcome: result.outcome.name,
      rawToken: rawToken,
      planFingerprint: planFingerprint,
      outcomeCode: result.outcome.name,
      errorCode: result.outcome ==
              AssistantTransactionExecutionOutcome.writeFailed
          ? (result.warnings.isEmpty ? 'writeFailed' : result.warnings.first.code)
          : null,
      extra: {
        if (result.writeResult?.draftId != null)
          'draftId': result.writeResult!.draftId!,
        'executed': '${result.executed}',
        'mutatedErp': '${result.writeResult?.mutatedErp ?? false}',
      },
      target: const AssistantAuditTarget(
        kind: 'transactionExecution',
        operationKind: 'createQuoteDraft',
      ),
    );
    final failure = tryAppend(event);
    if (failure == null) return null;
    return const AssistantAuditWarning(
      code: AssistantAuditWarning.appendFailedAfterWrite,
      message:
          'Escrita concluída, mas a auditoria falhou ao registrar o evento.',
    );
  }
}
