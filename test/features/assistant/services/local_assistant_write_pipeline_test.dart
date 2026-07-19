import 'package:eventpro/features/assistant/models/assistant_confirmation_policy.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_context.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_mode.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_plan.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_requirement.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_status.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_step.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_token.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_integration_mode.dart';
import 'package:eventpro/features/assistant/models/assistant_intent_type.dart';
import 'package:eventpro/features/assistant/models/assistant_module_target.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/models/assistant_write_authorization.dart';
import 'package:eventpro/features/assistant/models/assistant_write_authorization_status.dart';
import 'package:eventpro/features/assistant/models/assistant_write_capability.dart';
import 'package:eventpro/features/assistant/models/assistant_write_constraint.dart';
import 'package:eventpro/features/assistant/models/assistant_write_operation.dart';
import 'package:eventpro/features/assistant/models/assistant_write_request.dart';
import 'package:eventpro/features/assistant/models/assistant_write_target.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_write_coordinator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_write_intent_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-005 write pipeline CP-C/CP-D', () {
    final now = DateTime(2026, 7, 19, 12);
    final coordinator = LocalAssistantWriteCoordinator();
    const factory = LocalAssistantWriteIntentFactory();

    AssistantExecutionContext context({
      String requestId = 'req-1',
      AssistantExecutionMode mode = AssistantExecutionMode.dryRun,
      Set<String> confirmed = const {},
    }) {
      return AssistantExecutionContext(
        requestId: requestId,
        token: const AssistantExecutionToken('tok-1'),
        mode: mode,
        integrationMode: AssistantIntegrationMode.none,
        timestamp: now,
        confirmedStepIds: confirmed,
      );
    }

    AssistantWriteRequest validRequest({
      bool confirmation = false,
      List<AssistantWriteConstraint> constraints = const [],
    }) {
      return AssistantWriteRequest(
        id: 'wr-1',
        requestId: 'req-1',
        operation: AssistantWriteOperation.create,
        target: AssistantWriteTarget.event,
        capability: AssistantWriteCapability.createEvent,
        relatedStepId: 'step-create-event',
        constraints: constraints,
        attributes: const {'eventType': 'casamento'},
        authorization: AssistantWriteAuthorization(
          granted: true,
          requiresUserConfirmation: confirmation,
          allowedCapabilities: const {AssistantWriteCapability.createEvent},
        ),
      );
    }

    test('fluxo válido de validação + autorização via coordinator', () async {
      final prep = coordinator.prepare(
        request: validRequest(),
        context: context(),
      );

      expect(prep.writeValidation.valid, isTrue);
      expect(
        prep.writeAuthorization,
        AssistantWriteAuthorizationStatus.authorized,
      );
      expect(prep.writeResult.accepted, isTrue);
      expect(prep.writeResult.executed, isFalse);
      expect(prep.context.requestId, 'req-1');
    });

    test('confirmação requerida integra ExecutionContext sem executar', () async {
      final prep = coordinator.prepare(
        request: validRequest(confirmation: true),
        context: context(confirmed: {'step-create-event'}),
      );

      expect(
        prep.writeAuthorization,
        AssistantWriteAuthorizationStatus.confirmationRequired,
      );
      expect(prep.writeResult.accepted, isTrue);
      expect(prep.writeResult.executed, isFalse);
    });

    test('bloqueios por constraint mantêm executed false', () async {
      final prep = coordinator.prepare(
        request: validRequest(
          constraints: const [
            AssistantWriteConstraint(
              id: 'c-date',
              description: 'Data informada',
              satisfied: false,
            ),
          ],
        ),
        context: context(),
      );

      expect(prep.writeValidation.valid, isFalse);
      expect(prep.writeResult.accepted, isFalse);
      expect(prep.writeResult.executed, isFalse);
      expect(prep.writeResult.rejectionReason, contains('Constraints'));
    });

    test('production no ExecutionContext bloqueia preparação', () async {
      final prep = coordinator.prepare(
        request: validRequest(),
        context: context(mode: AssistantExecutionMode.production),
      );

      expect(prep.writeResult.accepted, isFalse);
      expect(prep.writeResult.executed, isFalse);
      expect(prep.writeResult.executed, isFalse);
      expect(
        prep.writeWarnings.join(' '),
        anyOf(contains('production'), contains('prepare() isolado')),
      );
    });

    test('resultado preparado é determinístico', () async {
      final a = coordinator.prepare(
        request: validRequest(confirmation: true),
        context: context(),
      );
      final b = coordinator.prepare(
        request: validRequest(confirmation: true),
        context: context(),
      );

      expect(a, b);
      expect(a.writeResult.executed, isFalse);
      expect(b.writeResult.executed, isFalse);
    });

    test('factory + orchestrator anexam write fields sem mutar ERP', () async {
      final orchestrator = LocalAssistantOrchestrator(clock: () => now);
      final response = await orchestrator.handle(
        AssistantRequest(
          id: 'req-write',
          rawText:
              'Preciso de som para um casamento de 300 pessoas em Uberlândia.',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
        ),
      );

      expect(response.primaryIntent.type, AssistantIntentType.createQuote);
      expect(response.writeResult, isNotNull);
      expect(response.writeValidation, isNotNull);
      expect(response.writeAuthorization, isNotNull);
      expect(response.writeResult!.executed, isFalse);
      expect(response.writeResult!.capability, AssistantWriteCapability.createQuote);
      expect(
        response.writeAuthorization,
        AssistantWriteAuthorizationStatus.confirmationRequired,
      );
      expect(
        response.friendlyMessage,
        contains('A operação foi apenas preparada'),
      );
      expect(
        response.friendlyMessage,
        contains('Nenhuma alteração foi realizada no EventPRO'),
      );

      final intent = factory.fromPipeline(
        response: response,
        plan: response.executionPlan!,
      );
      expect(intent, isNotNull);
      expect(intent!.operation, AssistantWriteOperation.create);
      expect(intent.target, AssistantWriteTarget.quote);
    });

    test('intenções de leitura não geram writeResult', () async {
      final orchestrator = LocalAssistantOrchestrator(clock: () => now);
      final response = await orchestrator.handle(
        AssistantRequest(
          id: 'req-read',
          rawText: 'Tem equipamento disponível dia 18/09/2026?',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
        ),
      );

      expect(response.primaryIntent.type, AssistantIntentType.checkAvailability);
      expect(response.writeResult, isNull);
      expect(response.writeValidation, isNull);
      expect(response.writeAuthorization, isNull);
      expect(response.writeWarnings, isEmpty);
    });

    test('factory mapeia preconditions do ExecutionPlan', () async {
      final orchestrator = LocalAssistantOrchestrator(clock: () => now);
      final base = await orchestrator.handle(
        AssistantRequest(
          id: 'req-map',
          rawText: 'Criar evento casamento em Uberlândia',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
        ),
      );

      final plan = AssistantExecutionPlan(
        id: 'plan-map',
        requestId: 'req-map',
        overallStatus: AssistantExecutionStatus.blocked,
        steps: const [
          AssistantExecutionStep(
            id: 'step-create-event',
            order: 1,
            moduleTarget: AssistantModuleTarget.events,
            intendedAction: 'createEvent',
            description: 'Criar Evento',
            status: AssistantExecutionStatus.blocked,
            confirmationPolicy: AssistantConfirmationPolicy.requiredBeforeWrite,
            blockReason: 'Data ausente',
            preconditions: [
              AssistantExecutionRequirement(
                id: 'req-date',
                description: 'Data informada',
                satisfied: false,
              ),
            ],
          ),
        ],
      );

      final writeRequest = factory.fromPipeline(response: base, plan: plan);
      expect(writeRequest, isNotNull);
      expect(writeRequest!.relatedStepId, 'step-create-event');
      expect(
        writeRequest.constraints.any((c) => c.id == 'req-date' && !c.satisfied),
        isTrue,
      );

      final prep = coordinator.prepare(
        request: writeRequest,
        context: context(requestId: 'req-map'),
      );
      expect(prep.writeResult.executed, isFalse);
      expect(prep.writeValidation.blockedConstraints, isNotEmpty);
    });
  });
}
