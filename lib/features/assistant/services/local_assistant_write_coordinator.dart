import '../domain/assistant_write_authorizer.dart';
import '../domain/assistant_write_coordinator.dart';
import '../domain/assistant_write_validator.dart';
import '../domain/write/assistant_write_gateway.dart';
import '../domain/write/assistant_write_transaction.dart';
import '../models/assistant_execution_context.dart';
import '../models/assistant_execution_mode.dart';
import '../models/assistant_write_adapter_result.dart';
import '../models/assistant_write_authorization_status.dart';
import '../models/assistant_write_entity_state.dart';
import '../models/assistant_write_failure.dart';
import '../models/assistant_write_failure_code.dart';
import '../models/assistant_write_idempotency_status.dart';
import '../models/assistant_write_payload.dart';
import '../models/assistant_write_preparation.dart';
import '../models/assistant_write_request.dart';
import '../models/assistant_write_result.dart';
import '../models/assistant_write_transaction_status.dart';
import '../models/assistant_write_validation_result.dart';
import 'local_assistant_write_authorizer.dart';
import 'local_assistant_write_validator.dart';

/// Prepares write intents and, when all gates pass, executes via gateway.
class LocalAssistantWriteCoordinator implements AssistantWriteCoordinator {
  LocalAssistantWriteCoordinator({
    AssistantWriteValidator? validator,
    AssistantWriteAuthorizer? authorizer,
  })  : _authorizer = authorizer ?? const LocalAssistantWriteAuthorizer(),
        _validator = validator ??
            LocalAssistantWriteValidator(
              authorizer: authorizer ?? const LocalAssistantWriteAuthorizer(),
            );

  final AssistantWriteValidator _validator;
  final AssistantWriteAuthorizer _authorizer;

  @override
  AssistantWritePreparation prepare({
    required AssistantWriteRequest request,
    required AssistantExecutionContext context,
  }) {
    return _prepareInternal(
      request: request,
      context: context,
      confirmationSatisfied: false,
      allowProductionPrepare: false,
    );
  }

  @override
  Future<AssistantWritePreparation> prepareAndMaybeExecute({
    required AssistantWriteRequest request,
    required AssistantExecutionContext context,
    required bool confirmationSatisfied,
    AssistantWriteGateway? writeGateway,
  }) async {
    final preparation = _prepareInternal(
      request: request,
      context: context,
      confirmationSatisfied: confirmationSatisfied,
      allowProductionPrepare: true,
    );

    if (context.mode == AssistantExecutionMode.dryRun ||
        context.mode == AssistantExecutionMode.simulation) {
      return preparation.copyWith(
        writeResult: preparation.writeResult.copyWith(
          executed: false,
          mutatedErp: false,
          summary:
              '${preparation.writeResult.summary} Nenhuma alteração foi realizada no EventPRO.',
        ),
        writeWarnings: [
          ...preparation.writeWarnings,
          'Modo ${context.mode.name}: escrita real não executada',
        ],
      );
    }

    if (context.mode != AssistantExecutionMode.production) {
      return preparation;
    }

    final gate = _productionGate(
      request: request,
      context: context,
      preparation: preparation,
      confirmationSatisfied: confirmationSatisfied,
      writeGateway: writeGateway,
    );
    if (gate != null) {
      return preparation.copyWith(
        writeResult: preparation.writeResult.copyWith(
          accepted: false,
          executed: false,
          mutatedErp: false,
          failure: gate,
          rejectionReason: gate.message,
          summary: gate.message,
        ),
        writeWarnings: [...preparation.writeWarnings, gate.message],
      );
    }

    final payload = AssistantWritePayload(
      operation: request.operation,
      target: request.target,
      requestedState: request.requestedState,
      clientDisplayName: request.attributes['clientDisplayName'] ??
          request.attributes['clientName'] ??
          '',
      clientType: request.attributes['clientType'] ?? 'individual',
      notes: request.attributes['notes'] ?? '',
      lineItemName: request.attributes['lineItemName'] ??
          request.attributes['keywords']?.split(',').firstOrNull ??
          'Item (assistente)',
      lineItemUnit: request.attributes['lineItemUnit'] ?? 'un',
      lineItemQuantity: request.attributes['lineItemQuantity'] ?? '1',
      lineItemUnitPriceCents:
          request.attributes['lineItemUnitPriceCents'] ?? '0',
      attributes: request.attributes,
    );

    final transaction = AssistantWriteTransaction(
      id: 'wtx-${request.id}',
      request: request,
      payload: payload,
      context: context,
      idempotencyKey: request.idempotencyKey!,
      status: AssistantWriteTransactionStatus.prepared,
    );

    final adapterResult = await writeGateway!.execute(transaction);
    return _mergeAdapterResult(preparation, adapterResult);
  }

  AssistantWritePreparation _prepareInternal({
    required AssistantWriteRequest request,
    required AssistantExecutionContext context,
    required bool confirmationSatisfied,
    required bool allowProductionPrepare,
  }) {
    final validation = _validator.validate(request);
    var authorization = _authorizer.authorize(request);
    final warnings = <String>[...validation.warnings];

    if (request.requestId != context.requestId) {
      warnings.add(
        'WriteRequest.requestId diverge do ExecutionContext.requestId',
      );
    }

    if (allowProductionPrepare &&
        authorization ==
            AssistantWriteAuthorizationStatus.confirmationRequired &&
        (confirmationSatisfied ||
            (request.relatedStepId != null &&
                context.confirmedStepIds.contains(request.relatedStepId)))) {
      authorization = AssistantWriteAuthorizationStatus.authorized;
      warnings.add('Confirmação satisfeita no ExecutionContext');
    }

    var blockedByContext = false;
    if (context.mode == AssistantExecutionMode.production &&
        !allowProductionPrepare) {
      blockedByContext = true;
      warnings.add('prepare() isolado não executa production');
    }

    if (request.idempotencyKey == null || !request.idempotencyKey!.isValid) {
      warnings.add('idempotency key ausente ou inválida');
    }

    final accepted = validation.valid &&
        validation.blockedConstraints.isEmpty &&
        !blockedByContext &&
        authorization != AssistantWriteAuthorizationStatus.denied &&
        authorization !=
            AssistantWriteAuthorizationStatus.insufficientPrivileges;

    String? rejectionReason;
    if (!accepted) {
      if (blockedByContext) {
        rejectionReason = 'Bloqueado pelo ExecutionContext';
      } else if (validation.blockedConstraints.isNotEmpty) {
        rejectionReason = 'Constraints não satisfeitas';
      } else if (authorization == AssistantWriteAuthorizationStatus.denied ||
          authorization ==
              AssistantWriteAuthorizationStatus.insufficientPrivileges) {
        rejectionReason = 'Autorização insuficiente (${authorization.name})';
      } else if (validation.validationErrors.isNotEmpty) {
        rejectionReason = validation.validationErrors.first;
      } else {
        rejectionReason = 'Preparação não aceita';
      }
    }

    return AssistantWritePreparation(
      writeResult: AssistantWriteResult(
        id: 'wres-${request.id}',
        requestId: request.requestId,
        operation: request.operation,
        target: request.target,
        capability: request.capability,
        accepted: accepted,
        executed: false,
        mutatedErp: false,
        summary:
            'Intenção de escrita ${accepted ? 'preparada' : 'bloqueada'} '
            '(auth=${authorization.name}, mode=${context.mode.name}).',
        rejectionReason: rejectionReason,
        idempotencyStatus: request.idempotencyKey?.isValid == true
            ? AssistantWriteIdempotencyStatus.notApplicable
            : AssistantWriteIdempotencyStatus.missing,
      ),
      writeValidation: validation,
      writeAuthorization: authorization,
      writeWarnings: List.unmodifiable(warnings),
      context: context,
    );
  }

  AssistantWriteFailure? _productionGate({
    required AssistantWriteRequest request,
    required AssistantExecutionContext context,
    required AssistantWritePreparation preparation,
    required bool confirmationSatisfied,
    required AssistantWriteGateway? writeGateway,
  }) {
    if (!context.policy.allowRestrictedQuoteDraftProduction) {
      return const AssistantWriteFailure(
        code: AssistantWriteFailureCode.productionNotAllowed,
        message: 'Production sem exceção AI-006 de Quote Draft',
      );
    }
    if (!request.isAi006QuoteDraft) {
      return const AssistantWriteFailure(
        code: AssistantWriteFailureCode.unsupportedOperation,
        message: 'Somente create quote Draft é permitido em production',
      );
    }
    if (request.requestedState != AssistantWriteEntityState.draft) {
      return const AssistantWriteFailure(
        code: AssistantWriteFailureCode.invalidDraftState,
        message: 'Estado solicitado deve ser Draft',
      );
    }
    if (request.idempotencyKey == null || !request.idempotencyKey!.isValid) {
      return const AssistantWriteFailure(
        code: AssistantWriteFailureCode.missingIdempotencyKey,
        message: 'Idempotency key obrigatória para escrita real',
      );
    }
    if (preparation.writeAuthorization ==
            AssistantWriteAuthorizationStatus.denied ||
        preparation.writeAuthorization ==
            AssistantWriteAuthorizationStatus.insufficientPrivileges) {
      return const AssistantWriteFailure(
        code: AssistantWriteFailureCode.authorizationDenied,
        message: 'Autorização negada para escrita',
      );
    }
    if (!preparation.writeValidation.valid) {
      return const AssistantWriteFailure(
        code: AssistantWriteFailureCode.validationDenied,
        message: 'Validação da intenção de escrita negada',
      );
    }
    if (context.policy.requireConfirmationForWrites && !confirmationSatisfied) {
      return const AssistantWriteFailure(
        code: AssistantWriteFailureCode.confirmationRequired,
        message: 'Confirmação obrigatória ausente',
      );
    }
    if (writeGateway == null || !writeGateway.isAvailable) {
      return const AssistantWriteFailure(
        code: AssistantWriteFailureCode.adapterUnavailable,
        message: 'Write gateway/adapter indisponível',
      );
    }
    return null;
  }

  AssistantWritePreparation _mergeAdapterResult(
    AssistantWritePreparation preparation,
    AssistantWriteAdapterResult adapterResult,
  ) {
    final successMessage = adapterResult.executed
        ? 'O orçamento foi criado em estado Draft. '
            'Nenhuma aprovação, envio ou faturamento ocorreu.'
        : adapterResult.summary;

    return preparation.copyWith(
      writeResult: preparation.writeResult.copyWith(
        accepted: adapterResult.failure == null,
        executed: adapterResult.executed,
        mutatedErp: adapterResult.mutatedErp,
        draftId: adapterResult.draftId,
        draftNumber: adapterResult.draftNumber,
        resultingState: adapterResult.resultingState,
        idempotencyStatus: adapterResult.idempotencyStatus,
        failure: adapterResult.failure,
        rollbackAttempted: adapterResult.rollbackAttempted,
        rollbackSucceeded: adapterResult.rollbackSucceeded,
        summary: successMessage,
        rejectionReason: adapterResult.failure?.message,
      ),
      writeWarnings: [
        ...preparation.writeWarnings,
        ...adapterResult.warnings,
      ],
    );
  }
}

extension on AssistantWritePreparation {
  AssistantWritePreparation copyWith({
    AssistantWriteResult? writeResult,
    AssistantWriteValidationResult? writeValidation,
    AssistantWriteAuthorizationStatus? writeAuthorization,
    List<String>? writeWarnings,
  }) {
    return AssistantWritePreparation(
      writeResult: writeResult ?? this.writeResult,
      writeValidation: writeValidation ?? this.writeValidation,
      writeAuthorization: writeAuthorization ?? this.writeAuthorization,
      writeWarnings: writeWarnings ?? this.writeWarnings,
      context: context,
    );
  }
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
