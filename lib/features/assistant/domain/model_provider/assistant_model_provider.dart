import 'assistant_model.dart';
import 'assistant_model_message.dart';

/// Provider descriptor — identity / capabilities / models (AI-025 CP-1).
///
/// Does **not** perform inference. The Assistente depends on this domain
/// type and on [AssistantModelProviderPort], never on a vendor SDK.
class AssistantModelProvider {
  const AssistantModelProvider({
    required this.id,
    required this.name,
    this.priority = 0,
    this.capabilities = AssistantModelCapabilities.textOnly,
    this.models = const [],
    this.defaultModelId,
    this.metadata = const AssistantModelMetadata(),
  });

  final String id;
  final String name;

  /// Higher wins when selecting by priority.
  final int priority;
  final AssistantModelCapabilities capabilities;
  final List<AssistantModel> models;
  final String? defaultModelId;
  final AssistantModelMetadata metadata;

  AssistantModel? get defaultModel {
    if (defaultModelId != null) {
      for (final m in models) {
        if (m.id == defaultModelId) return m;
      }
    }
    return models.isEmpty ? null : models.first;
  }

  Map<String, Object?> toDeterministicMap() => {
        'id': id,
        'name': name,
        'priority': priority,
        'capabilities': capabilities.toDeterministicMap(),
        'models': models.map((m) => m.toDeterministicMap()).toList(),
        'defaultModelId': defaultModelId,
        'metadata': metadata.toDeterministicMap(),
      };
}
