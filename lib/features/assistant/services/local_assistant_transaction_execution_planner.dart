import '../domain/transaction_execution/assistant_transaction_execution_metadata.dart';
import '../domain/transaction_execution/assistant_transaction_execution_outcome.dart';
import '../domain/transaction_execution/assistant_transaction_execution_planner.dart';
import '../domain/transaction_execution/assistant_transaction_execution_request.dart';
import '../domain/transaction_execution/assistant_transaction_execution_result.dart';
import '../domain/transaction_execution/assistant_transaction_execution_warning.dart';
import '../models/assistant_confirmation_operation_kind.dart';
import '../models/assistant_confirmation_session.dart';
import '../models/assistant_confirmation_token.dart';
import '../models/assistant_transaction_execution_intent.dart';
import '../models/assistant_transaction_plan_fingerprint.dart';
import '../models/assistant_write_idempotency_key.dart';

/// Validates confirmed pending and consumes the token before returning a request.
class LocalAssistantTransactionExecutionPlanner
    implements AssistantTransactionExecutionPlanner {
  LocalAssistantTransactionExecutionPlanner({
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;

  @override
  ({
    AssistantTransactionExecutionRequest? request,
    AssistantTransactionExecutionResult? rejection,
  }) plan({
    required AssistantTransactionExecutionIntent intent,
    required String requestId,
    required String? sessionId,
    required AssistantConfirmationSession? session,
    required AssistantConfirmationOperationKind proposedOperationKind,
    required Map<String, String> proposedAttributes,
    AssistantConfirmationToken? token,
  }) {
    final now = _clock().toUtc();
    final effectiveToken = switch (intent) {
      ExecuteConfirmedTransactionIntent(:final token) => token,
    };

    if (sessionId == null ||
        sessionId.trim().isEmpty ||
        session == null) {
      return (
        request: null,
        rejection: _reject(
          requestId: requestId,
          outcome: AssistantTransactionExecutionOutcome.invalidSession,
          summary: 'Sessão inválida — informe context.sessionId.',
          code: AssistantTransactionExecutionWarning.missingSession,
          message: 'sessionId ausente ou sessão não encontrada.',
          now: now,
          sessionId: sessionId,
        ),
      );
    }

    if (session.sessionId != sessionId) {
      return (
        request: null,
        rejection: _reject(
          requestId: requestId,
          outcome: AssistantTransactionExecutionOutcome.invalidSession,
          summary: 'sessionId não corresponde à sessão ativa.',
          code: AssistantTransactionExecutionWarning.sessionMismatch,
          message: 'Divergência entre sessionId do pedido e da sessão.',
          now: now,
          sessionId: sessionId,
        ),
      );
    }

    final pending = session.pending;
    if (pending == null) {
      return (
        request: null,
        rejection: _reject(
          requestId: requestId,
          outcome: AssistantTransactionExecutionOutcome.invalidConfirmation,
          summary: 'Nenhuma confirmação ativa para executar.',
          code: AssistantTransactionExecutionWarning.notConfirmed,
          message: 'Pending confirmation ausente.',
          now: now,
          sessionId: sessionId,
        ),
      );
    }

    final checkToken = token ?? effectiveToken;
    if (checkToken != null && pending.token != checkToken) {
      return (
        request: null,
        rejection: _reject(
          requestId: requestId,
          outcome: AssistantTransactionExecutionOutcome.invalidConfirmation,
          summary: 'Token de confirmação inválido.',
          code: AssistantTransactionExecutionWarning.invalidToken,
          message: 'Token não corresponde ao pending da sessão.',
          now: now,
          sessionId: sessionId,
          token: checkToken.value,
        ),
      );
    }

    if (pending.cancelled) {
      return (
        request: null,
        rejection: _reject(
          requestId: requestId,
          outcome: AssistantTransactionExecutionOutcome.confirmationCancelled,
          summary: 'Confirmação cancelada — execução recusada.',
          code: AssistantTransactionExecutionWarning.cancelled,
          message: 'Pending foi cancelado.',
          now: now,
          sessionId: sessionId,
          token: pending.token.value,
        ),
      );
    }

    if (pending.consumed) {
      return (
        request: null,
        rejection: _reject(
          requestId: requestId,
          outcome: AssistantTransactionExecutionOutcome.confirmationConsumed,
          summary: 'Token já consumido — execução única rejeitada.',
          code: AssistantTransactionExecutionWarning.tokenReused,
          message: 'Confirmação já foi consumida.',
          now: now,
          sessionId: sessionId,
          token: pending.token.value,
        ),
      );
    }

    if (pending.isPastExpiresAt(now)) {
      return (
        request: null,
        rejection: _reject(
          requestId: requestId,
          outcome: AssistantTransactionExecutionOutcome.confirmationExpired,
          summary: 'Confirmação expirada — execução recusada.',
          code: AssistantTransactionExecutionWarning.expired,
          message: 'TTL da confirmação esgotado.',
          now: now,
          sessionId: sessionId,
          token: pending.token.value,
        ),
      );
    }

    if (!pending.isConfirmedAwaitingExecution) {
      return (
        request: null,
        rejection: _reject(
          requestId: requestId,
          outcome: AssistantTransactionExecutionOutcome.invalidConfirmation,
          summary: 'Confirmação ainda não foi aceita pelo usuário.',
          code: AssistantTransactionExecutionWarning.notConfirmed,
          message: 'Pending não está confirmed.',
          now: now,
          sessionId: sessionId,
          token: pending.token.value,
        ),
      );
    }

    if (proposedOperationKind != pending.operationKind) {
      return (
        request: null,
        rejection: _reject(
          requestId: requestId,
          outcome: AssistantTransactionExecutionOutcome.planDivergence,
          summary: 'Plano divergente — operação diferente da aprovada.',
          code: AssistantTransactionExecutionWarning.planDivergence,
          message: 'operationKind proposto ≠ aprovado.',
          now: now,
          sessionId: sessionId,
          token: pending.token.value,
          operationKind: proposedOperationKind.name,
          planFingerprint: pending.approvedPlanFingerprint,
        ),
      );
    }

    final proposedFingerprint = AssistantTransactionPlanFingerprint.compute(
      operationKind: proposedOperationKind,
      attributes: proposedAttributes,
    );
    if (proposedFingerprint != pending.approvedPlanFingerprint) {
      return (
        request: null,
        rejection: _reject(
          requestId: requestId,
          outcome: AssistantTransactionExecutionOutcome.planDivergence,
          summary: 'Plano divergente — atributos diferem do aprovado.',
          code: AssistantTransactionExecutionWarning.planDivergence,
          message: 'Fingerprint do plano não corresponde.',
          now: now,
          sessionId: sessionId,
          token: pending.token.value,
          operationKind: proposedOperationKind.name,
          planFingerprint: proposedFingerprint,
        ),
      );
    }

    // Atomic single-use consume before returning the executable request.
    final consumed = session.tryConsume(token: pending.token, now: now);
    if (!consumed) {
      return (
        request: null,
        rejection: _reject(
          requestId: requestId,
          outcome: AssistantTransactionExecutionOutcome.confirmationConsumed,
          summary: 'Falha ao consumir confirmação — execução recusada.',
          code: AssistantTransactionExecutionWarning.tokenReused,
          message: 'Consumo atômico falhou (já usado ou inválido).',
          now: now,
          sessionId: sessionId,
          token: pending.token.value,
        ),
      );
    }

    final idempotencyKey = AssistantWriteIdempotencyKey(
      'asst-tx-${sessionId}-${pending.token.value}-createQuote',
    );

    return (
      request: AssistantTransactionExecutionRequest(
        id: 'tx-$requestId',
        requestId: requestId,
        sessionId: sessionId,
        token: pending.token,
        operationKind: pending.operationKind,
        attributes: Map<String, String>.unmodifiable(pending.approvedAttributes),
        planFingerprint: pending.approvedPlanFingerprint,
        idempotencyKey: idempotencyKey,
      ),
      rejection: null,
    );
  }

  AssistantTransactionExecutionResult _reject({
    required String requestId,
    required AssistantTransactionExecutionOutcome outcome,
    required String summary,
    required String code,
    required String message,
    required DateTime now,
    String? sessionId,
    String? token,
    String? operationKind,
    String? planFingerprint,
  }) {
    return AssistantTransactionExecutionResult(
      requestId: requestId,
      outcome: outcome,
      valid: false,
      executed: false,
      summary: summary,
      warnings: [
        AssistantTransactionExecutionWarning(code: code, message: message),
      ],
      metadata: AssistantTransactionExecutionMetadata(
        requestId: requestId,
        generatedAt: now,
        sessionId: sessionId,
        token: token,
        operationKind: operationKind,
        planFingerprint: planFingerprint,
      ),
    );
  }
}
