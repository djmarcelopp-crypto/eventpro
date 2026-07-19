import '../domain/assistant_write_authorizer.dart';
import '../domain/assistant_write_coordinator.dart';
import '../domain/assistant_write_validator.dart';
import '../models/assistant_execution_context.dart';
import '../models/assistant_execution_mode.dart';
import '../models/assistant_write_authorization_status.dart';
import '../models/assistant_write_preparation.dart';
import '../models/assistant_write_request.dart';
import '../models/assistant_write_result.dart';
import '../models/assistant_write_validation_result.dart';
import 'local_assistant_write_authorizer.dart';
import 'local_assistant_write_validator.dart';

/// Prepares write intents against the AI-004 execution context — never executes.
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
    final validation = _validator.validate(request);
    final authorization = _authorizer.authorize(request);
    final warnings = <String>[...validation.warnings];

    if (request.requestId != context.requestId) {
      warnings.add(
        'WriteRequest.requestId diverge do ExecutionContext.requestId',
      );
    }

    var blockedByContext = false;
    if (context.mode == AssistantExecutionMode.production) {
      blockedByContext = true;
      warnings.add(
        'ExecutionContext em production — escrita bloqueada em AI-005',
      );
    }

    if (authorization ==
            AssistantWriteAuthorizationStatus.confirmationRequired &&
        request.relatedStepId != null &&
        context.confirmedStepIds.contains(request.relatedStepId)) {
      warnings.add(
        'Confirmação do passo presente no ExecutionContext; '
        'escrita ainda não executada',
      );
    }

    if (context.policy.requireConfirmationForWrites &&
        authorization == AssistantWriteAuthorizationStatus.authorized) {
      warnings.add(
        'Policy exige confirmação para writes — preparação sem execução',
      );
    }

    final accepted = validation.valid && !blockedByContext;
    final rejectionReason = accepted
        ? null
        : _rejectionReason(
            validation: validation,
            authorization: authorization,
            blockedByContext: blockedByContext,
          );

    final result = AssistantWriteResult(
      id: 'wres-${request.id}',
      requestId: request.requestId,
      operation: request.operation,
      target: request.target,
      capability: request.capability,
      accepted: accepted,
      executed: false,
      summary: _summary(
        accepted: accepted,
        authorization: authorization,
        context: context,
      ),
      rejectionReason: rejectionReason,
    );

    // Hard invariant: AI-005 never executes writes.
    assert(!result.executed);

    return AssistantWritePreparation(
      writeResult: result,
      writeValidation: validation,
      writeAuthorization: authorization,
      writeWarnings: List.unmodifiable(warnings),
      context: context,
    );
  }

  static String _summary({
    required bool accepted,
    required AssistantWriteAuthorizationStatus authorization,
    required AssistantExecutionContext context,
  }) {
    final status = accepted ? 'preparada' : 'bloqueada';
    return 'Intenção de escrita $status '
        '(auth=${authorization.name}, mode=${context.mode.name}, '
        'token=${context.token.value}). '
        'A operação foi apenas preparada. '
        'Nenhuma alteração foi realizada no EventPRO.';
  }

  static String _rejectionReason({
    required AssistantWriteValidationResult validation,
    required AssistantWriteAuthorizationStatus authorization,
    required bool blockedByContext,
  }) {
    if (blockedByContext) {
      return 'Bloqueado pelo ExecutionContext';
    }
    if (validation.blockedConstraints.isNotEmpty) {
      return 'Constraints não satisfeitas';
    }
    if (authorization == AssistantWriteAuthorizationStatus.denied ||
        authorization ==
            AssistantWriteAuthorizationStatus.insufficientPrivileges) {
      return 'Autorização insuficiente (${authorization.name})';
    }
    if (validation.validationErrors.isNotEmpty) {
      return validation.validationErrors.first;
    }
    return 'Intenção de escrita não aceita';
  }
}
