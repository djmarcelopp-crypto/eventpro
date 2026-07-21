import 'assistant_model_message.dart';
import 'assistant_model_role.dart';

/// Structured error from a model provider (immutable, no HTTP).
class AssistantModelError {
  const AssistantModelError({
    required this.code,
    required this.message,
    this.retryable = false,
    this.details = const [],
  });

  final String code;
  final String message;
  final bool retryable;
  final List<String> details;

  Map<String, Object?> toDeterministicMap() => {
        'code': code,
        'message': message,
        'retryable': retryable,
        'details': details,
      };
}

/// Describes a concrete model offered by a provider.
class AssistantModel {
  const AssistantModel({
    required this.id,
    required this.name,
    this.capabilities = AssistantModelCapabilities.textOnly,
    this.contextWindowTokens,
    this.metadata = const AssistantModelMetadata(),
  });

  final String id;
  final String name;
  final AssistantModelCapabilities capabilities;
  final int? contextWindowTokens;
  final AssistantModelMetadata metadata;

  Map<String, Object?> toDeterministicMap() => {
        'id': id,
        'name': name,
        'capabilities': capabilities.toDeterministicMap(),
        'contextWindowTokens': contextWindowTokens,
        'metadata': metadata.toDeterministicMap(),
      };
}

/// Completion / generation request (immutable).
class AssistantModelRequest {
  const AssistantModelRequest({
    required this.messages,
    this.modelId,
    this.temperature,
    this.maxTokens,
    this.jsonMode = false,
    this.metadata = const AssistantModelMetadata(),
  });

  final List<AssistantModelMessage> messages;
  final String? modelId;
  final double? temperature;
  final int? maxTokens;
  final bool jsonMode;
  final AssistantModelMetadata metadata;

  String get lastUserText {
    for (var i = messages.length - 1; i >= 0; i--) {
      if (messages[i].role == AssistantModelRole.user) {
        return messages[i].content;
      }
    }
    return '';
  }

  Map<String, Object?> toDeterministicMap() => {
        'messages': messages.map((m) => m.toDeterministicMap()).toList(),
        'modelId': modelId,
        'temperature': temperature,
        'maxTokens': maxTokens,
        'jsonMode': jsonMode,
        'metadata': metadata.toDeterministicMap(),
      };
}

/// Completion response (immutable).
class AssistantModelResponse {
  const AssistantModelResponse({
    required this.id,
    required this.providerId,
    required this.modelId,
    required this.content,
    required this.createdAt,
    this.usage = AssistantModelUsage.zero,
    this.finishReason,
    this.error,
    this.metadata = const AssistantModelMetadata(),
  });

  final String id;
  final String providerId;
  final String modelId;
  final String content;
  final DateTime createdAt;
  final AssistantModelUsage usage;
  final String? finishReason;
  final AssistantModelError? error;
  final AssistantModelMetadata metadata;

  bool get isSuccess => error == null;

  Map<String, Object?> toDeterministicMap() => {
        'id': id,
        'providerId': providerId,
        'modelId': modelId,
        'content': content,
        'createdAt': createdAt.toUtc().toIso8601String(),
        'usage': usage.toDeterministicMap(),
        'finishReason': finishReason,
        'error': error?.toDeterministicMap(),
        'metadata': metadata.toDeterministicMap(),
      };
}
