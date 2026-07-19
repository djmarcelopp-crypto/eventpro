import 'package:eventpro/features/assistant/models/assistant_write_authorization.dart';
import 'package:eventpro/features/assistant/models/assistant_write_authorization_status.dart';
import 'package:eventpro/features/assistant/models/assistant_write_capability.dart';
import 'package:eventpro/features/assistant/models/assistant_write_constraint.dart';
import 'package:eventpro/features/assistant/models/assistant_write_operation.dart';
import 'package:eventpro/features/assistant/models/assistant_write_request.dart';
import 'package:eventpro/features/assistant/models/assistant_write_result.dart';
import 'package:eventpro/features/assistant/models/assistant_write_target.dart';
import 'package:eventpro/features/assistant/services/local_assistant_write_authorizer.dart';
import 'package:eventpro/features/assistant/services/local_assistant_write_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-005 write validation & authorization', () {
    const authorizer = LocalAssistantWriteAuthorizer();
    const validator = LocalAssistantWriteValidator(authorizer: authorizer);

    AssistantWriteRequest baseRequest({
      AssistantWriteOperation operation = AssistantWriteOperation.create,
      AssistantWriteTarget target = AssistantWriteTarget.event,
      AssistantWriteCapability capability = AssistantWriteCapability.createEvent,
      List<AssistantWriteConstraint> constraints = const [],
      AssistantWriteAuthorization? authorization = const AssistantWriteAuthorization(
        granted: true,
        requiresUserConfirmation: false,
        allowedCapabilities: {AssistantWriteCapability.createEvent},
      ),
      Map<String, String> attributes = const {'eventType': 'casamento'},
      String id = 'wr-1',
      String requestId = 'req-1',
    }) {
      return AssistantWriteRequest(
        id: id,
        requestId: requestId,
        operation: operation,
        target: target,
        capability: capability,
        constraints: constraints,
        authorization: authorization,
        attributes: attributes,
      );
    }

    test('request válido', () {
      final result = validator.validate(baseRequest());

      expect(result.valid, isTrue);
      expect(result.validationErrors, isEmpty);
      expect(result.blockedConstraints, isEmpty);
      expect(
        result.authorizationStatus,
        AssistantWriteAuthorizationStatus.authorized,
      );
    });

    test('operação reservada', () {
      final result = validator.validate(
        baseRequest(
          operation: AssistantWriteOperation.delete,
          capability: AssistantWriteCapability.deleteEvent,
          authorization: const AssistantWriteAuthorization(
            granted: true,
            requiresUserConfirmation: false,
            allowedCapabilities: {AssistantWriteCapability.deleteEvent},
          ),
        ),
      );

      expect(result.valid, isFalse);
      expect(
        result.authorizationStatus,
        AssistantWriteAuthorizationStatus.denied,
      );
      expect(
        result.validationErrors.join(' '),
        contains('reservada'),
      );
    });

    test('capability ausente', () {
      final result = validator.validate(
        baseRequest(
          authorization: const AssistantWriteAuthorization(
            granted: true,
            requiresUserConfirmation: false,
            allowedCapabilities: {},
          ),
        ),
      );

      expect(result.valid, isFalse);
      expect(
        result.authorizationStatus,
        AssistantWriteAuthorizationStatus.insufficientPrivileges,
      );
      expect(
        result.validationErrors.join(' '),
        contains('capability ausente'),
      );
    });

    test('authorization negada', () {
      final result = validator.validate(
        baseRequest(
          authorization: const AssistantWriteAuthorization(
            granted: false,
            reason: 'Usuário sem permissão',
            allowedCapabilities: {AssistantWriteCapability.createEvent},
          ),
        ),
      );

      expect(result.valid, isFalse);
      expect(
        result.authorizationStatus,
        AssistantWriteAuthorizationStatus.denied,
      );
      expect(
        authorizer.authorize(
          baseRequest(authorization: null),
        ),
        AssistantWriteAuthorizationStatus.denied,
      );
    });

    test('constraint bloqueando', () {
      final result = validator.validate(
        baseRequest(
          constraints: const [
            AssistantWriteConstraint(
              id: 'c-date',
              description: 'Data informada',
              satisfied: false,
            ),
          ],
        ),
      );

      expect(result.valid, isFalse);
      expect(result.blockedConstraints, hasLength(1));
      expect(result.blockedConstraints.first.id, 'c-date');
      expect(
        result.authorizationStatus,
        AssistantWriteAuthorizationStatus.authorized,
      );
    });

    test('request inconsistente', () {
      final result = validator.validate(
        baseRequest(
          operation: AssistantWriteOperation.update,
          target: AssistantWriteTarget.quote,
          capability: AssistantWriteCapability.createEvent,
          authorization: const AssistantWriteAuthorization(
            granted: true,
            requiresUserConfirmation: false,
            allowedCapabilities: {AssistantWriteCapability.createEvent},
          ),
        ),
      );

      expect(result.valid, isFalse);
      expect(
        result.validationErrors.join(' '),
        contains('inconsistente'),
      );
    });

    test('executed continua false', () {
      final validation = validator.validate(baseRequest());
      final writeResult = AssistantWriteResult(
        id: 'wres-1',
        requestId: 'req-1',
        operation: AssistantWriteOperation.create,
        target: AssistantWriteTarget.event,
        capability: AssistantWriteCapability.createEvent,
        accepted: validation.valid,
        summary: 'Validação local sem escrita',
      );

      expect(validation.valid, isTrue);
      expect(writeResult.executed, isFalse);
      expect(
        writeResult.copyWith(accepted: false).executed,
        isFalse,
      );
    });

    test('confirmationRequired não executa e permanece válido estruturalmente', () {
      final result = validator.validate(
        baseRequest(
          authorization: const AssistantWriteAuthorization(
            granted: true,
            requiresUserConfirmation: true,
            allowedCapabilities: {AssistantWriteCapability.createEvent},
          ),
        ),
      );

      expect(result.valid, isTrue);
      expect(
        result.authorizationStatus,
        AssistantWriteAuthorizationStatus.confirmationRequired,
      );
      expect(result.warnings.join(' '), contains('confirmação'));
    });
  });
}
