import '../domain/assistant_write_authorizer.dart';
import '../domain/assistant_write_validator.dart';
import '../models/assistant_write_authorization_status.dart';
import '../models/assistant_write_capability.dart';
import '../models/assistant_write_operation.dart';
import '../models/assistant_write_request.dart';
import '../models/assistant_write_target.dart';
import '../models/assistant_write_validation_result.dart';
import 'local_assistant_write_authorizer.dart';

/// Validates write intents locally — never queries ERP, repositories, or DAOs.
class LocalAssistantWriteValidator implements AssistantWriteValidator {
  const LocalAssistantWriteValidator({
    AssistantWriteAuthorizer? authorizer,
  }) : _authorizer = authorizer ?? const LocalAssistantWriteAuthorizer();

  final AssistantWriteAuthorizer _authorizer;

  @override
  AssistantWriteValidationResult validate(AssistantWriteRequest request) {
    final errors = <String>[];
    final warnings = <String>[];

    if (request.id.trim().isEmpty) {
      errors.add('id da WriteRequest é obrigatório');
    }
    if (request.requestId.trim().isEmpty) {
      errors.add('requestId da WriteRequest é obrigatório');
    }

    if (request.isReservedOperation) {
      errors.add(
        'Operação ${request.operation.name} é reservada e bloqueada em AI-005',
      );
    }

    if (request.target == AssistantWriteTarget.none) {
      errors.add('target none é inválido para intenção de escrita');
    }

    if (!_isSupportedTarget(request.target)) {
      errors.add(
        'target ${request.target.name} ainda não possui capability mapeada',
      );
    }

    if (!_capabilityMatches(request)) {
      errors.add(
        'capability ${request.capability.name} inconsistente com '
        '${request.operation.name}/${request.target.name}',
      );
    }

    if (_isReservedCapability(request.capability)) {
      errors.add(
        'capability ${request.capability.name} é reservada e bloqueada em AI-005',
      );
    }

    final constraintIds = <String>{};
    for (final constraint in request.constraints) {
      if (constraint.id.trim().isEmpty) {
        errors.add('constraint com id vazio');
      } else if (!constraintIds.add(constraint.id)) {
        errors.add('constraint duplicada: ${constraint.id}');
      }
    }

    final blockedConstraints =
        request.constraints.where((c) => !c.satisfied).toList(growable: false);

    if (request.attributes.isEmpty &&
        request.operation == AssistantWriteOperation.create) {
      warnings.add('create sem attributes — intenção incompleta para pipeline futuro');
    }

    final authorizationStatus = _authorizer.authorize(request);

    switch (authorizationStatus) {
      case AssistantWriteAuthorizationStatus.denied:
        errors.add('autorização negada para a intenção de escrita');
      case AssistantWriteAuthorizationStatus.insufficientPrivileges:
        errors.add('capability ausente nas privileges autorizadas');
      case AssistantWriteAuthorizationStatus.confirmationRequired:
        warnings.add('confirmação do usuário ainda necessária');
      case AssistantWriteAuthorizationStatus.authorized:
        break;
    }

    return AssistantWriteValidationResult.fromParts(
      validationErrors: errors,
      authorizationStatus: authorizationStatus,
      blockedConstraints: blockedConstraints,
      warnings: warnings,
    );
  }

  static bool _isSupportedTarget(AssistantWriteTarget target) {
    return target == AssistantWriteTarget.event ||
        target == AssistantWriteTarget.quote ||
        target == AssistantWriteTarget.client;
  }

  static bool _isReservedCapability(AssistantWriteCapability capability) {
    return capability == AssistantWriteCapability.deleteEvent ||
        capability == AssistantWriteCapability.cancelEvent;
  }

  static bool _capabilityMatches(AssistantWriteRequest request) {
    final expected = _expectedShape(request.capability);
    if (expected == null) return false;
    return expected.operation == request.operation &&
        expected.target == request.target;
  }

  static ({AssistantWriteOperation operation, AssistantWriteTarget target})?
      _expectedShape(AssistantWriteCapability capability) {
    switch (capability) {
      case AssistantWriteCapability.createEvent:
        return (
          operation: AssistantWriteOperation.create,
          target: AssistantWriteTarget.event,
        );
      case AssistantWriteCapability.createQuote:
        return (
          operation: AssistantWriteOperation.create,
          target: AssistantWriteTarget.quote,
        );
      case AssistantWriteCapability.updateEvent:
        return (
          operation: AssistantWriteOperation.update,
          target: AssistantWriteTarget.event,
        );
      case AssistantWriteCapability.updateQuote:
        return (
          operation: AssistantWriteOperation.update,
          target: AssistantWriteTarget.quote,
        );
      case AssistantWriteCapability.createClient:
        return (
          operation: AssistantWriteOperation.create,
          target: AssistantWriteTarget.client,
        );
      case AssistantWriteCapability.deleteEvent:
        return (
          operation: AssistantWriteOperation.delete,
          target: AssistantWriteTarget.event,
        );
      case AssistantWriteCapability.cancelEvent:
        return (
          operation: AssistantWriteOperation.cancel,
          target: AssistantWriteTarget.event,
        );
    }
  }
}
