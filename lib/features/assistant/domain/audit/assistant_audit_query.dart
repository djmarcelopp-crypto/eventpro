import 'assistant_audit_event_type.dart';

/// Deterministic audit query with a mandatory default limit.
class AssistantAuditQuery {
  const AssistantAuditQuery({
    required this.requestId,
    this.sessionId,
    this.correlationId,
    this.eventType,
    this.latestOnly = false,
    this.limit = defaultLimit,
  });

  static const defaultLimit = 50;

  final String requestId;
  final String? sessionId;
  final String? correlationId;
  final AssistantAuditEventType? eventType;
  final bool latestOnly;

  /// Max events returned (clamped to [defaultLimit] when exceeded).
  final int limit;

  int get effectiveLimit {
    if (latestOnly) return 1;
    if (limit <= 0) return defaultLimit;
    return limit > defaultLimit ? defaultLimit : limit;
  }

  Map<String, Object?> toDeterministicMap() => {
        'requestId': requestId,
        'sessionId': sessionId,
        'correlationId': correlationId,
        'eventType': eventType?.name,
        'latestOnly': latestOnly,
        'limit': effectiveLimit,
      };
}
