import 'gateway_match.dart';
import 'gateway_query.dart';

/// Outcome status for a gateway intelligence query.
enum GatewayQueryStatus {
  matched,
  ambiguous,
  empty,
  unsupported,
  failed,
}

extension GatewayQueryStatusX on GatewayQueryStatus {
  Map<String, Object?> toDeterministicMap() => {'status': name};
}

/// Typed message attached to a result.
class GatewayQueryMessage {
  const GatewayQueryMessage({
    required this.code,
    required this.message,
  });

  static const ambiguous = 'gateway.ambiguous';
  static const empty = 'gateway.empty';
  static const unsupported = 'gateway.unsupported';
  static const failed = 'gateway.failed';

  final String code;
  final String message;

  Map<String, Object?> toDeterministicMap() => {
        'code': code,
        'message': message,
      };
}

/// Immutable result of Gateway Intelligence.
class GatewayQueryResult {
  const GatewayQueryResult({
    required this.requestId,
    required this.query,
    required this.status,
    this.matches = const [],
    this.bestMatch,
    this.suggestions = const [],
    this.messages = const [],
  });

  final String requestId;
  final GatewayQuery query;
  final GatewayQueryStatus status;
  final List<GatewayMatch> matches;
  final GatewayMatch? bestMatch;
  final List<GatewayMatch> suggestions;
  final List<GatewayQueryMessage> messages;

  bool get isAmbiguous => status == GatewayQueryStatus.ambiguous;
  bool get hasMatch => bestMatch != null;

  Map<String, Object?> toDeterministicMap() => {
        'requestId': requestId,
        'query': query.toDeterministicMap(),
        'status': status.name,
        'matches': matches.map((m) => m.toDeterministicMap()).toList(),
        'bestMatch': bestMatch?.toDeterministicMap(),
        'suggestions': suggestions.map((m) => m.toDeterministicMap()).toList(),
        'messages': messages.map((m) => m.toDeterministicMap()).toList(),
      };
}
