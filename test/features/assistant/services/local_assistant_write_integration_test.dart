import 'package:eventpro/features/assistant/models/assistant_execution_context.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_mode.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_policy.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_token.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_integration_mode.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/models/assistant_write_authorization.dart';
import 'package:eventpro/features/assistant/models/assistant_write_capability.dart';
import 'package:eventpro/features/assistant/models/assistant_write_entity_state.dart';
import 'package:eventpro/features/assistant/models/assistant_write_failure_code.dart';
import 'package:eventpro/features/assistant/models/assistant_write_idempotency_key.dart';
import 'package:eventpro/features/assistant/models/assistant_write_operation.dart';
import 'package:eventpro/features/assistant/models/assistant_write_request.dart';
import 'package:eventpro/features/assistant/models/assistant_write_target.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_write_coordinator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_write_gateway.dart';
import 'package:eventpro/features/quotes/assistant/quote_assistant_write_adapter.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/utils/quote_draft_creation_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../quotes/fakes/fake_quote_repository.dart';

void main() {
  group('AI-006 controlled quote draft write', () {
    final now = DateTime(2026, 7, 19, 15);
    late FakeQuoteRepository repository;
    late LocalAssistantWriteGateway gateway;
    late LocalAssistantWriteCoordinator coordinator;

    setUp(() {
      repository = FakeQuoteRepository();
      final service = QuoteDraftCreationService(repository, clock: () => now);
      gateway = LocalAssistantWriteGateway(
        quoteDraftAdapter: QuoteAssistantWriteAdapter(service),
      );
      coordinator = LocalAssistantWriteCoordinator();
    });

    AssistantExecutionContext ctx() {
      return AssistantExecutionContext(
        requestId: 'req-int',
        token: const AssistantExecutionToken('tok-int'),
        mode: AssistantExecutionMode.production,
        integrationMode: AssistantIntegrationMode.none,
        timestamp: now,
        confirmedStepIds: const {'step-create-quote'},
        policy: AssistantExecutionPolicy.ai006QuoteDraftProduction,
      );
    }

    AssistantWriteRequest quoteRequest({
      String key = 'idem-int-1',
      bool requireConfirmation = false,
      AssistantWriteTarget target = AssistantWriteTarget.quote,
      AssistantWriteOperation operation = AssistantWriteOperation.create,
      bool granted = true,
    }) {
      return AssistantWriteRequest(
        id: 'wr-int',
        requestId: 'req-int',
        operation: operation,
        target: target,
        capability: AssistantWriteCapability.createQuote,
        relatedStepId: 'step-create-quote',
        requestedState: AssistantWriteEntityState.draft,
        idempotencyKey: AssistantWriteIdempotencyKey(key),
        attributes: const {
          'clientDisplayName': 'Cliente AI',
          'lineItemName': 'Iluminação',
          'lineItemUnitPriceCents': '20000',
        },
        authorization: AssistantWriteAuthorization(
          granted: granted,
          requiresUserConfirmation: requireConfirmation,
          allowedCapabilities: const {AssistantWriteCapability.createQuote},
        ),
      );
    }

    test('dryRun e simulation não escrevem', () async {
      for (final mode in [
        AssistantExecutionMode.dryRun,
        AssistantExecutionMode.simulation,
      ]) {
        final orch = LocalAssistantOrchestrator(
          clock: () => now,
          executionMode: mode,
          writeGateway: gateway,
          capabilities: const AssistantCapabilities(canExecuteCreateQuote: true),
        );
        final response = await orch.handle(
          AssistantRequest(
            id: 'req-$mode',
            rawText: 'Orçamento de som para festa',
            locale: 'pt_BR',
            timezone: 'America/Sao_Paulo',
            timestamp: now,
            origin: AssistantInputOrigin.typedText,
          ),
        );
        expect(response.writeResult?.executed ?? false, isFalse);
        expect(response.executionReport?.mutatedErp, isFalse);
        expect(
          response.friendlyMessage,
          contains('Nenhuma alteração foi realizada no EventPRO'),
        );
      }
      expect(await repository.listAll(), isEmpty);
    });

    test('production sem confirmação / sem auth / target inválido não escreve',
        () async {
      final noConfirm = await coordinator.prepareAndMaybeExecute(
        request: quoteRequest(requireConfirmation: true),
        context: ctx(),
        confirmationSatisfied: false,
        writeGateway: gateway,
      );
      expect(noConfirm.writeResult.executed, isFalse);
      expect(
        noConfirm.writeResult.failure?.code,
        AssistantWriteFailureCode.confirmationRequired,
      );

      final denied = await coordinator.prepareAndMaybeExecute(
        request: quoteRequest(granted: false),
        context: ctx(),
        confirmationSatisfied: true,
        writeGateway: gateway,
      );
      expect(denied.writeResult.executed, isFalse);
      expect(
        denied.writeResult.failure?.code,
        AssistantWriteFailureCode.authorizationDenied,
      );

      final badTarget = await coordinator.prepareAndMaybeExecute(
        request: quoteRequest(target: AssistantWriteTarget.event),
        context: ctx(),
        confirmationSatisfied: true,
        writeGateway: gateway,
      );
      expect(badTarget.writeResult.executed, isFalse);
      expect(
        badTarget.writeResult.failure?.code,
        AssistantWriteFailureCode.unsupportedOperation,
      );

      expect(await repository.listAll(), isEmpty);
    });

    test('production válida cria um único Draft e é idempotente', () async {
      final first = await coordinator.prepareAndMaybeExecute(
        request: quoteRequest(key: 'idem-ok'),
        context: ctx(),
        confirmationSatisfied: true,
        writeGateway: gateway,
      );
      expect(first.writeResult.executed, isTrue);
      expect(first.writeResult.mutatedErp, isTrue);
      expect(first.writeResult.resultingState, AssistantWriteEntityState.draft);
      expect(first.writeResult.draftId, isNotNull);
      expect(first.writeResult.summary, contains('Draft'));

      final second = await coordinator.prepareAndMaybeExecute(
        request: quoteRequest(key: 'idem-ok'),
        context: ctx(),
        confirmationSatisfied: true,
        writeGateway: gateway,
      );
      expect(second.writeResult.executed, isTrue);
      expect(second.writeResult.mutatedErp, isFalse);
      expect(second.writeResult.draftId, first.writeResult.draftId);

      final quotes = await repository.listAll();
      expect(quotes, hasLength(1));
      expect(quotes.single.status, QuoteStatus.draft);
    });

    test('adapter indisponível e update/delete/cancel bloqueados', () async {
      final unavailable = await coordinator.prepareAndMaybeExecute(
        request: quoteRequest(),
        context: ctx(),
        confirmationSatisfied: true,
        writeGateway: null,
      );
      expect(
        unavailable.writeResult.failure?.code,
        AssistantWriteFailureCode.adapterUnavailable,
      );

      for (final op in [
        AssistantWriteOperation.update,
        AssistantWriteOperation.delete,
        AssistantWriteOperation.cancel,
      ]) {
        final blocked = await coordinator.prepareAndMaybeExecute(
          request: quoteRequest(operation: op),
          context: ctx(),
          confirmationSatisfied: true,
          writeGateway: gateway,
        );
        expect(blocked.writeResult.executed, isFalse);
      }
      expect(await repository.listAll(), isEmpty);
    });
  });
}
