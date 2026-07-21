import 'assistant_model_role.dart';

/// Immutable chat message for model completion requests.
class AssistantModelMessage {
  const AssistantModelMessage({
    required this.role,
    required this.content,
    this.name,
    this.toolCallId,
  });

  final AssistantModelRole role;
  final String content;
  final String? name;
  final String? toolCallId;

  Map<String, Object?> toDeterministicMap() => {
        'role': role.name,
        'content': content,
        'name': name,
        'toolCallId': toolCallId,
      };
}

/// Token / cost usage snapshot (contracts only).
class AssistantModelUsage {
  const AssistantModelUsage({
    this.promptTokens = 0,
    this.completionTokens = 0,
    this.totalTokens = 0,
    this.estimatedCostUsd,
  });

  final int promptTokens;
  final int completionTokens;
  final int totalTokens;
  final double? estimatedCostUsd;

  static const zero = AssistantModelUsage();

  Map<String, Object?> toDeterministicMap() => {
        'promptTokens': promptTokens,
        'completionTokens': completionTokens,
        'totalTokens': totalTokens,
        'estimatedCostUsd': estimatedCostUsd,
      };
}

/// Capability set declared by a model or provider.
class AssistantModelCapabilities {
  const AssistantModelCapabilities({
    this.capabilities = const {},
  });

  final Set<AssistantModelCapability> capabilities;

  static const textOnly = AssistantModelCapabilities(
    capabilities: {AssistantModelCapability.text},
  );

  static const mockDefaults = AssistantModelCapabilities(
    capabilities: {
      AssistantModelCapability.text,
      AssistantModelCapability.json,
      AssistantModelCapability.streaming,
    },
  );

  bool supports(AssistantModelCapability capability) =>
      capabilities.contains(capability);

  bool supportsAll(Iterable<AssistantModelCapability> required) =>
      required.every(supports);

  Map<String, Object?> toDeterministicMap() => {
        'capabilities':
            capabilities.map((c) => c.name).toList()..sort(),
      };
}

/// Free-form metadata for models / providers / requests.
class AssistantModelMetadata {
  const AssistantModelMetadata({
    this.origin,
    this.correlationId,
    this.sessionId,
    this.tags = const [],
    this.notes,
    this.extra = const {},
  });

  final String? origin;
  final String? correlationId;
  final String? sessionId;
  final List<String> tags;
  final String? notes;
  final Map<String, String> extra;

  Map<String, Object?> toDeterministicMap() => {
        'origin': origin,
        'correlationId': correlationId,
        'sessionId': sessionId,
        'tags': tags,
        'notes': notes,
        'extra': extra,
      };
}
