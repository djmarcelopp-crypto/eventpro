import 'assistant_memory_type.dart';

/// Search criteria for memory retrieval (no NLP).
class AssistantMemorySearch {
  const AssistantMemorySearch({
    this.types = const [],
    this.scopes = const [],
    this.sessionId,
    this.correlationId,
    this.keys = const [],
    this.tags = const [],
    this.includeArchived = false,
    this.limit = 20,
  });

  final List<AssistantMemoryType> types;
  final List<AssistantMemoryScope> scopes;
  final String? sessionId;
  final String? correlationId;
  final List<String> keys;
  final List<String> tags;
  final bool includeArchived;
  final int limit;

  Map<String, Object?> toDeterministicMap() => {
        'types': types.map((t) => t.name).toList(),
        'scopes': scopes.map((s) => s.name).toList(),
        'sessionId': sessionId,
        'correlationId': correlationId,
        'keys': keys,
        'tags': tags,
        'includeArchived': includeArchived,
        'limit': limit,
      };
}
