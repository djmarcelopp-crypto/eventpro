import 'assistant_audit_event.dart';
import 'assistant_audit_query.dart';
import 'assistant_audit_warning.dart';

/// Immutable result of an audit query.
class AssistantAuditResult {
  const AssistantAuditResult({
    required this.requestId,
    required this.events,
    required this.totalMatched,
    required this.returnedCount,
    required this.query,
    this.warnings = const [],
    this.summary,
    this.valid = true,
  });

  final String requestId;
  final List<AssistantAuditEvent> events;
  final int totalMatched;
  final int returnedCount;
  final AssistantAuditQuery query;
  final List<AssistantAuditWarning> warnings;
  final String? summary;
  final bool valid;

  Map<String, Object?> toDeterministicMap() => {
        'requestId': requestId,
        'totalMatched': totalMatched,
        'returnedCount': returnedCount,
        'valid': valid,
        'summary': summary,
        'query': query.toDeterministicMap(),
        'warnings': warnings.map((w) => w.toDeterministicMap()).toList(),
        'events': events.map((e) => e.toDeterministicMap()).toList(),
      };
}
