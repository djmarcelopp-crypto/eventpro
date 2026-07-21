import 'package:eventpro/features/assistant/domain/business/reasoning/business_reasoning_decision.dart';
import 'package:eventpro/features/assistant/domain/business/reasoning/business_reasoning_issue.dart';
import 'package:eventpro/features/assistant/domain/business/reasoning/business_reasoning_request.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/local_assistant_business_reasoning.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = LocalAssistantBusinessReasoning();
  final now = DateTime.utc(2026, 7, 21, 1);

  group('AI-023 CP-3/4/5 rule engine', () {
    test('cliente ausente → askUser + sugestão', () async {
      final result = await engine.evaluate(
        const BusinessReasoningRequest(
          requestId: 'br1',
          intentLabel: 'create_quote',
          commandIds: ['cmd.create_quote'],
        ),
      );
      expect(result.decision.kind, BusinessReasoningDecisionKind.askUser);
      expect(
        result.issues.map((i) => i.code),
        contains(BusinessReasoningIssueCode.clientMissing),
      );
      expect(
        result.suggestions.map((s) => s.message),
        contains('Selecione um cliente.'),
      );
      expect(result.explanations.first, startsWith('motivo:'));
    });

    test('cliente ambíguo → resolveAmbiguity', () async {
      final result = await engine.evaluate(
        const BusinessReasoningRequest(
          requestId: 'br2',
          clientCandidateCount: 3,
          gatewayAmbiguous: true,
        ),
      );
      expect(
        result.decision.kind,
        BusinessReasoningDecisionKind.resolveAmbiguity,
      );
      expect(
        result.suggestions.any((s) => s.message.contains('clientes')),
        isTrue,
      );
    });

    test('orçamento fechado → block', () async {
      final result = await engine.evaluate(
        const BusinessReasoningRequest(
          requestId: 'br3',
          quoteId: 'q1',
          quoteStatus: BusinessReasoningQuoteStatus.closed,
        ),
      );
      expect(result.isBlocked, isTrue);
      expect(
        result.suggestions.map((s) => s.message),
        contains('Finalize o orçamento primeiro.'),
      );
    });

    test('contrato cancelado → block', () async {
      final result = await engine.evaluate(
        const BusinessReasoningRequest(
          requestId: 'br4',
          contractStatus: BusinessReasoningContractStatus.cancelled,
        ),
      );
      expect(result.decision.kind, BusinessReasoningDecisionKind.block);
    });

    test('dependência pendente → satisfyDependency', () async {
      final result = await engine.evaluate(
        const BusinessReasoningRequest(
          requestId: 'br5',
          pendingDependencies: ['clientReference'],
        ),
      );
      expect(
        result.decision.kind,
        BusinessReasoningDecisionKind.satisfyDependency,
      );
    });

    test('conflito de comandos', () async {
      final result = await engine.detectConflicts(
        const BusinessReasoningRequest(
          requestId: 'br6',
          conflictingCommandIds: ['CREATE_QUOTE', 'CANCEL_QUOTE'],
        ),
      );
      expect(
        result.issues.map((i) => i.code),
        contains(BusinessReasoningIssueCode.commandConflict),
      );
    });

    test('fluxo destrutivo sem confirmação → block + sugestão', () async {
      final result = await engine.evaluate(
        const BusinessReasoningRequest(
          requestId: 'br7',
          commandIds: ['CANCEL_CONTRACT'],
          requiresConfirmation: false,
        ),
      );
      expect(result.isBlocked, isTrue);
      expect(
        result.suggestions.map((s) => s.message),
        contains('Confirme antes de cancelar.'),
      );
    });

    test('explainDecision retorna regras e confiança', () async {
      final result = await engine.evaluate(
        const BusinessReasoningRequest(
          requestId: 'br8',
          missingRequiredFields: ['eventDate'],
        ),
      );
      final lines = await engine.explainDecision(result);
      expect(lines.any((l) => l.startsWith('regras:')), isTrue);
      expect(lines.any((l) => l.startsWith('confiança:')), isTrue);
    });

    test('cenário saudável → proceed', () async {
      final result = await engine.evaluate(
        const BusinessReasoningRequest(
          requestId: 'br9',
          clientFound: true,
          clientId: 'c1',
        ),
      );
      expect(result.canProceed, isTrue);
    });
  });

  group('AI-023 CP-6 integração', () {
    test('flag off preserva fluxo', () async {
      final orch = LocalAssistantOrchestrator(clock: () => now);
      final response = await orch.handle(
        AssistantRequest(
          id: 'br-off',
          rawText: 'criar orçamento',
          locale: 'pt_BR',
          timezone: 'UTC',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
        ),
      );
      expect(response.rawText, 'criar orçamento');
    });

    test('flag on avalia sem quebrar', () async {
      final orch = LocalAssistantOrchestrator(
        clock: () => now,
        capabilities: AssistantCapabilities.localBusinessReasoning(),
      );
      final response = await orch.handle(
        AssistantRequest(
          id: 'br-on',
          rawText: 'criar orçamento',
          locale: 'pt_BR',
          timezone: 'UTC',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
        ),
      );
      expect(response.friendlyMessage, isNotEmpty);
    });
  });
}
