import 'package:eventpro/features/assistant/domain/context/assistant_context_builder.dart';
import 'package:eventpro/features/assistant/domain/context/assistant_context_pipeline.dart';
import 'package:eventpro/features/assistant/domain/context/assistant_conversation_id.dart';
import 'package:eventpro/features/assistant/domain/context/assistant_conversation_metadata.dart';
import 'package:eventpro/features/assistant/domain/context/assistant_conversation_turn.dart';
import 'package:eventpro/features/assistant/models/assistant_context.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/local_assistant_context_builder.dart';
import 'package:eventpro/features/assistant/services/local_assistant_context_pipeline.dart';
import 'package:eventpro/features/assistant/services/local_assistant_conversation_memory.dart';
import 'package:eventpro/features/assistant/services/local_assistant_conversation_summarizer.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 7, 20, 22);

  group('AI-021 CP-2 memory', () {
    test('guarda histórico e estado ativo', () {
      final memory = LocalAssistantConversationMemory();
      const id = AssistantConversationId('mem-1');
      memory.getOrCreate(
        id: id,
        now: now,
        metadata: const AssistantConversationMetadata(sessionId: 's1'),
      );
      final updated = memory.appendTurn(
        id: id,
        turn: AssistantConversationTurn(
          turnIndex: 0,
          timestamp: now,
          intentLabel: 'search_client',
          commandIds: const ['cmd.search_client'],
          capabilityIds: const ['cap.clients'],
          workflowId: 'wf.quote',
          entityRefs: const ['client:9'],
        ),
        now: now,
      );
      expect(updated.turns, hasLength(1));
      expect(updated.state.lastIntentLabel, 'search_client');
      expect(updated.state.lastCommandIds, ['cmd.search_client']);
      expect(updated.state.lastCapabilityIds, ['cap.clients']);
      expect(updated.state.lastWorkflowId, 'wf.quote');
      expect(updated.state.lastEntityRefs, ['client:9']);
      expect(memory.find(id)?.version, 1);
    });
  });

  group('AI-021 CP-3 context builder', () {
    test('monta execution context sem executar', () {
      final memory = LocalAssistantConversationMemory();
      const id = AssistantConversationId('b1');
      final conversation = memory.getOrCreate(id: id, now: now);
      final ctx = const LocalAssistantContextBuilder().build(
        AssistantContextBuildRequest(
          conversation: conversation,
          requestId: 'req-1',
          builtAt: now,
          normalizedInputText: 'buscar cliente',
          intentLabel: 'search_client',
          commandIds: const ['cmd.search_client'],
          capabilityIds: const ['cap.clients'],
          workflowId: 'wf.1',
          executionPlanId: 'plan-1',
        ),
      );
      expect(ctx.conversationId, id);
      expect(ctx.requestId, 'req-1');
      expect(ctx.normalizedInputText, 'buscar cliente');
      expect(ctx.commandIds, ['cmd.search_client']);
      expect(ctx.executionPlanId, 'plan-1');
      expect(ctx.traceHints.any((h) => h.startsWith('conversationId:')), isTrue);
    });
  });

  group('AI-021 CP-4 summarizer', () {
    test('resumo determinístico preserva intents/comandos/entidades', () {
      final memory = LocalAssistantConversationMemory();
      const id = AssistantConversationId('sum-1');
      var conversation = memory.getOrCreate(id: id, now: now);
      for (var i = 0; i < 7; i++) {
        conversation = memory.appendTurn(
          id: id,
          turn: AssistantConversationTurn(
            turnIndex: i,
            timestamp: now.add(Duration(minutes: i)),
            intentLabel: 'intent_$i',
            commandIds: ['cmd_$i'],
            entityRefs: ['ent_$i'],
            workflowId: i.isEven ? 'wf_a' : 'wf_b',
          ),
          now: now.add(Duration(minutes: i)),
        );
      }

      const summarizer = LocalAssistantConversationSummarizer();
      final summarized = summarizer.summarize(
        conversation,
        keepRecentTurns: 3,
        now: now,
      );
      expect(summarized.turns, hasLength(3));
      expect(summarized.summary.coveredTurnCount, 4);
      expect(summarized.summary.intentLabels, contains('intent_0'));
      expect(summarized.summary.commandIds, contains('cmd_1'));
      expect(summarized.summary.entityRefs, contains('ent_2'));
      expect(summarized.summary.text, isNotEmpty);
      // Deterministic: same input → same summary text.
      expect(
        summarizer
            .buildSummary(conversation, keepRecentTurns: 3, now: now)
            .text,
        summarized.summary.text,
      );
    });
  });

  group('AI-021 CP-5 pipeline', () {
    test('Conversation → Memory → Builder → Execution Context', () {
      final pipeline = LocalAssistantContextPipeline();
      final result = pipeline.run(
        AssistantContextPipelineRequest(
          conversationId: const AssistantConversationId('p1'),
          requestId: 'req-p',
          now: now,
          normalizedInputText: 'criar orçamento',
          intentLabel: 'create_quote',
          commandIds: const ['cmd.create_quote'],
          commitTurn: true,
          autoSummarize: false,
        ),
      );
      expect(result.conversation.turns, hasLength(1));
      expect(result.executionContext.intentLabel, 'create_quote');
      expect(result.executionContext.commandIds, ['cmd.create_quote']);
      expect(result.executionContext.conversationId.value, 'p1');
    });

    test('preserva conversationId entre turnos', () {
      final pipeline = LocalAssistantContextPipeline();
      const id = AssistantConversationId('p2');
      pipeline.run(
        AssistantContextPipelineRequest(
          conversationId: id,
          requestId: 'r1',
          now: now,
          commitTurn: true,
          intentLabel: 'a',
          autoSummarize: false,
        ),
      );
      final second = pipeline.run(
        AssistantContextPipelineRequest(
          conversationId: id,
          requestId: 'r2',
          now: now.add(const Duration(seconds: 1)),
          commitTurn: true,
          intentLabel: 'b',
          autoSummarize: false,
        ),
      );
      expect(second.conversation.turns, hasLength(2));
      expect(second.executionContext.conversationId, id);
    });
  });

  group('AI-021 CP-6 integração', () {
    test('fluxo textual com context engine opt-in', () async {
      final orch = LocalAssistantOrchestrator(
        clock: () => now,
        capabilities: AssistantCapabilities.localContextEngine(),
      );
      final response = await orch.handle(
        AssistantRequest(
          id: 'req-ctx',
          rawText: 'criar orçamento',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
          context: const AssistantContext(sessionId: 'sess-ctx'),
        ),
      );
      expect(response.rawText, 'criar orçamento');
      expect(response.friendlyMessage, isNotEmpty);
    });

    test('sem flag context engine, default intacto', () async {
      final orch = LocalAssistantOrchestrator(clock: () => now);
      final response = await orch.handle(
        AssistantRequest(
          id: 'req-plain',
          rawText: 'criar orçamento',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
        ),
      );
      expect(response.rawText, 'criar orçamento');
    });
  });
}
