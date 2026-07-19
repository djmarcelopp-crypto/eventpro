import 'package:eventpro/features/assistant/models/assistant_write_authorization.dart';
import 'package:eventpro/features/assistant/models/assistant_write_capability.dart';
import 'package:eventpro/features/assistant/models/assistant_write_constraint.dart';
import 'package:eventpro/features/assistant/models/assistant_write_operation.dart';
import 'package:eventpro/features/assistant/models/assistant_write_request.dart';
import 'package:eventpro/features/assistant/models/assistant_write_result.dart';
import 'package:eventpro/features/assistant/models/assistant_write_target.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-005 safe write domain', () {
    test('operations and capabilities expose reserved delete/cancel', () {
      expect(
        AssistantWriteOperation.values,
        containsAll([
          AssistantWriteOperation.create,
          AssistantWriteOperation.update,
          AssistantWriteOperation.delete,
          AssistantWriteOperation.cancel,
        ]),
      );
      expect(
        AssistantWriteCapability.values,
        containsAll([
          AssistantWriteCapability.createEvent,
          AssistantWriteCapability.createQuote,
          AssistantWriteCapability.updateEvent,
          AssistantWriteCapability.deleteEvent,
          AssistantWriteCapability.cancelEvent,
        ]),
      );
      expect(AssistantWriteTarget.values, contains(AssistantWriteTarget.event));
    });

    test('write request is immutable and tracks constraints', () {
      const request = AssistantWriteRequest(
        id: 'wr-1',
        requestId: 'req-1',
        operation: AssistantWriteOperation.create,
        target: AssistantWriteTarget.event,
        capability: AssistantWriteCapability.createEvent,
        relatedStepId: 'step-create-event',
        constraints: [
          AssistantWriteConstraint(
            id: 'c-date',
            description: 'Data informada',
            satisfied: false,
          ),
        ],
        attributes: {'eventType': 'casamento'},
        authorization: AssistantWriteAuthorization(
          granted: false,
          reason: 'Pré-condições ausentes',
          allowedCapabilities: {},
        ),
      );

      expect(request.allConstraintsSatisfied, isFalse);
      expect(request.isReservedOperation, isFalse);
      expect(
        request.copyWith(
          constraints: const [
            AssistantWriteConstraint(
              id: 'c-date',
              description: 'Data informada',
              satisfied: true,
            ),
          ],
        ).allConstraintsSatisfied,
        isTrue,
      );
      expect(
        const AssistantWriteRequest(
          id: 'wr-del',
          requestId: 'req-1',
          operation: AssistantWriteOperation.delete,
          target: AssistantWriteTarget.event,
          capability: AssistantWriteCapability.deleteEvent,
        ).isReservedOperation,
        isTrue,
      );
    });

    test('write result never claims ERP execution by default', () {
      const result = AssistantWriteResult(
        id: 'wres-1',
        requestId: 'req-1',
        operation: AssistantWriteOperation.create,
        target: AssistantWriteTarget.quote,
        capability: AssistantWriteCapability.createQuote,
        accepted: true,
        summary: 'Intenção de escrita aceita para pipeline futuro',
      );

      expect(result.executed, isFalse);
      expect(result.accepted, isTrue);
      expect(result.rejectionReason, isNull);
      expect(
        const AssistantWriteAuthorization(
          granted: true,
          requiresUserConfirmation: true,
          allowedCapabilities: {AssistantWriteCapability.createEvent},
        ).granted,
        isTrue,
      );
    });
  });
}
