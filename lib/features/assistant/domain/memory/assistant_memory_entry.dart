import 'assistant_memory_id.dart';
import 'assistant_memory_metadata.dart';
import 'assistant_memory_reference.dart';
import 'assistant_memory_type.dart';

/// Immutable operational memory entry for the Assistente (AI-024).
///
/// Not model memory, not a cache — structured assistant knowledge.
class AssistantMemoryEntry {
  const AssistantMemoryEntry({
    required this.id,
    required this.type,
    required this.scope,
    required this.key,
    required this.createdAt,
    required this.updatedAt,
    this.value,
    this.references = const [],
    this.metadata = const AssistantMemoryMetadata(),
    this.status = AssistantMemoryStatus.active,
  });

  final AssistantMemoryId id;
  final AssistantMemoryType type;
  final AssistantMemoryScope scope;
  final String key;
  final String? value;
  final List<AssistantMemoryReference> references;
  final AssistantMemoryMetadata metadata;
  final AssistantMemoryStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  AssistantMemoryEntry copyWith({
    AssistantMemoryType? type,
    AssistantMemoryScope? scope,
    String? key,
    String? value,
    List<AssistantMemoryReference>? references,
    AssistantMemoryMetadata? metadata,
    AssistantMemoryStatus? status,
    DateTime? updatedAt,
    bool clearValue = false,
  }) {
    return AssistantMemoryEntry(
      id: id,
      type: type ?? this.type,
      scope: scope ?? this.scope,
      key: key ?? this.key,
      value: clearValue ? null : (value ?? this.value),
      references: references ?? this.references,
      metadata: metadata ?? this.metadata,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toDeterministicMap() => {
        'id': id.toDeterministicMap(),
        'type': type.name,
        'scope': scope.name,
        'key': key,
        'value': value,
        'references':
            references.map((r) => r.toDeterministicMap()).toList(),
        'metadata': metadata.toDeterministicMap(),
        'status': status.name,
        'createdAt': createdAt.toUtc().toIso8601String(),
        'updatedAt': updatedAt.toUtc().toIso8601String(),
      };
}
