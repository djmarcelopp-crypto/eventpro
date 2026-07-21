import 'gateway_entity_reference.dart';

/// Ranked match for a gateway query.
class GatewayMatch {
  const GatewayMatch({
    required this.reference,
    required this.confidence,
    required this.reason,
    this.scoreDetails = const [],
  });

  final GatewayEntityReference reference;

  /// 0.0–1.0 deterministic confidence.
  final double confidence;
  final String reason;
  final List<String> scoreDetails;

  Map<String, Object?> toDeterministicMap() => {
        'reference': reference.toDeterministicMap(),
        'confidence': confidence,
        'reason': reason,
        'scoreDetails': scoreDetails,
      };
}
