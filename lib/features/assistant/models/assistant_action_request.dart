import 'assistant_action_kind.dart';
import 'assistant_action_target.dart';

/// Planned smart-action request — no navigation side effects.
class AssistantActionRequest {
  const AssistantActionRequest({
    required this.id,
    required this.requestId,
    required this.kind,
    required this.target,
    this.sessionId,
    this.requiredCapabilities = const {},
  });

  final String id;
  final String requestId;
  final AssistantActionKind kind;
  final AssistantActionTarget target;
  final String? sessionId;
  final Set<String> requiredCapabilities;

  /// Fingerprint for in-memory idempotent replays.
  String get idempotencyKey =>
      '${kind.name}|${target.module}|${target.routePath ?? ''}|'
      '${target.entityType ?? ''}|${target.entityId ?? ''}|'
      '${sessionId ?? ''}';

  Map<String, Object?> toDeterministicMap() => {
        'id': id,
        'requestId': requestId,
        'kind': kind.name,
        'target': target.toDeterministicMap(),
        'sessionId': sessionId,
        'requiredCapabilities': requiredCapabilities.toList()..sort(),
        'idempotencyKey': idempotencyKey,
      };
}

/// Capability key required by smart-action requests.
abstract final class AssistantActionCapabilities {
  static const smartActions = 'smartActions';
}
