import 'assistant_conversation_id.dart';
import 'assistant_conversation_metadata.dart';
import 'assistant_conversation_snapshot.dart';
import 'assistant_conversation_state.dart';
import 'assistant_conversation_status.dart';
import 'assistant_conversation_summary.dart';
import 'assistant_conversation_turn.dart';

/// Immutable conversation aggregate (Context Engine AI-021).
///
/// In-memory only — no Drift, HTTP, or LLM.
class AssistantConversation {
  const AssistantConversation({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.status = AssistantConversationStatus.active,
    this.metadata = const AssistantConversationMetadata(),
    this.state = AssistantConversationState.empty,
    this.turns = const [],
    this.summary = AssistantConversationSummary.empty,
    this.version = 0,
  });

  final AssistantConversationId id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final AssistantConversationStatus status;
  final AssistantConversationMetadata metadata;
  final AssistantConversationState state;
  final List<AssistantConversationTurn> turns;
  final AssistantConversationSummary summary;
  final int version;

  AssistantConversationTurn? get lastTurn =>
      turns.isEmpty ? null : turns.last;

  AssistantConversation copyWith({
    AssistantConversationStatus? status,
    AssistantConversationMetadata? metadata,
    AssistantConversationState? state,
    List<AssistantConversationTurn>? turns,
    AssistantConversationSummary? summary,
    DateTime? updatedAt,
    int? version,
  }) {
    return AssistantConversation(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
      state: state ?? this.state,
      turns: turns ?? this.turns,
      summary: summary ?? this.summary,
      version: version ?? this.version,
    );
  }

  AssistantConversationSnapshot toSnapshot({int recentLimit = 10}) {
    final recent = turns.length <= recentLimit
        ? turns
        : turns.sublist(turns.length - recentLimit);
    return AssistantConversationSnapshot(
      conversationId: id,
      status: status,
      metadata: metadata,
      state: state,
      recentTurns: List.unmodifiable(recent),
      summary: summary,
      createdAt: createdAt,
      updatedAt: updatedAt,
      version: version,
    );
  }

  Map<String, Object?> toDeterministicMap() => {
        'id': id.toDeterministicMap(),
        'createdAt': createdAt.toUtc().toIso8601String(),
        'updatedAt': updatedAt.toUtc().toIso8601String(),
        'status': status.name,
        'metadata': metadata.toDeterministicMap(),
        'state': state.toDeterministicMap(),
        'turns': turns.map((t) => t.toDeterministicMap()).toList(growable: false),
        'summary': summary.toDeterministicMap(),
        'version': version,
      };
}
