import '../domain/model_provider/assistant_model.dart';
import '../domain/model_provider/assistant_model_message.dart';
import '../domain/model_provider/assistant_model_provider.dart';
import '../domain/model_provider/assistant_model_provider_port.dart';
import '../domain/model_provider/assistant_provider_registry.dart';

/// Deterministic mock model provider (AI-025 CP-6).
///
/// No LLM. No HTTP. No SDKs. Validates architecture only.
class LocalMockProvider implements AssistantModelProviderPort {
  LocalMockProvider({
    this.providerId = defaultProviderId,
    this.modelId = defaultModelId,
    AssistantModelProviderObserver? observer,
    DateTime Function()? clock,
    String Function()? idFactory,
  })  : _observer = observer ?? const NoopAssistantModelProviderObserver(),
        _clock = clock ?? DateTime.now,
        _idFactory = idFactory ?? _defaultIdFactory;

  static const defaultProviderId = 'local.mock';
  static const defaultModelId = 'mock-text-v1';
  static const defaultProviderName = 'Local Mock';

  final String providerId;
  final String modelId;
  final AssistantModelProviderObserver _observer;
  final DateTime Function() _clock;
  final String Function() _idFactory;

  static String _defaultIdFactory() =>
      'mock-${DateTime.now().toUtc().microsecondsSinceEpoch}';

  /// Descriptor for registry registration.
  static AssistantModelProvider descriptor({
    String id = defaultProviderId,
    String name = defaultProviderName,
    int priority = 0,
  }) {
    return AssistantModelProvider(
      id: id,
      name: name,
      priority: priority,
      capabilities: AssistantModelCapabilities.mockDefaults,
      defaultModelId: defaultModelId,
      models: const [
        AssistantModel(
          id: defaultModelId,
          name: 'Mock Text v1',
          capabilities: AssistantModelCapabilities.mockDefaults,
          contextWindowTokens: 8192,
        ),
      ],
      metadata: const AssistantModelMetadata(
        origin: 'ai-025',
        notes: 'Deterministic mock — no inference',
      ),
    );
  }

  /// Ready-to-register binding.
  static AssistantProviderRegistration registration({
    LocalMockProvider? port,
    int priority = 0,
  }) {
    final resolved = port ?? LocalMockProvider();
    return AssistantProviderRegistration(
      provider: descriptor(
        id: resolved.providerId,
        priority: priority,
      ),
      port: resolved,
    );
  }

  @override
  Future<AssistantModelResponse> complete(
    AssistantModelRequest request,
  ) async {
    final started = _clock().toUtc();
    final tokens = _estimateTokens(request);
    final content = _deterministicContent(request);
    final usage = AssistantModelUsage(
      promptTokens: tokens,
      completionTokens: content.length ~/ 4 + 1,
      totalTokens: tokens + content.length ~/ 4 + 1,
      estimatedCostUsd: 0,
    );
    final response = AssistantModelResponse(
      id: _idFactory(),
      providerId: providerId,
      modelId: request.modelId ?? modelId,
      content: content,
      createdAt: started,
      usage: usage,
      finishReason: 'stop',
      metadata: request.metadata,
    );
    final ended = _clock().toUtc();
    _observer.record(
      AssistantModelProviderObservation(
        operation: 'complete',
        providerId: providerId,
        modelId: response.modelId,
        timestamp: ended,
        latencyMs: ended.difference(started).inMilliseconds,
        usage: usage,
        capabilities: AssistantModelCapabilities.mockDefaults.capabilities,
        estimatedCostUsd: 0,
        success: true,
      ),
    );
    return response;
  }

  @override
  Stream<AssistantModelResponse> stream(AssistantModelRequest request) async* {
    final full = await complete(request);
    yield full;
    _observer.record(
      AssistantModelProviderObservation(
        operation: 'stream',
        providerId: providerId,
        modelId: full.modelId,
        timestamp: _clock().toUtc(),
        usage: full.usage,
        capabilities: AssistantModelCapabilities.mockDefaults.capabilities,
        estimatedCostUsd: 0,
        success: true,
        details: const ['single_chunk'],
      ),
    );
  }

  @override
  Future<int> countTokens(AssistantModelRequest request) async {
    return _estimateTokens(request);
  }

  @override
  bool supportsVision() => false;

  @override
  bool supportsAudio() => false;

  @override
  bool supportsTools() => false;

  @override
  bool supportsJson() => true;

  @override
  Future<AssistantModelProviderHealth> health() async {
    return AssistantModelProviderHealth(
      status: AssistantModelProviderHealthStatus.healthy,
      checkedAt: _clock().toUtc(),
      message: 'local.mock ready',
    );
  }

  int _estimateTokens(AssistantModelRequest request) {
    var chars = 0;
    for (final m in request.messages) {
      chars += m.content.length;
    }
    return (chars / 4).ceil().clamp(1, 100000);
  }

  String _deterministicContent(AssistantModelRequest request) {
    final user = request.lastUserText.trim();
    if (request.jsonMode) {
      return '{"echo":${_jsonString(user)},"provider":"$providerId","model":"$modelId"}';
    }
    if (user.isEmpty) {
      return 'mock:ok';
    }
    return 'mock:echo:$user';
  }

  String _jsonString(String value) {
    final escaped = value
        .replaceAll(r'\', r'\\')
        .replaceAll('"', r'\"')
        .replaceAll('\n', r'\n');
    return '"$escaped"';
  }
}
