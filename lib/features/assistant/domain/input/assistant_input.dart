import 'assistant_input_content.dart';
import 'assistant_input_id.dart';
import 'assistant_input_metadata.dart';
import 'assistant_input_status.dart';
import 'assistant_input_type.dart';

/// Immutable multimodal intake contract for the Assistente.
///
/// Does not store heavy file bytes — only text and safe attachment refs.
class AssistantInput {
  const AssistantInput({
    required this.id,
    required this.type,
    required this.content,
    required this.metadata,
    required this.receivedAt,
    this.status = AssistantInputStatus.received,
    this.correlationId,
  });

  final AssistantInputId id;
  final AssistantInputType type;
  final AssistantInputContent content;
  final AssistantInputMetadata metadata;
  final DateTime receivedAt;
  final AssistantInputStatus status;

  /// Explicit correlation; falls back to [metadata.correlationId].
  final String? correlationId;

  String get effectiveCorrelationId =>
      correlationId ?? metadata.correlationId ?? id.value;

  Map<String, Object?> toDeterministicMap() => {
        'id': id.toDeterministicMap(),
        'type': type.name,
        'content': content.toDeterministicMap(),
        'metadata': metadata.toDeterministicMap(),
        'receivedAt': receivedAt.toUtc().toIso8601String(),
        'status': status.name,
        'correlationId': effectiveCorrelationId,
      };
}
