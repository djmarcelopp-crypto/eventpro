import 'assistant_tool.dart';
import 'assistant_tool_types.dart';

/// Context for a tool invocation (immutable).
class AssistantToolExecutionContext {
  const AssistantToolExecutionContext({
    this.correlationId,
    this.sessionId,
    this.requestId,
    this.locale,
    this.intentLabel,
    this.hints = const [],
  });

  final String? correlationId;
  final String? sessionId;
  final String? requestId;
  final String? locale;
  final String? intentLabel;
  final List<String> hints;

  Map<String, Object?> toDeterministicMap() => {
        'correlationId': correlationId,
        'sessionId': sessionId,
        'requestId': requestId,
        'locale': locale,
        'intentLabel': intentLabel,
        'hints': hints,
      };
}

class AssistantToolExecutionMetadata {
  const AssistantToolExecutionMetadata({
    this.startedAt,
    this.finishedAt,
    this.latencyMs,
    this.engineId,
    this.permission,
  });

  final DateTime? startedAt;
  final DateTime? finishedAt;
  final int? latencyMs;
  final String? engineId;
  final AssistantToolPermission? permission;

  Map<String, Object?> toDeterministicMap() => {
        'startedAt': startedAt?.toUtc().toIso8601String(),
        'finishedAt': finishedAt?.toUtc().toIso8601String(),
        'latencyMs': latencyMs,
        'engineId': engineId,
        'permission': permission?.name,
      };
}

/// Request to invoke a tool (no real side effects in AI-028).
class AssistantToolRequest {
  const AssistantToolRequest({
    required this.toolId,
    this.arguments = const {},
    this.context = const AssistantToolExecutionContext(),
    this.requestedCapability,
  });

  final AssistantToolId toolId;
  final Map<String, String> arguments;
  final AssistantToolExecutionContext context;
  final AssistantToolCapability? requestedCapability;

  Map<String, Object?> toDeterministicMap() => {
        'toolId': toolId.value,
        'arguments': arguments,
        'context': context.toDeterministicMap(),
        'requestedCapability': requestedCapability?.name,
      };
}

/// Response from a tool invocation.
class AssistantToolResponse {
  const AssistantToolResponse({
    required this.request,
    required this.result,
    this.metadata = const AssistantToolExecutionMetadata(),
  });

  final AssistantToolRequest request;
  final AssistantToolResult result;
  final AssistantToolExecutionMetadata metadata;

  bool get isSuccess => result.isSuccess;

  Map<String, Object?> toDeterministicMap() => {
        'request': request.toDeterministicMap(),
        'result': result.toDeterministicMap(),
        'metadata': metadata.toDeterministicMap(),
      };
}

/// Execution record (observability / audit contract).
class AssistantToolExecution {
  const AssistantToolExecution({
    required this.toolId,
    required this.status,
    required this.timestamp,
    this.correlationId,
    this.latencyMs,
    this.errorCode,
    this.permission,
    this.confidence,
  });

  final AssistantToolId toolId;
  final AssistantToolExecutionStatus status;
  final DateTime timestamp;
  final String? correlationId;
  final int? latencyMs;
  final String? errorCode;
  final AssistantToolPermission? permission;
  final double? confidence;

  Map<String, Object?> toDeterministicMap() => {
        'toolId': toolId.value,
        'status': status.name,
        'timestamp': timestamp.toUtc().toIso8601String(),
        'correlationId': correlationId,
        'latencyMs': latencyMs,
        'errorCode': errorCode,
        'permission': permission?.name,
        'confidence': confidence,
      };
}

/// Observability sink (contracts only — no logger).
abstract class AssistantToolObserver {
  void record(AssistantToolExecution execution);
}

class NoopAssistantToolObserver implements AssistantToolObserver {
  const NoopAssistantToolObserver();

  @override
  void record(AssistantToolExecution execution) {}
}

class CollectingAssistantToolObserver implements AssistantToolObserver {
  CollectingAssistantToolObserver();

  final List<AssistantToolExecution> records = [];

  @override
  void record(AssistantToolExecution execution) {
    records.add(execution);
  }
}
