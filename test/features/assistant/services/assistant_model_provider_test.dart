import 'package:eventpro/features/assistant/domain/model_provider/assistant_model.dart';
import 'package:eventpro/features/assistant/domain/model_provider/assistant_model_message.dart';
import 'package:eventpro/features/assistant/domain/model_provider/assistant_model_provider_port.dart';
import 'package:eventpro/features/assistant/domain/model_provider/assistant_model_role.dart';
import 'package:eventpro/features/assistant/domain/model_provider/assistant_provider_registry.dart';
import 'package:eventpro/features/assistant/models/assistant_context.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_provider_registry.dart';
import 'package:eventpro/features/assistant/services/local_assistant_provider_selector.dart';
import 'package:eventpro/features/assistant/services/local_mock_model_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-025 model provider abstraction', () {
    final now = DateTime.utc(2026, 7, 20, 22);
    DateTime clock() => now;

    test('mock complete / stream / tokens / health are deterministic', () async {
      final observer = CollectingAssistantModelProviderObserver();
      final mock = LocalMockProvider(clock: clock, observer: observer);

      final request = AssistantModelRequest(
        messages: const [
          AssistantModelMessage(
            role: AssistantModelRole.user,
            content: 'criar orçamento',
          ),
        ],
      );

      final response = await mock.complete(request);
      expect(response.isSuccess, isTrue);
      expect(response.content, 'mock:echo:criar orçamento');
      expect(response.providerId, LocalMockProvider.defaultProviderId);
      expect(response.usage.totalTokens, greaterThan(0));

      final streamed = await mock.stream(request).toList();
      expect(streamed, hasLength(1));
      expect(streamed.first.content, response.content);

      expect(await mock.countTokens(request), greaterThan(0));
      expect(mock.supportsJson(), isTrue);
      expect(mock.supportsVision(), isFalse);
      expect(mock.supportsAudio(), isFalse);
      expect(mock.supportsTools(), isFalse);

      final health = await mock.health();
      expect(health.isHealthy, isTrue);
      expect(observer.records.map((r) => r.operation), contains('complete'));
    });

    test('registry register / default / find / list / unregister', () {
      final registry = LocalAssistantProviderRegistry();
      final mock = LocalMockProvider(clock: clock);
      registry.register(LocalMockProvider.registration(port: mock));

      expect(registry.defaultProviderId, LocalMockProvider.defaultProviderId);
      expect(registry.findPort(LocalMockProvider.defaultProviderId), same(mock));
      expect(registry.listProviders(), hasLength(1));

      registry.register(
        LocalMockProvider.registration(
          port: LocalMockProvider(
            providerId: 'local.mock.b',
            clock: clock,
          ),
          priority: 10,
        ),
      );
      registry.setDefault('local.mock.b');
      expect(registry.defaultProviderId, 'local.mock.b');

      registry.unregister('local.mock.b');
      expect(registry.find('local.mock.b'), isNull);
      expect(registry.defaultProviderId, LocalMockProvider.defaultProviderId);
    });

    test('selector prefers id, then name, then priority, then fallback', () {
      final registry = LocalAssistantProviderRegistry();
      final selector = const LocalAssistantProviderSelector();

      registry.register(
        LocalMockProvider.registration(
          port: LocalMockProvider(providerId: 'low', clock: clock),
          priority: 1,
        ),
      );
      registry.register(
        AssistantProviderRegistration(
          provider: LocalMockProvider.descriptor(
            id: 'high',
            name: 'High Priority Mock',
            priority: 50,
          ),
          port: LocalMockProvider(providerId: 'high', clock: clock),
        ),
      );
      registry.setDefault('low');

      expect(
        selector
            .select(
              registry: registry,
              criteria: const AssistantProviderSelectionCriteria(
                providerId: 'low',
              ),
            )
            ?.provider
            .id,
        'low',
      );

      expect(
        selector
            .select(
              registry: registry,
              criteria: const AssistantProviderSelectionCriteria(
                name: 'High Priority Mock',
              ),
            )
            ?.provider
            .id,
        'high',
      );

      expect(
        selector
            .select(
              registry: registry,
              criteria: const AssistantProviderSelectionCriteria(
                requiredCapabilities: {AssistantModelCapability.text},
              ),
            )
            ?.provider
            .id,
        'high',
      );

      expect(
        selector
            .select(
              registry: registry,
              criteria: const AssistantProviderSelectionCriteria(
                requiredCapabilities: {AssistantModelCapability.vision},
                allowFallback: true,
              ),
            )
            ?.reason,
        'default_fallback',
      );
    });

    test('json mode returns deterministic payload', () async {
      final mock = LocalMockProvider(clock: clock);
      final response = await mock.complete(
        const AssistantModelRequest(
          messages: [
            AssistantModelMessage(
              role: AssistantModelRole.user,
              content: 'hello',
            ),
          ],
          jsonMode: true,
        ),
      );
      expect(response.content, contains('"echo":"hello"'));
      expect(response.content, contains('"provider":"local.mock"'));
    });

    test('orchestrator opt-in injects model provider hints', () async {
      final orch = LocalAssistantOrchestrator(
        clock: clock,
        capabilities: AssistantCapabilities.localModelProvider(),
      );

      final response = await orch.handle(
        AssistantRequest(
          id: 'req-mp',
          rawText: 'oi',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
          context: const AssistantContext(sessionId: 's-mp'),
        ),
      );

      expect(response.friendlyMessage, isNotEmpty);
      expect(orch.providerRegistry.list(), isNotEmpty);
    });

    test('default capabilities keep model provider off', () {
      expect(
        AssistantCapabilities.localDefaults().canUseModelProvider,
        isFalse,
      );
      expect(
        AssistantCapabilities.localModelProvider().canUseModelProvider,
        isTrue,
      );
    });

    test('observation contract maps latency tokens provider model', () {
      final obs = AssistantModelProviderObservation(
        operation: 'complete',
        providerId: 'local.mock',
        modelId: 'mock-text-v1',
        timestamp: now,
        latencyMs: 2,
        usage: const AssistantModelUsage(
          promptTokens: 4,
          completionTokens: 3,
          totalTokens: 7,
          estimatedCostUsd: 0,
        ),
        capabilities: const {AssistantModelCapability.text},
        estimatedCostUsd: 0,
      );
      final map = obs.toDeterministicMap();
      expect(map['providerId'], 'local.mock');
      expect(map['latencyMs'], 2);
      expect(map['estimatedCostUsd'], 0);
    });
  });
}
