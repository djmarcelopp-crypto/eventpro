import 'package:eventpro/features/assistant/domain/observability/assistant_write_observer.dart';
import 'package:eventpro/features/assistant/models/assistant_confirmation_status.dart';
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
import 'package:eventpro/features/assistant/models/assistant_write_metric.dart';
import 'package:eventpro/features/assistant/models/assistant_write_observation.dart';
import 'package:eventpro/features/assistant/models/assistant_write_operation.dart';
import 'package:eventpro/features/assistant/models/assistant_write_outcome_category.dart';
import 'package:eventpro/features/assistant/models/assistant_write_request.dart';
import 'package:eventpro/features/assistant/models/assistant_write_target.dart';
import 'package:eventpro/features/assistant/models/assistant_write_timer.dart';
import 'package:eventpro/features/assistant/services/local_assistant_write_coordinator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_write_gateway.dart';
import 'package:eventpro/features/quotes/assistant/quote_assistant_write_adapter.dart';
import 'package:eventpro/features/quotes/utils/quote_draft_creation_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../quotes/fakes/fake_quote_repository.dart';

class _ThrowingObserver implements AssistantWriteObserver {
  @override
  void onObservation(AssistantWriteObservation observation) {
    throw StateError('observer boom');
  }
}

AssistantWriteObservation _obs({
  required AssistantWriteOutcomeCategory outcome,
  bool timeout = false,
  bool rollbackAttempted = false,
  bool rollbackSucceeded = false,
  int durationMs = 10,
  AssistantWriteFailureCode? failureCode,
}) {
  final started = DateTime.utc(2026, 7, 19, 12);
  return AssistantWriteObservation(
    operation: AssistantWriteOperation.create,
    target: AssistantWriteTarget.quote,
    executionMode: AssistantExecutionMode.production,
    policyName: 'QuoteDraftProductionPolicy',
    adapterName: 'QuoteAssistantWriteAdapter',
    idempotencyStatus: AssistantWriteIdempotencyStatus.firstExecution,
    startedAt: started,
    finishedAt: started.add(Duration(milliseconds: durationMs)),
    durationMs: durationMs,
    confirmationStatus: AssistantConfirmationStatus.providedValid,
    authorizationStatus: AssistantWriteAuthorizationStatus.authorized,
    outcome: outcome,
    executed: outcome == AssistantWriteOutcomeCategory.success,
    mutatedErp: outcome == AssistantWriteOutcomeCategory.success,
    timeout: timeout,
    rollbackAttempted: rollbackAttempted,
    rollbackSucceeded: rollbackSucceeded,
    warningCount: 0,
    failureCode: failureCode,
  );
}

void main() {
  group('AI-007 CP-B write observability', () {
    var tick = DateTime.utc(2026, 7, 19, 12);
    DateTime clock() {
      final current = tick;
      tick = tick.add(const Duration(milliseconds: 25));
      return current;
    }

    late FakeQuoteRepository repository;
    late LocalAssistantWriteGateway gateway;
    late InMemoryAssistantWriteObserver collector;

    setUp(() {
      tick = DateTime.utc(2026, 7, 19, 12);
      repository = FakeQuoteRepository();
      gateway = LocalAssistantWriteGateway(
        quoteDraftAdapter: QuoteAssistantWriteAdapter(
          QuoteDraftCreationService(repository, clock: clock),
        ),
      );
      collector = InMemoryAssistantWriteObserver();
    });

    AssistantExecutionContext ctx(AssistantExecutionMode mode) {
      return AssistantExecutionContext(
        requestId: 'req-obs',
        token: const AssistantExecutionToken('tok-obs'),
        mode: mode,
        integrationMode: AssistantIntegrationMode.none,
        timestamp: tick,
        confirmedStepIds: const {'step-create-quote'},
        policy: mode == AssistantExecutionMode.production
            ? AssistantExecutionPolicy.ai006QuoteDraftProduction
            : AssistantExecutionPolicy.ai004Defaults,
      );
    }

    AssistantWriteRequest request({String key = 'idem-obs'}) {
      return AssistantWriteRequest(
        id: 'wr-obs',
        requestId: 'req-obs',
        operation: AssistantWriteOperation.create,
        target: AssistantWriteTarget.quote,
        capability: AssistantWriteCapability.createQuote,
        relatedStepId: 'step-create-quote',
        requestedState: AssistantWriteEntityState.draft,
        idempotencyKey: AssistantWriteIdempotencyKey(key),
        attributes: const {
          'clientDisplayName': 'Obs',
          'lineItemName': 'Som',
          'lineItemUnitPriceCents': '1000',
        },
        authorization: const AssistantWriteAuthorization(
          granted: true,
          allowedCapabilities: {AssistantWriteCapability.createQuote},
        ),
      );
    }

    test('métrica de sucesso / dryRun / simulation / bloqueio', () async {
      final coordinator = LocalAssistantWriteCoordinator(
        observer: collector,
        clock: clock,
      );

      await coordinator.prepareAndMaybeExecute(
        request: request(key: 'idem-success'),
        context: ctx(AssistantExecutionMode.production),
        confirmationSatisfied: true,
        writeGateway: gateway,
      );
      expect(
        collector.observations.last.outcome,
        AssistantWriteOutcomeCategory.success,
      );
      expect(collector.observations.last.executed, isTrue);

      await coordinator.prepareAndMaybeExecute(
        request: request(key: 'idem-dry'),
        context: ctx(AssistantExecutionMode.dryRun),
        confirmationSatisfied: true,
        writeGateway: gateway,
      );
      expect(
        collector.observations.last.outcome,
        AssistantWriteOutcomeCategory.dryRun,
      );
      expect(collector.observations.last.executed, isFalse);

      await coordinator.prepareAndMaybeExecute(
        request: request(key: 'idem-sim'),
        context: ctx(AssistantExecutionMode.simulation),
        confirmationSatisfied: true,
        writeGateway: gateway,
      );
      expect(
        collector.observations.last.outcome,
        AssistantWriteOutcomeCategory.simulation,
      );

      await coordinator.prepareAndMaybeExecute(
        request: request(key: 'idem-block'),
        context: ctx(AssistantExecutionMode.production),
        confirmationSatisfied: false,
        writeGateway: gateway,
      );
      expect(
        collector.observations.last.outcome,
        AssistantWriteOutcomeCategory.blocked,
      );
    });

    test('métrica de timeout e rollback', () {
      final timeout = _obs(
        outcome: AssistantWriteOutcomeCategory.timeout,
        timeout: true,
        failureCode: AssistantWriteFailureCode.timeout,
      );
      final rollback = _obs(
        outcome: AssistantWriteOutcomeCategory.rollback,
        rollbackAttempted: true,
        rollbackSucceeded: true,
        failureCode: AssistantWriteFailureCode.rollbackFailure,
      );
      expect(timeout.timeout, isTrue);
      expect(timeout.toMetricMap()['timeout'], isTrue);
      expect(rollback.rollbackAttempted, isTrue);
      expect(rollback.rollbackSucceeded, isTrue);
      expect(
        AssistantWriteMetric.fromObservation(timeout).outcome,
        AssistantWriteOutcomeCategory.timeout,
      );
    });

    test('falha do observer não quebra execução', () async {
      final coordinator = LocalAssistantWriteCoordinator(
        observer: _ThrowingObserver(),
        clock: clock,
      );
      final result = await coordinator.prepareAndMaybeExecute(
        request: request(key: 'idem-safe-obs'),
        context: ctx(AssistantExecutionMode.production),
        confirmationSatisfied: true,
        writeGateway: gateway,
      );
      expect(result.writeResult.executed, isTrue);
      expect(await repository.listAll(), hasLength(1));
    });

    test('duração determinística e nunca negativa', () {
      final times = [
        DateTime.utc(2026, 7, 19, 12, 0, 0),
        DateTime.utc(2026, 7, 19, 12, 0, 0, 40),
      ];
      var i = 0;
      final timer = AssistantWriteTimer(clock: () => times[i++], startedAt: times[0]);
      expect(timer.elapsedMs(finishedAt: times[1]), 40);
      expect(
        AssistantWriteTimer(
          clock: () => times[0],
          startedAt: times[1],
        ).elapsedMs(finishedAt: times[0]),
        0,
      );
    });

    test('payload sensível e chave bruta não são registrados', () async {
      final coordinator = LocalAssistantWriteCoordinator(
        observer: collector,
        clock: clock,
      );
      const rawKey = 'secret-idem-key-xyz';
      await coordinator.prepareAndMaybeExecute(
        request: request(key: rawKey),
        context: ctx(AssistantExecutionMode.production),
        confirmationSatisfied: true,
        writeGateway: gateway,
      );
      final map = collector.observations.single.toMetricMap().toString();
      expect(map, isNot(contains(rawKey)));
      expect(map, isNot(contains('clientDisplayName')));
      expect(map, isNot(contains('lineItemUnitPriceCents')));
    });
  });
}
