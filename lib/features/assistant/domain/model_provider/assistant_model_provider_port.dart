import 'assistant_model.dart';
import 'assistant_model_message.dart';
import 'assistant_model_role.dart';

/// Health snapshot for a provider (no network implied).
class AssistantModelProviderHealth {
  const AssistantModelProviderHealth({
    required this.status,
    required this.checkedAt,
    this.message,
  });

  final AssistantModelProviderHealthStatus status;
  final DateTime checkedAt;
  final String? message;

  bool get isHealthy =>
      status == AssistantModelProviderHealthStatus.healthy;

  Map<String, Object?> toDeterministicMap() => {
        'status': status.name,
        'checkedAt': checkedAt.toUtc().toIso8601String(),
        'message': message,
      };
}

enum AssistantModelProviderHealthStatus {
  healthy,
  degraded,
  unavailable,
  unknown,
}

/// Port for model inference providers (AI-025 CP-2).
///
/// No concrete vendor. No HTTP. No SDKs.
abstract class AssistantModelProviderPort {
  /// Non-streaming completion.
  Future<AssistantModelResponse> complete(AssistantModelRequest request);

  /// Streaming completion (may yield a single chunk for mocks).
  Stream<AssistantModelResponse> stream(AssistantModelRequest request);

  /// Deterministic token estimate (not a vendor tokenizer).
  Future<int> countTokens(AssistantModelRequest request);

  bool supportsVision();

  bool supportsAudio();

  bool supportsTools();

  bool supportsJson();

  Future<AssistantModelProviderHealth> health();
}

/// Observability record for a model-provider operation (AI-025 CP-8).
///
/// Contracts only — no concrete telemetry / HTTP / billing.
class AssistantModelProviderObservation {
  const AssistantModelProviderObservation({
    required this.operation,
    required this.providerId,
    required this.modelId,
    required this.timestamp,
    this.latencyMs,
    this.usage = AssistantModelUsage.zero,
    this.capabilities = const {},
    this.estimatedCostUsd,
    this.success = true,
    this.details = const [],
  });

  final String operation;
  final String providerId;
  final String modelId;
  final DateTime timestamp;
  final int? latencyMs;
  final AssistantModelUsage usage;
  final Set<AssistantModelCapability> capabilities;
  final double? estimatedCostUsd;
  final bool success;
  final List<String> details;

  Map<String, Object?> toDeterministicMap() => {
        'operation': operation,
        'providerId': providerId,
        'modelId': modelId,
        'timestamp': timestamp.toUtc().toIso8601String(),
        'latencyMs': latencyMs,
        'usage': usage.toDeterministicMap(),
        'capabilities':
            capabilities.map((c) => c.name).toList()..sort(),
        'estimatedCostUsd': estimatedCostUsd,
        'success': success,
        'details': details,
      };
}

/// Sink for provider observations (default no-op).
abstract class AssistantModelProviderObserver {
  void record(AssistantModelProviderObservation observation);
}

class NoopAssistantModelProviderObserver
    implements AssistantModelProviderObserver {
  const NoopAssistantModelProviderObserver();

  @override
  void record(AssistantModelProviderObservation observation) {}
}

class CollectingAssistantModelProviderObserver
    implements AssistantModelProviderObserver {
  CollectingAssistantModelProviderObserver();

  final List<AssistantModelProviderObservation> records = [];

  @override
  void record(AssistantModelProviderObservation observation) {
    records.add(observation);
  }
}
