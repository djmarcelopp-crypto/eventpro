import 'package:eventpro/features/assistant/domain/context/assistant_turn_identity.dart';
import 'package:eventpro/features/assistant/domain/workflow/assistant_workflow_business_context.dart';
import 'package:eventpro/features/assistant/domain/workflow/assistant_workflow_context.dart';
import 'package:eventpro/features/assistant/domain/workflow/assistant_workflow_execution_plan.dart';
import 'package:eventpro/features/assistant/models/assistant_context.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_workflow_planner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 7, 20, 23);

  group('AR-002 CP-1/CP-2 effectiveRequest + identity', () {
    test('TurnIdentity não inventa sessionId', () {
      final id = AssistantTurnIdentity.resolve(
        AssistantRequest(
          id: 'r1',
          rawText: 'x',
          locale: 'pt_BR',
          timezone: 'UTC',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
        ),
      );
      expect(id.sessionId, isNull);
      expect(id.conversationId, 'req:r1');
      expect(id.correlationId, 'r1');
      expect(id.hasSession, isFalse);
    });

    test('TurnIdentity reutiliza sessionId do request', () {
      final id = AssistantTurnIdentity.resolve(
        AssistantRequest(
          id: 'r2',
          rawText: 'x',
          locale: 'pt_BR',
          timezone: 'UTC',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
          context: const AssistantContext(sessionId: 'sess-9'),
        ),
      );
      expect(id.sessionId, 'sess-9');
      expect(id.conversationId, 'sess-9');
    });

    test('multimodal + context engine usam mesmo texto normalizado', () async {
      final orch = LocalAssistantOrchestrator(
        clock: () => now,
        capabilities: AssistantCapabilities.localDefaults().copyWith(
          canUseMultimodalInput: true,
          canUseContextEngine: true,
        ),
      );
      final response = await orch.handle(
        AssistantRequest(
          id: 'ar002-mm',
          rawText: '  criar   orçamento  ',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
          context: const AssistantContext(sessionId: 'sess-ar002'),
        ),
      );
      expect(response.rawText, 'criar orçamento');
      expect(response.friendlyMessage.toLowerCase(), contains('orçamento'));
    });
  });

  group('AR-002 CP-4 ExecutionPlan metadata preserved', () {
    test('toWorkflow preserva command/capability lists', () {
      final planner = LocalAssistantWorkflowPlanner(clock: () => now);
      final defs = planner.definitionRegistry.definitions.toList();
      expect(defs, isNotEmpty);

      final plan = AssistantWorkflowExecutionPlan.fromDefinition(
        definition: defs.first,
        requestId: 'p1',
        generatedAt: now,
      );
      final wf = plan.toWorkflow();
      expect(wf.recipe, plan.definitionId);
      expect(wf.commandExecutionNodes, plan.commandExecutionNodes);
      expect(wf.capabilityExecutionNodes, plan.executionNodes);
      expect(wf.resolvedCommands, plan.resolvedCommands);
      expect(wf.resolvedCapabilities, plan.resolvedCapabilities);

      final ctx = const AssistantWorkflowContext()
          .withResolvedCommands(wf.resolvedCommands)
          .withCommandExecutionNodes(wf.commandExecutionNodes)
          .withResolvedCapabilities(wf.resolvedCapabilities)
          .withCapabilityExecutionNodes(wf.capabilityExecutionNodes);
      expect(ctx.commandExecutionNodes, wf.commandExecutionNodes);
      expect(ctx.capabilityExecutionNodes, wf.capabilityExecutionNodes);
    });
  });
}
