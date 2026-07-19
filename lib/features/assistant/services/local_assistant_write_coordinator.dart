import '../domain/assistant_write_authorizer.dart';
import '../domain/assistant_write_coordinator.dart';
import '../domain/assistant_write_validator.dart';
import '../domain/idempotency/assistant_idempotency_service.dart';
import '../domain/observability/assistant_write_observer.dart';
import '../domain/policy/assistant_production_write_policy_registry.dart';
import '../domain/write/assistant_write_gateway.dart';
import '../domain/write/assistant_write_transaction.dart';
import '../models/assistant_confirmation_status.dart';
import '../models/assistant_execution_context.dart';
import '../models/assistant_execution_mode.dart';
import '../models/assistant_idempotency_result.dart';
import '../models/assistant_idempotency_status.dart';
import '../models/assistant_production_write_policy_context.dart';
import '../models/assistant_write_adapter_result.dart';
import '../models/assistant_write_audit_record.dart';
import '../models/assistant_write_authorization_status.dart';
import '../models/assistant_write_entity_state.dart';
import '../models/assistant_write_failure.dart';
import '../models/assistant_write_failure_code.dart';
import '../models/assistant_write_idempotency_status.dart';
import '../models/assistant_write_observation.dart';
import '../models/assistant_write_outcome_category.dart';
import '../models/assistant_write_payload.dart';
import '../models/assistant_write_preparation.dart';
import '../models/assistant_write_request.dart';
import '../models/assistant_write_result.dart';
import '../models/assistant_write_transaction_status.dart';
import '../models/assistant_write_validation_result.dart';
import 'local_assistant_idempotency_service.dart';
import 'local_assistant_write_authorizer.dart';
import 'local_assistant_write_validator.dart';
import 'policies/blocked_production_write_policies.dart';
import 'policies/quote_draft_production_policy.dart';

/// Prepares write intents and executes via policy + idempotency + gateway.
class LocalAssistantWriteCoordinator implements AssistantWriteCoordinator {
  LocalAssistantWriteCoordinator({
    AssistantWriteValidator? validator,
    AssistantWriteAuthorizer? authorizer,
    AssistantIdempotencyService? idempotencyService,
    AssistantProductionWritePolicyRegistry? policyRegistry,
    AssistantWriteObserver? observer,
    DateTime Function()? clock,
  })  : _authorizer = authorizer ?? const LocalAssistantWriteAuthorizer(),
        _validator = validator ??
            LocalAssistantWriteValidator(
              authorizer: authorizer ?? const LocalAssistantWriteAuthorizer(),
            ),
        _idempotency = idempotencyService ?? LocalAssistantIdempotencyService(),
        _policies = policyRegistry ??
            AssistantProductionWritePolicyRegistry(const [
              QuoteDraftProductionPolicy(),
              EventProductionPolicy(),
              CustomerProductionPolicy(),
            ]),
        _observer = SafeAssistantWriteObserver(
          observer ?? const NoOpAssistantWriteObserver(),
        ),
        _clock = clock ?? DateTime.now;

  final AssistantWriteValidator _validator;
  final AssistantWriteAuthorizer _authorizer;
  final AssistantIdempotencyService _idempotency;
  final AssistantProductionWritePolicyRegistry _policies;
  final AssistantWriteObserver _observer;
  final DateTime Function() _clock;

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
    final startedAt = _clock();
    var preparation = _prepareInternal(
      request: request,
      context: context,
      confirmationSatisfied: confirmationSatisfied,
      allowProductionPrepare: true,
    );

    if (context.mode == AssistantExecutionMode.dryRun ||
        context.mode == AssistantExecutionMode.simulation) {
      preparation = preparation.copyWith(
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
      final finishedAt = _clock();
      final audit = _buildAudit(
        request: request,
        context: context,
        preparation: preparation,
        confirmationSatisfied: confirmationSatisfied,
        startedAt: startedAt,
        finishedAt: finishedAt,
        policyName: 'none',
        adapterName: writeGateway?.quoteDraftAdapter?.name ?? '',
        outcome: context.mode == AssistantExecutionMode.dryRun
            ? AssistantWriteOutcomeCategory.dryRun
            : AssistantWriteOutcomeCategory.simulation,
        transactionStatus: AssistantWriteTransactionStatus.skipped,
        lifecycleStatus: null,
      );
      _emitObservation(audit);
      return preparation.copyWith(writeAudit: audit);
    }

    if (context.mode != AssistantExecutionMode.production) {
      return preparation;
    }

    final adapterName = writeGateway?.quoteDraftAdapter?.name ?? '';
    final policyDecision = _policies.resolve(
      AssistantProductionWritePolicyContext(
        request: request,
        executionContext: context,
        preparation: preparation,
        confirmationSatisfied: confirmationSatisfied,
        adapterAvailable: writeGateway?.isAvailable == true,
        adapterName: adapterName,
      ),
    );

    if (!policyDecision.allowed) {
      final failure = policyDecision.failure ??
          const AssistantWriteFailure(
            code: AssistantWriteFailureCode.productionNotAllowed,
            message: 'Production negada pela policy',
          );
      preparation = preparation.copyWith(
        writeResult: preparation.writeResult.copyWith(
          accepted: false,
          executed: false,
          mutatedErp: false,
          failure: failure,
          rejectionReason: failure.message,
          summary: failure.message,
        ),
        writeWarnings: [...preparation.writeWarnings, failure.message],
      );
      final finishedAt = _clock();
      final audit = _buildAudit(
        request: request,
        context: context,
        preparation: preparation,
        confirmationSatisfied: confirmationSatisfied,
        startedAt: startedAt,
        finishedAt: finishedAt,
        policyName: policyDecision.policyName,
        adapterName: adapterName,
        outcome: AssistantWriteOutcomeCategory.blocked,
        transactionStatus: AssistantWriteTransactionStatus.skipped,
        lifecycleStatus: null,
      );
      _emitObservation(audit);
      return preparation.copyWith(writeAudit: audit);
    }

    final idemBegin = await _idempotency.begin(request.idempotencyKey!);
    if (!idemBegin.mayMutate) {
      preparation = _fromIdempotencyReplay(preparation, idemBegin);
      final finishedAt = _clock();
      final audit = _buildAudit(
        request: request,
        context: context,
        preparation: preparation,
        confirmationSatisfied: confirmationSatisfied,
        startedAt: startedAt,
        finishedAt: finishedAt,
        policyName: policyDecision.policyName,
        adapterName: adapterName,
        outcome: idemBegin.decision ==
                AssistantIdempotencyBeginDecision.replayCompleted
            ? AssistantWriteOutcomeCategory.idempotentReplay
            : AssistantWriteOutcomeCategory.blocked,
        transactionStatus: AssistantWriteTransactionStatus.skipped,
        lifecycleStatus: idemBegin.record.status,
      );
      _emitObservation(audit);
      return preparation.copyWith(writeAudit: audit);
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
      adapterName: adapterName,
    );

    final adapterResult = await writeGateway!.execute(transaction);
    await _finalizeIdempotency(request, adapterResult);
    preparation = _mergeAdapterResult(preparation, adapterResult);

    final finishedAt = _clock();
    final outcome = _outcomeCategory(adapterResult);
    final audit = _buildAudit(
      request: request,
      context: context,
      preparation: preparation,
      confirmationSatisfied: confirmationSatisfied,
      startedAt: startedAt,
      finishedAt: finishedAt,
      policyName: policyDecision.policyName,
      adapterName: adapterName,
      outcome: outcome,
      transactionStatus: adapterResult.transactionStatus,
      lifecycleStatus: (await _idempotency.findByKey(request.idempotencyKey!))
          ?.status,
    );
    _emitObservation(audit);
    return preparation.copyWith(writeAudit: audit);
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

  Future<void> _finalizeIdempotency(
    AssistantWriteRequest request,
    AssistantWriteAdapterResult adapterResult,
  ) async {
    final key = request.idempotencyKey!;
    if (adapterResult.failure?.code == AssistantWriteFailureCode.timeout ||
        adapterResult.failure?.uncertain == true) {
      await _idempotency.markUncertain(
        key,
        message: adapterResult.failure?.message ?? 'Resultado incerto',
      );
      return;
    }
    if (adapterResult.executed && adapterResult.draftId != null) {
      await _idempotency.complete(
        key,
        draftId: adapterResult.draftId!,
        draftNumber: adapterResult.draftNumber,
        mutatedErp: adapterResult.mutatedErp,
      );
      return;
    }
    await _idempotency.fail(
      key,
      code: adapterResult.failure?.code ??
          AssistantWriteFailureCode.serviceFailure,
      message: adapterResult.failure?.message ?? adapterResult.summary,
    );
  }

  AssistantWritePreparation _fromIdempotencyReplay(
    AssistantWritePreparation preparation,
    AssistantIdempotencyResult idemBegin,
  ) {
    final record = idemBegin.record;
    if (idemBegin.decision ==
        AssistantIdempotencyBeginDecision.replayCompleted) {
      return preparation.copyWith(
        writeResult: preparation.writeResult.copyWith(
          accepted: true,
          executed: true,
          mutatedErp: false,
          draftId: record.resultDraftId,
          draftNumber: record.resultDraftNumber,
          resultingState: AssistantWriteEntityState.draft,
          idempotencyStatus: AssistantWriteIdempotencyStatus.replayed,
          summary:
              'Rascunho recuperado por idempotência: ${record.resultDraftNumber ?? record.resultDraftId}. '
              'Nenhuma aprovação, envio ou faturamento ocorreu.',
        ),
        writeWarnings: [
          ...preparation.writeWarnings,
          'Replay idempotente — nenhuma nova mutação',
        ],
      );
    }
    final code = idemBegin.decision ==
            AssistantIdempotencyBeginDecision.blockedUncertain
        ? AssistantWriteFailureCode.uncertainOutcome
        : AssistantWriteFailureCode.duplicateOperation;
    return preparation.copyWith(
      writeResult: preparation.writeResult.copyWith(
        accepted: false,
        executed: false,
        mutatedErp: false,
        failure: AssistantWriteFailure(
          code: code,
          message: 'Idempotência bloqueou nova mutação (${record.status.name})',
          uncertain: code == AssistantWriteFailureCode.uncertainOutcome,
        ),
        rejectionReason: 'Idempotência: ${record.status.name}',
        summary: 'Escrita bloqueada por idempotência (${record.status.name})',
        idempotencyStatus: AssistantWriteIdempotencyStatus.conflict,
      ),
    );
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

  AssistantWriteAuditRecord _buildAudit({
    required AssistantWriteRequest request,
    required AssistantExecutionContext context,
    required AssistantWritePreparation preparation,
    required bool confirmationSatisfied,
    required DateTime startedAt,
    required DateTime finishedAt,
    required String policyName,
    required String adapterName,
    required AssistantWriteOutcomeCategory outcome,
    required AssistantWriteTransactionStatus transactionStatus,
    required AssistantIdempotencyStatus? lifecycleStatus,
  }) {
    final result = preparation.writeResult;
    final duration = finishedAt.difference(startedAt).inMilliseconds;
    return AssistantWriteAuditRecord(
      correlationId: context.requestId,
      requestId: request.requestId,
      executionId: context.token.value,
      executionToken: context.token,
      idempotencyFingerprint: request.idempotencyKey?.auditFingerprint ?? '',
      lifecycleIdempotencyStatus: lifecycleStatus,
      writeIdempotencyStatus: result.idempotencyStatus,
      operation: request.operation,
      target: request.target,
      requestedState: request.requestedState,
      resultingState: result.resultingState,
      executionMode: context.mode,
      policyName: policyName,
      adapterName: adapterName,
      authorizationStatus: preparation.writeAuthorization,
      confirmationStatus: confirmationSatisfied
          ? AssistantConfirmationStatus.providedValid
          : (context.policy.requireConfirmationForWrites
              ? AssistantConfirmationStatus.requiredMissing
              : AssistantConfirmationStatus.notRequired),
      startedAt: startedAt.toUtc(),
      finishedAt: finishedAt.toUtc(),
      durationMs: duration < 0 ? 0 : duration,
      outcome: outcome,
      transactionStatus: transactionStatus,
      failureCode: result.failure?.code,
      createdDraftId: result.draftId,
      executed: result.executed,
      mutatedErp: result.mutatedErp,
      rollbackAttempted: result.rollbackAttempted,
      rollbackSucceeded: result.rollbackAttempted && result.rollbackSucceeded,
      warnings: [...preparation.writeWarnings]..sort(),
    );
  }

  void _emitObservation(AssistantWriteAuditRecord audit) {
    _observer.onObservation(
      AssistantWriteObservation(
        operation: audit.operation,
        target: audit.target,
        executionMode: audit.executionMode,
        policyName: audit.policyName,
        adapterName: audit.adapterName,
        idempotencyStatus: audit.writeIdempotencyStatus,
        startedAt: audit.startedAt,
        finishedAt: audit.finishedAt,
        durationMs: audit.durationMs,
        confirmationStatus: audit.confirmationStatus,
        authorizationStatus: audit.authorizationStatus,
        outcome: audit.outcome,
        executed: audit.executed,
        mutatedErp: audit.mutatedErp,
        timeout: audit.failureCode == AssistantWriteFailureCode.timeout,
        rollbackAttempted: audit.rollbackAttempted,
        rollbackSucceeded: audit.rollbackSucceeded,
        warningCount: audit.warnings.length,
        failureCode: audit.failureCode,
      ),
    );
  }

  static AssistantWriteOutcomeCategory _outcomeCategory(
    AssistantWriteAdapterResult result,
  ) {
    if (result.failure?.code == AssistantWriteFailureCode.timeout) {
      return AssistantWriteOutcomeCategory.timeout;
    }
    if (result.failure?.uncertain == true) {
      return AssistantWriteOutcomeCategory.uncertain;
    }
    if (result.rollbackAttempted) {
      return AssistantWriteOutcomeCategory.rollback;
    }
    if (result.idempotencyStatus == AssistantWriteIdempotencyStatus.replayed) {
      return AssistantWriteOutcomeCategory.idempotentReplay;
    }
    if (result.executed) return AssistantWriteOutcomeCategory.success;
    if (result.failure != null) return AssistantWriteOutcomeCategory.failed;
    return AssistantWriteOutcomeCategory.blocked;
  }
}

extension on AssistantWritePreparation {
  AssistantWritePreparation copyWith({
    AssistantWriteResult? writeResult,
    AssistantWriteValidationResult? writeValidation,
    AssistantWriteAuthorizationStatus? writeAuthorization,
    List<String>? writeWarnings,
    AssistantWriteAuditRecord? writeAudit,
  }) {
    return AssistantWritePreparation(
      writeResult: writeResult ?? this.writeResult,
      writeValidation: writeValidation ?? this.writeValidation,
      writeAuthorization: writeAuthorization ?? this.writeAuthorization,
      writeWarnings: writeWarnings ?? this.writeWarnings,
      context: context,
      writeAudit: writeAudit ?? this.writeAudit,
    );
  }
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
