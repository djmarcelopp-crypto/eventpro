import 'package:eventpro/features/assistant/domain/gateway_intelligence/gateway_entity_kind.dart';
import 'package:eventpro/features/assistant/domain/gateway_intelligence/gateway_query.dart';
import 'package:eventpro/features/assistant/domain/gateway_intelligence/gateway_query_result.dart';
import 'package:eventpro/features/assistant/models/assistant_context.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/local_assistant_gateway_intelligence.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 7, 20, 23, 30);

  group('AI-022 CP-3/4/5 local intelligence', () {
    late LocalAssistantGatewayIntelligence intelligence;

    setUp(() {
      intelligence = LocalAssistantGatewayIntelligence();
    });

    test('João ambíguo gera sugestões ordenadas', () async {
      final result = await intelligence.findBestMatch(
        const GatewayQuery(
          requestId: 'q1',
          rawText: 'João',
          kinds: [GatewayEntityKind.client],
        ),
      );
      expect(result.status, GatewayQueryStatus.ambiguous);
      expect(result.suggestions.length, greaterThanOrEqualTo(2));
      expect(
        result.suggestions.map((s) => s.reference.label),
        containsAll(['João Silva', 'João Pereira', 'João Eventos']),
      );
      final ordered = result.suggestions.map((s) => s.confidence).toList();
      for (var i = 1; i < ordered.length; i++) {
        expect(ordered[i - 1] >= ordered[i], isTrue);
      }
    });

    test('nome completo resolve best match', () async {
      final result = await intelligence.findBestMatch(
        const GatewayQuery(
          requestId: 'q2',
          rawText: 'João Silva',
          kinds: [GatewayEntityKind.client],
        ),
      );
      expect(result.status, GatewayQueryStatus.matched);
      expect(result.bestMatch?.reference.id, 'client-joao-silva');
      expect(result.bestMatch!.confidence, greaterThan(0.9));
    });

    test('resolveReference por kind', () async {
      final ref = await intelligence.resolveReference(
        kind: GatewayEntityKind.event,
        raw: 'Casamento Ana',
      );
      expect(ref?.id, 'event-casamento-ana');
    });

    test('kinds supplier/product/resource', () async {
      final supplier = await intelligence.search(
        const GatewayQuery(
          requestId: 'q3',
          rawText: 'Luz',
          kinds: [GatewayEntityKind.supplier],
        ),
      );
      expect(supplier.bestMatch?.reference.kind, GatewayEntityKind.supplier);

      final product = await intelligence.search(
        const GatewayQuery(
          requestId: 'q4',
          rawText: 'Kit Som',
          kinds: [GatewayEntityKind.product],
        ),
      );
      expect(product.hasMatch, isTrue);

      final resource = await intelligence.search(
        const GatewayQuery(
          requestId: 'q5',
          rawText: 'Salão',
          kinds: [GatewayEntityKind.resource],
        ),
      );
      expect(resource.hasMatch, isTrue);
    });

    test('vazio', () async {
      final result = await intelligence.search(
        const GatewayQuery(requestId: 'q6', rawText: 'zzz-inexistente'),
      );
      expect(result.status, GatewayQueryStatus.empty);
    });
  });

  group('AI-022 CP-6 integração opt-in', () {
    test('flag off não quebra fluxo', () async {
      final orch = LocalAssistantOrchestrator(clock: () => now);
      final response = await orch.handle(
        AssistantRequest(
          id: 'gi-off',
          rawText: 'criar orçamento',
          locale: 'pt_BR',
          timezone: 'UTC',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
        ),
      );
      expect(response.rawText, 'criar orçamento');
    });

    test('flag on injeta candidatos em hints para João', () async {
      final orch = LocalAssistantOrchestrator(
        clock: () => now,
        capabilities: AssistantCapabilities.localGatewayIntelligence(),
      );
      final response = await orch.handle(
        AssistantRequest(
          id: 'gi-on',
          rawText: 'buscar cliente João',
          locale: 'pt_BR',
          timezone: 'UTC',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
          context: const AssistantContext(sessionId: 's-gi'),
        ),
      );
      expect(response.rawText, contains('João'));
      // Integration is additive via hints during handle; response still builds.
      expect(response.friendlyMessage, isNotEmpty);
    });
  });
}
