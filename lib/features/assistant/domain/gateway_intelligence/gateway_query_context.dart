import 'gateway_entity_kind.dart';

/// Query metadata (channel, limits, tracing) — immutable.
class GatewayQueryMetadata {
  const GatewayQueryMetadata({
    this.correlationId,
    this.sessionId,
    this.locale,
    this.maxCandidates = 10,
    this.minConfidence = 0.0,
    this.tags = const [],
  });

  final String? correlationId;
  final String? sessionId;
  final String? locale;
  final int maxCandidates;
  final double minConfidence;
  final List<String> tags;

  Map<String, Object?> toDeterministicMap() => {
        'correlationId': correlationId,
        'sessionId': sessionId,
        'locale': locale,
        'maxCandidates': maxCandidates,
        'minConfidence': minConfidence,
        'tags': tags,
      };
}

/// Active resolution context for a query (optional known refs).
class GatewayQueryContext {
  const GatewayQueryContext({
    this.activeClientId,
    this.activeQuoteId,
    this.activeEventId,
    this.hints = const [],
    this.preferredKinds = const [],
  });

  final String? activeClientId;
  final String? activeQuoteId;
  final String? activeEventId;
  final List<String> hints;
  final List<GatewayEntityKind> preferredKinds;

  Map<String, Object?> toDeterministicMap() => {
        'activeClientId': activeClientId,
        'activeQuoteId': activeQuoteId,
        'activeEventId': activeEventId,
        'hints': hints,
        'preferredKinds': preferredKinds.map((k) => k.name).toList(),
      };
}
