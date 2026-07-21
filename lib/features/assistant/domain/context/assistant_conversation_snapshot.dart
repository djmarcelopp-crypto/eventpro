import 'assistant_conversation_id.dart';
import 'assistant_conversation_metadata.dart';
import 'assistant_conversation_state.dart';
import 'assistant_conversation_status.dart';
import 'assistant_conversation_summary.dart';
import 'assistant_conversation_turn.dart';

/// Point-in-time immutable view of a conversation for builders / audit.
class AssistantConversationSnapshot {
  const AssistantConversationSnapshot({
    required this.conversationId,
    required this.status,
    required this.metadata,
    required this.state,
    required this.recentTurns,
    required this.createdAt,
    required this.updatedAt,
    this.summary = AssistantConversationSummary.empty,
    this.version = 0,
  });

  final AssistantConversationId conversationId;
  final AssistantConversationStatus status;
  final AssistantConversationMetadata metadata;
  final AssistantConversationState state;
  final List<AssistantConversationTurn> recentTurns;
  final AssistantConversationSummary summary;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  Map<String, Object?> toDeterministicMap() => {
        'conversationId': conversationId.toDeterministicMap(),
        'status': status.name,
        'metadata': metadata.toDeterministicMap(),
        'state': state.toDeterministicMap(),
        'recentTurns':
            recentTurns.map((t) => t.toDeterministicMap()).toList(growable: false),
        'summary': summary.toDeterministicMap(),
        'createdAt': createdAt.toUtc().toIso8601String(),
        'updatedAt': updatedAt.toUtc().toIso8601String(),
        'version': version,
      };
}
