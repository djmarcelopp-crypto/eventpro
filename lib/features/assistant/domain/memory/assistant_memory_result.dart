import 'assistant_memory_entry.dart';
import 'assistant_memory_search.dart';

/// Outcome of a memory search / list.
class AssistantMemoryResult {
  const AssistantMemoryResult({
    required this.entries,
    this.totalMatched = 0,
    this.query,
    this.messages = const [],
  });

  final List<AssistantMemoryEntry> entries;
  final int totalMatched;
  final AssistantMemorySearch? query;
  final List<String> messages;

  bool get isEmpty => entries.isEmpty;

  Map<String, Object?> toDeterministicMap() => {
        'entries': entries.map((e) => e.toDeterministicMap()).toList(),
        'totalMatched': totalMatched,
        'query': query?.toDeterministicMap(),
        'messages': messages,
      };
}

/// Observability record for a memory operation (contracts only — AI-024 CP-8).
class AssistantMemoryOperationRecord {
  const AssistantMemoryOperationRecord({
    required this.operation,
    required this.timestamp,
    this.origin,
    this.reason,
    this.confidence,
    this.scope,
    this.memoryId,
    this.details = const [],
  });

  final String operation;
  final DateTime timestamp;
  final String? origin;
  final String? reason;
  final double? confidence;
  final String? scope;
  final String? memoryId;
  final List<String> details;

  Map<String, Object?> toDeterministicMap() => {
        'operation': operation,
        'timestamp': timestamp.toUtc().toIso8601String(),
        'origin': origin,
        'reason': reason,
        'confidence': confidence,
        'scope': scope,
        'memoryId': memoryId,
        'details': details,
      };
}
