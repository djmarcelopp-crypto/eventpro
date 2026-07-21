import 'gateway_entity_kind.dart';
import 'gateway_query_context.dart';

/// Immutable discovery query for Gateway Intelligence.
class GatewayQuery {
  const GatewayQuery({
    required this.requestId,
    required this.rawText,
    this.kinds = const [],
    this.context = const GatewayQueryContext(),
    this.metadata = const GatewayQueryMetadata(),
  });

  final String requestId;
  final String rawText;
  final List<GatewayEntityKind> kinds;
  final GatewayQueryContext context;
  final GatewayQueryMetadata metadata;

  String get effectiveText => rawText.trim();

  Map<String, Object?> toDeterministicMap() => {
        'requestId': requestId,
        'rawText': rawText,
        'kinds': kinds.map((k) => k.name).toList(),
        'context': context.toDeterministicMap(),
        'metadata': metadata.toDeterministicMap(),
      };
}
