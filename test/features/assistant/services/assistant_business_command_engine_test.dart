import 'package:eventpro/features/assistant/domain/business/assistant_business_operation.dart';
import 'package:eventpro/features/assistant/domain/business/capabilities/assistant_business_capability_id.dart';
import 'package:eventpro/features/assistant/domain/business/commands/assistant_business_command.dart';
import 'package:eventpro/features/assistant/domain/business/commands/assistant_business_command_category.dart';
import 'package:eventpro/features/assistant/domain/business/commands/assistant_business_command_id.dart';
import 'package:eventpro/features/assistant/domain/business/commands/assistant_business_command_metadata.dart';
import 'package:eventpro/features/assistant/domain/business/commands/assistant_business_command_parameter.dart';
import 'package:eventpro/features/assistant/domain/business/commands/assistant_business_command_resolution_status.dart';
import 'package:eventpro/features/assistant/domain/business/commands/assistant_business_command_version.dart';
import 'package:eventpro/features/assistant/domain/workflow/assistant_workflow_business_context.dart';
import 'package:eventpro/features/assistant/domain/workflow/assistant_workflow_context.dart';
import 'package:eventpro/features/assistant/models/assistant_context.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/models/assistant_workflow_intent.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/local_assistant_business_command_registry.dart';
import 'package:eventpro/features/assistant/services/local_assistant_business_command_resolver.dart';
import 'package:eventpro/features/assistant/services/local_assistant_business_gateway.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_workflow_planner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-019 business command engine', () {
    final now = DateTime.utc(2026, 7, 20, 20);
    DateTime clock() => now;

    AssistantRequest req(String text, {String id = 'req-cmd'}) {
      return AssistantRequest(
        id: id,
        rawText: text,
        locale: 'pt_BR',
        timezone: 'America/Sao_Paulo',
        timestamp: now,
        origin: AssistantInputOrigin.typedText,
        context: const AssistantContext(sessionId: 's-cmd'),
      );
    }

    test('registry: findByOperationCode', () {
      final registry = LocalAssistantBusinessCommandRegistry.defaults();
      expect(registry.commands, hasLength(6));
      expect(
        registry
            .findByOperationCode(AssistantBusinessOperationCodes.createQuote)
            ?.id,
        AssistantBusinessCommandIds.createQuote,
      );
      expect(
        registry.findByCategory(AssistantBusinessCommandCategory.lookup).length,
        4,
      );
    });

    test('resolver: operationCode → Capability', () {
      final resolver = LocalAssistantBusinessCommandResolver();
      final ok = resolver.resolve(id: AssistantBusinessCommandIds.findClient);
      expect(ok.ready, isTrue);
      expect(ok.resolvedCapability?.id, AssistantBusinessCapabilityIds.findClient);
      expect(ok.command?.operationCode, AssistantBusinessOperationCodes.findClient);

      final alone = resolver.resolve(id: AssistantBusinessCommandIds.createQuote);
      expect(alone.ready, isFalse);

      final seq = resolver.resolveSequence(
        ids: const [
          AssistantBusinessCommandIds.findClient,
          AssistantBusinessCommandIds.createQuote,
        ],
      );
      expect(seq.every((r) => r.ready), isTrue);
      expect(
        seq.last.resolvedCapability?.id,
        AssistantBusinessCapabilityIds.createQuote,
      );
    });

    test('resolver: missing operationCode / unknown capability', () {
      final registry = LocalAssistantBusinessCommandRegistry.defaults()
          .register(
        const AssistantBusinessCommand(
          id: AssistantBusinessCommandId('NoOp'),
          metadata: AssistantBusinessCommandMetadata(label: 'No op'),
        ),
      ).register(
        const AssistantBusinessCommand(
          id: AssistantBusinessCommandId('UnknownOp'),
          metadata: AssistantBusinessCommandMetadata(
            label: 'Unknown',
            operationCode: 'DOES_NOT_EXIST',
          ),
        ),
      );
      final resolver =
          LocalAssistantBusinessCommandResolver(registry: registry);

      expect(
        resolver.resolve(id: const AssistantBusinessCommandId('NoOp')).ready,
        isFalse,
      );
      expect(
        resolver
            .resolve(id: const AssistantBusinessCommandId('UnknownOp'))
            .resolutionStatus,
        AssistantBusinessCommandResolutionStatus.blocked,
      );
    });

    test('resolver: missing required parameter', () {
      final registry = LocalAssistantBusinessCommandRegistry.defaults()
          .register(
        const AssistantBusinessCommand(
          id: AssistantBusinessCommandId('NeedsQuery'),
          metadata: AssistantBusinessCommandMetadata(
            label: 'Needs',
            operationCode: AssistantBusinessOperationCodes.findClient,
          ),
          parameters: [
            AssistantBusinessCommandParameter(key: 'query', required: true),
          ],
        ),
      );
      final resolver =
          LocalAssistantBusinessCommandResolver(registry: registry);
      final missing =
          resolver.resolve(id: const AssistantBusinessCommandId('NeedsQuery'));
      expect(
        missing.resolutionStatus,
        AssistantBusinessCommandResolutionStatus.missingParameter,
      );
    });

    test('planner: nodes com plannerOrder, deps e outputs', () {
      final planner = LocalAssistantWorkflowPlanner(clock: clock);
      final plan = planner.planExecution(
        const RunWorkflowIntent(
          AssistantWorkflowRecipe.findClientThenCreateQuote,
        ),
        requestId: 'p1',
        request: req('x'),
      );
      expect(plan, isNotNull);
      expect(plan!.commandExecutionNodes, hasLength(2));

      final first = plan.commandExecutionNodes.first;
      final last = plan.commandExecutionNodes.last;

      expect(first.plannerOrder, 0);
      expect(last.plannerOrder, 1);
      expect(first.operationCode, AssistantBusinessOperationCodes.findClient);
      expect(last.operationCode, AssistantBusinessOperationCodes.createQuote);
      expect(first.dependencyIndexes, isEmpty);
      expect(last.dependencyIndexes, [0]);
      expect(
        first.producedOutputs,
        contains(AssistantWorkflowBusinessKeys.clientReference),
      );
      expect(
        last.producedOutputs,
        contains(AssistantWorkflowBusinessKeys.quoteReference),
      );
      expect(first.version, AssistantBusinessCommandVersion.v1);
      expect(first.stepId, isNotNull);
    });

    test('planner: AI-016 sem commands', () {
      final planner = LocalAssistantWorkflowPlanner(clock: clock);
      final plan = planner.planExecution(
        const RunWorkflowIntent(
          AssistantWorkflowRecipe.confirmationCreateThenAudit,
        ),
        requestId: 'p2',
        request: req('x'),
      );
      expect(plan!.commandExecutionNodes, isEmpty);
    });

    test('contexto e regressão orchestrator', () async {
      final planner = LocalAssistantWorkflowPlanner(clock: clock);
      final plan = planner.planExecution(
        const RunWorkflowIntent(
          AssistantWorkflowRecipe.findClientThenCreateQuote,
        ),
        requestId: 'p3',
        request: req('x'),
      )!;
      final ctx = const AssistantWorkflowContext()
          .withCommandExecutionNodes(plan.commandExecutionNodes);
      expect(ctx.commandExecutionNodes.last.dependencyIndexes, [0]);

      final orch = LocalAssistantOrchestrator(
        clock: clock,
        capabilities: AssistantCapabilities.localBusinessWorkflow(),
        businessGateway: LocalAssistantBusinessGateway(),
      );
      final biz = await orch.handle(
        req('Buscar cliente e criar orçamento', id: 'orch-biz'),
      );
      expect(biz.workflowResult?.completed, isTrue);
    });
  });
}
