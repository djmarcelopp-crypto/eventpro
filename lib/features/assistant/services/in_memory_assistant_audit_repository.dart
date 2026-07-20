import '../domain/audit/assistant_audit_event.dart';
import '../domain/audit/assistant_audit_event_type.dart';
import '../domain/audit/assistant_audit_metadata.dart';
import '../domain/audit/assistant_audit_query.dart';
import '../domain/audit/assistant_audit_repository.dart';

/// In-memory append-only audit store with per-session monotonic sequences.
class InMemoryAssistantAuditRepository implements AssistantAuditRepository {
  InMemoryAssistantAuditRepository();

  final List<AssistantAuditEvent> _events = [];
  final Map<String, int> _sequences = {};

  @override
  AssistantAuditEvent append(AssistantAuditEvent event) {
    final next = (_sequences[event.sessionId] ?? 0) + 1;
    _sequences[event.sessionId] = next;
    final stored = AssistantAuditEvent(
      eventId: event.eventId,
      eventType: event.eventType,
      timestamp: event.timestamp.toUtc(),
      sessionId: event.sessionId,
      correlationId: event.correlationId,
      actor: event.actor,
      target: event.target,
      metadata: AssistantAuditMetadata(
        tokenFingerprint: event.metadata.tokenFingerprint,
        planFingerprint: event.metadata.planFingerprint,
        outcomeCode: event.metadata.outcomeCode,
        errorCode: event.metadata.errorCode,
        sequence: next,
        extra: event.metadata.extra,
      ),
      outcome: event.outcome,
      warning: event.warning,
      sequence: next,
    );
    _events.add(stored);
    return stored;
  }

  @override
  List<AssistantAuditEvent> query(AssistantAuditQuery query) {
    final list = _match(query)
      ..sort((a, b) {
        final bySeq = a.sequence.compareTo(b.sequence);
        if (bySeq != 0) return bySeq;
        return a.timestamp.compareTo(b.timestamp);
      });

    final limit = query.effectiveLimit;
    if (query.latestOnly) {
      if (list.isEmpty) return const [];
      return List.unmodifiable([list.last]);
    }
    if (list.length <= limit) return List.unmodifiable(list);
    return List.unmodifiable(list.sublist(0, limit));
  }

  /// Full match count without applying limit.
  int matchCount(AssistantAuditQuery query) => _match(query).length;

  List<AssistantAuditEvent> _match(AssistantAuditQuery query) {
    Iterable<AssistantAuditEvent> matched = _events;
    final sessionId = query.sessionId?.trim();
    if (sessionId != null && sessionId.isNotEmpty) {
      matched = matched.where((e) => e.sessionId == sessionId);
    }
    final correlationId = query.correlationId?.trim();
    if (correlationId != null && correlationId.isNotEmpty) {
      matched = matched.where((e) => e.correlationId == correlationId);
    }
    if (query.eventType != null) {
      matched = matched.where((e) => e.eventType == query.eventType);
    }
    return matched.toList();
  }

  @override
  int countBySession(String sessionId) =>
      _events.where((e) => e.sessionId == sessionId).length;

  @override
  int countByCorrelation(String correlationId) =>
      _events.where((e) => e.correlationId == correlationId).length;

  @override
  int countByType(AssistantAuditEventType type) =>
      _events.where((e) => e.eventType == type).length;

  @override
  void reset({String? sessionId}) {
    if (sessionId == null || sessionId.trim().isEmpty) {
      _events.clear();
      _sequences.clear();
      return;
    }
    final id = sessionId.trim();
    _events.removeWhere((e) => e.sessionId == id);
    _sequences.remove(id);
  }

  List<AssistantAuditEvent> get allEvents => List.unmodifiable(_events);
}
