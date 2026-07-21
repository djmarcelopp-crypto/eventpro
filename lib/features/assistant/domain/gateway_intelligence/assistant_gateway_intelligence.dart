import 'gateway_entity_kind.dart';
import 'gateway_entity_reference.dart';
import 'gateway_match.dart';
import 'gateway_query.dart';
import 'gateway_query_result.dart';

/// Port for intelligent ERP discovery without concrete ERP bindings (AI-022).
abstract class AssistantGatewayIntelligence {
  /// Search entities matching [query].
  Future<GatewayQueryResult> search(GatewayQuery query);

  /// Best single match, or ambiguous/empty result.
  Future<GatewayQueryResult> findBestMatch(GatewayQuery query);

  /// Resolve a known id / label into a reference.
  Future<GatewayEntityReference?> resolveReference({
    required GatewayEntityKind kind,
    required String raw,
    String? requestId,
  });

  /// List ranked candidates for [query].
  Future<List<GatewayMatch>> listCandidates(GatewayQuery query);

  /// Ordered suggestions when the query is ambiguous.
  Future<List<GatewayMatch>> suggestEntities(GatewayQuery query);
}
