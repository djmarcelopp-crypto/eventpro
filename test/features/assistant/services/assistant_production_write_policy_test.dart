import 'package:eventpro/features/assistant/domain/policy/assistant_production_write_policy_registry.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_context.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_mode.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_policy.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_token.dart';
import 'package:eventpro/features/assistant/models/assistant_integration_mode.dart';
import 'package:eventpro/features/assistant/models/assistant_write_authorization.dart';
import 'package:eventpro/features/assistant/models/assistant_write_authorization_status.dart';
import 'package:eventpro/features/assistant/models/assistant_write_capability.dart';
import 'package:eventpro/features/assistant/models/assistant_write_entity_state.dart';
import 'package:eventpro/features/assistant/models/assistant_write_failure_code.dart';
import 'package:eventpro/features/assistant/models/assistant_write_idempotency_key.dart';
import 'package:eventpro/features/assistant/models/assistant_write_idempotency_status.dart';
import 'package:eventpro/features/assistant/models/assistant_write_operation.dart';
import 'package:eventpro/features/assistant/models/assistant_write_preparation.dart';
import 'package:eventpro/features/assistant/models/assistant_write_request.dart';
import 'package:eventpro/features/assistant/models/assistant_write_result.dart';
import 'package:eventpro/features/assistant/models/assistant_write_target.dart';
import 'package:eventpro/features/assistant/models/assistant_write_validation_result.dart';
import 'package:eventpro/features/assistant/models/assistant_production_write_policy_context.dart';
import 'package:eventpro/features/assistant/services/policies/blocked_production_write_policies.dart';
import 'package:eventpro/features/assistant/services/policies/quote_draft_production_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-007 CP-C production write policies', () {
    final now = DateTime.utc(2026, 7, 19, 14);

    AssistantExecutionContext ctx({
      AssistantExecutionMode mode = AssistantExecutionMode.production,
    }) {
      return AssistantExecutionContext(
        requestId: 'req-pol',
        token: const AssistantExecutionToken('tok-pol'),
        mode: mode,
        integrationMode: AssistantIntegrationMode.none,
        timestamp: now,
        confirmedStepIds: const {'step'},
        policy: AssistantExecutionPolicy.ai006QuoteDraftProduction,
      );
    }

    AssistantWriteRequest request({
      AssistantWriteOperation operation = AssistantWriteOperation.create,
      AssistantWriteTarget target = AssistantWriteTarget.quote,
      AssistantWriteEntityState state = AssistantWriteEntityState.draft,
      AssistantWriteCapability capability =
          AssistantWriteCapability.createQuote,
      bool granted = true,
      String? key = 'idem-pol',
    }) {
      return AssistantWriteRequest(
        id: 'wr-pol',
        requestId: 'req-pol',
        operation: operation,
        target: target,
        capability: capability,
        relatedStepId: 'step',
        requestedState: state,
        idempotencyKey:
            key == null ? null : AssistantWriteIdempotencyKey(key),
        attributes: const {'clientDisplayName': 'X'},
        authorization: AssistantWriteAuthorization(
          granted: granted,
          allowedCapabilities: {capability},
        ),
      );
    }

    AssistantWritePreparation preparation({
      AssistantWriteAuthorizationStatus auth =
          AssistantWriteAuthorizationStatus.authorized,
      bool valid = true,
    }) {
      final req = request();
      return AssistantWritePreparation(
        writeResult: AssistantWriteResult(
          id: 'wres',
          requestId: req.requestId,
          operation: req.operation,
          target: req.target,
          capability: req.capability,
          accepted: valid,
          executed: false,
          mutatedErp: false,
          summary: 'prep',
          idempotencyStatus: AssistantWriteIdempotencyStatus.notApplicable,
        ),
        writeValidation: AssistantWriteValidationResult.fromParts(
          validationErrors: valid ? const [] : const ['invalid'],
          authorizationStatus: auth,
          blockedConstraints: const [],
          warnings: const [],
        ),
        writeAuthorization: auth,
        context: ctx(),
      );
    }

    AssistantProductionWritePolicyContext policyCtx({
      AssistantWriteRequest? req,
      AssistantWritePreparation? prep,
      bool confirmationSatisfied = true,
      bool adapterAvailable = true,
      String adapterName = 'QuoteAssistantWriteAdapter',
      AssistantExecutionMode mode = AssistantExecutionMode.production,
    }) {
      return AssistantProductionWritePolicyContext(
        request: req ?? request(),
        executionContext: ctx(mode: mode),
        preparation: prep ?? preparation(),
        confirmationSatisfied: confirmationSatisfied,
        adapterAvailable: adapterAvailable,
        adapterName: adapterName,
      );
    }

    test('Quote Draft permitido', () {
      final registry = AssistantProductionWritePolicyRegistry(const [
        QuoteDraftProductionPolicy(),
        EventProductionPolicy(),
        CustomerProductionPolicy(),
      ]);
      final decision = registry.resolve(policyCtx());
      expect(decision.allowed, isTrue);
      expect(decision.policyName, 'QuoteDraftProductionPolicy');
    });

    test('create event / customer / update / delete / cancel bloqueados', () {
      final registry = AssistantProductionWritePolicyRegistry(const [
        QuoteDraftProductionPolicy(),
        EventProductionPolicy(),
        CustomerProductionPolicy(),
      ]);

      final cases = [
        request(
          target: AssistantWriteTarget.event,
          capability: AssistantWriteCapability.createEvent,
        ),
        request(
          target: AssistantWriteTarget.client,
          capability: AssistantWriteCapability.createClient,
        ),
        request(
          operation: AssistantWriteOperation.update,
          capability: AssistantWriteCapability.updateQuote,
        ),
        request(operation: AssistantWriteOperation.delete),
        request(operation: AssistantWriteOperation.cancel),
        request(state: AssistantWriteEntityState.sent),
      ];

      for (final req in cases) {
        final decision = registry.resolve(policyCtx(req: req));
        expect(decision.allowed, isFalse, reason: req.operation.name);
        expect(
          decision.failure?.code,
          AssistantWriteFailureCode.productionNotAllowed,
        );
      }
    });

    test('policy ausente bloqueia', () {
      final registry = AssistantProductionWritePolicyRegistry(const []);
      final decision = registry.resolve(policyCtx());
      expect(decision.allowed, isFalse);
      expect(
        decision.failure?.code,
        AssistantWriteFailureCode.productionNotAllowed,
      );
    });

    test('policy duplicada falha de forma estruturada', () {
      expect(
        () => AssistantProductionWritePolicyRegistry(const [
          QuoteDraftProductionPolicy(),
          QuoteDraftProductionPolicy(),
        ]),
        throwsA(isA<StateError>()),
      );
    });

    test('dryRun/simulation não são convertidos em production', () {
      final policy = const QuoteDraftProductionPolicy();
      for (final mode in [
        AssistantExecutionMode.dryRun,
        AssistantExecutionMode.simulation,
      ]) {
        final decision = policy.evaluate(policyCtx(mode: mode));
        expect(decision.allowed, isFalse);
        expect(
          decision.failure?.code,
          AssistantWriteFailureCode.productionNotAllowed,
        );
      }
    });

    test('gates anteriores continuam obrigatórios', () {
      final policy = const QuoteDraftProductionPolicy();
      expect(
        policy
            .evaluate(policyCtx(confirmationSatisfied: false))
            .failure
            ?.code,
        AssistantWriteFailureCode.confirmationRequired,
      );
      expect(
        policy
            .evaluate(
              policyCtx(
                prep: preparation(
                  auth: AssistantWriteAuthorizationStatus.denied,
                ),
              ),
            )
            .failure
            ?.code,
        AssistantWriteFailureCode.authorizationDenied,
      );
      expect(
        policy.evaluate(policyCtx(adapterAvailable: false)).failure?.code,
        AssistantWriteFailureCode.adapterUnavailable,
      );
      expect(
        policy
            .evaluate(policyCtx(req: request(key: null)))
            .failure
            ?.code,
        AssistantWriteFailureCode.missingIdempotencyKey,
      );
    });

    test('placeholders inativos não resolvem', () {
      final registry = AssistantProductionWritePolicyRegistry(const [
        EventProductionPolicy(),
        CustomerProductionPolicy(),
      ]);
      expect(registry.activePolicies, isEmpty);
      expect(registry.resolve(policyCtx()).allowed, isFalse);
    });
  });
}
