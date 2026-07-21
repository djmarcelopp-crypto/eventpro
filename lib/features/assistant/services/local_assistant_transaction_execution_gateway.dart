import '../domain/assistant_write_coordinator.dart';
import '../domain/transaction_execution/assistant_transaction_execution_gateway.dart';
import '../domain/transaction_execution/assistant_transaction_execution_metadata.dart';
import '../domain/transaction_execution/assistant_transaction_execution_outcome.dart';
import '../domain/transaction_execution/assistant_transaction_execution_request.dart';
import '../domain/transaction_execution/assistant_transaction_execution_result.dart';
import '../domain/transaction_execution/assistant_transaction_execution_warning.dart';
import '../domain/write/assistant_write_gateway.dart';
import '../models/assistant_confirmation_operation_kind.dart';
import '../models/assistant_execution_context.dart';
import '../models/assistant_write_authorization.dart';
import '../models/assistant_write_capability.dart';
import '../models/assistant_write_entity_state.dart';
import '../models/assistant_write_operation.dart';
import '../models/assistant_write_request.dart';
import '../models/assistant_write_result.dart';
import '../models/assistant_write_target.dart';

/// Gateway that executes only Create Quote Draft via the write pipeline.
///
/// AR-002: [writeGateway] is injected at construction (DIP), not via the port.
class LocalAssistantTransactionExecutionGateway
    implements AssistantTransactionExecutionGateway {
  LocalAssistantTransactionExecutionGateway({
    required AssistantWriteCoordinator writeCoordinator,
    AssistantWriteGateway? writeGateway,
    DateTime Function()? clock,
  })  : _writeCoordinator = writeCoordinator,
        _writeGateway = writeGateway,
        _clock = clock ?? DateTime.now;

  final AssistantWriteCoordinator _writeCoordinator;
  final AssistantWriteGateway? _writeGateway;
  final DateTime Function() _clock;

  @override
  Future<AssistantTransactionExecutionResult> execute({
    required AssistantTransactionExecutionRequest request,
    required AssistantExecutionContext context,
  }) async {
    final now = _clock().toUtc();

    if (request.operationKind !=
        AssistantConfirmationOperationKind.createQuoteDraft) {
      return AssistantTransactionExecutionResult(
        requestId: request.requestId,
        outcome: AssistantTransactionExecutionOutcome.unsupportedOperation,
        valid: false,
        executed: false,
        summary: 'Operação não suportada nesta sprint (apenas Create Quote Draft).',
        warnings: const [
          AssistantTransactionExecutionWarning(
            code: AssistantTransactionExecutionWarning.unsupportedOperation,
            message: 'Somente createQuoteDraft está conectado.',
          ),
        ],
        metadata: _meta(request, now),
      );
    }

    final writeRequest = AssistantWriteRequest(
      id: 'write-${request.requestId}-createQuote',
      requestId: request.requestId,
      operation: AssistantWriteOperation.create,
      target: AssistantWriteTarget.quote,
      capability: AssistantWriteCapability.createQuote,
      relatedStepId: 'step-create-quote',
      requestedState: AssistantWriteEntityState.draft,
      idempotencyKey: request.idempotencyKey,
      attributes: request.attributes,
      authorization: const AssistantWriteAuthorization(
        granted: true,
        requiresUserConfirmation: true,
        allowedCapabilities: {AssistantWriteCapability.createQuote},
        reason: 'AI-014 transaction execution after safe confirmation',
      ),
    );

    final preparation = await _writeCoordinator.prepareAndMaybeExecute(
      request: writeRequest,
      context: context,
      confirmationSatisfied: true,
      writeGateway: _writeGateway,
    );
    final writeResult = preparation.writeResult;

    if (!writeResult.executed) {
      return AssistantTransactionExecutionResult(
        requestId: request.requestId,
        outcome: AssistantTransactionExecutionOutcome.writeFailed,
        valid: false,
        executed: false,
        summary: writeResult.summary,
        writeResult: writeResult,
        warnings: [
          AssistantTransactionExecutionWarning(
            code: AssistantTransactionExecutionWarning.writeFailed,
            message: writeResult.rejectionReason ?? writeResult.summary,
          ),
        ],
        metadata: _meta(request, now, draftId: writeResult.draftId),
      );
    }

    return AssistantTransactionExecutionResult(
      requestId: request.requestId,
      outcome: AssistantTransactionExecutionOutcome.completed,
      valid: true,
      executed: true,
      summary:
          'Execução concluída: orçamento draft criado com confirmação consumida.',
      writeResult: writeResult,
      warnings: const [],
      metadata: _meta(request, now, draftId: writeResult.draftId),
    );
  }

  AssistantTransactionExecutionMetadata _meta(
    AssistantTransactionExecutionRequest request,
    DateTime now, {
    String? draftId,
  }) {
    return AssistantTransactionExecutionMetadata(
      requestId: request.requestId,
      generatedAt: now,
      sessionId: request.sessionId,
      token: request.token.value,
      operationKind: request.operationKind.name,
      planFingerprint: request.planFingerprint,
      idempotencyKey: request.idempotencyKey.value,
      draftId: draftId,
    );
  }
}
