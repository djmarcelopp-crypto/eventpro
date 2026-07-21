import 'package:eventpro/features/assistant/domain/gateway_intelligence/gateway_entity_kind.dart';
import 'package:eventpro/features/assistant/domain/gateway_intelligence/gateway_entity_reference.dart';
import 'package:eventpro/features/assistant/domain/gateway_intelligence/gateway_match.dart';
import 'package:eventpro/features/assistant/domain/gateway_intelligence/gateway_query.dart';
import 'package:eventpro/features/assistant/domain/gateway_intelligence/gateway_query_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-022 CP-1 gateway intelligence contracts', () {
    test('query/result/match imutáveis', () {
      const ref = GatewayEntityReference(
        id: 'c1',
        kind: GatewayEntityKind.client,
        label: 'Ana',
      );
      const match = GatewayMatch(
        reference: ref,
        confidence: 0.9,
        reason: 'exact',
      );
      const query = GatewayQuery(requestId: 'r1', rawText: 'Ana');
      const result = GatewayQueryResult(
        requestId: 'r1',
        query: query,
        status: GatewayQueryStatus.matched,
        matches: [match],
        bestMatch: match,
      );
      expect(result.hasMatch, isTrue);
      expect(result.toDeterministicMap()['status'], 'matched');
      expect(GatewayEntityKind.values.map((e) => e.name), contains('supplier'));
    });
  });
}
