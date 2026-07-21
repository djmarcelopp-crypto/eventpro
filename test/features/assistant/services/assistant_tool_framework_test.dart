import 'package:eventpro/features/assistant/domain/context/assistant_turn_identity.dart';
import 'package:eventpro/features/assistant/domain/tools/assistant_tool.dart';
import 'package:eventpro/features/assistant/domain/tools/assistant_tool_port.dart';
import 'package:eventpro/features/assistant/domain/tools/assistant_tool_request.dart';
import 'package:eventpro/features/assistant/domain/tools/assistant_tool_types.dart';
import 'package:eventpro/features/assistant/models/assistant_context.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_tool_registry.dart';
import 'package:eventpro/features/assistant/services/local_assistant_tool_router.dart';
import 'package:eventpro/features/assistant/services/local_mock_tool_executor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-028 tool calling framework', () {
    final now = DateTime.utc(2026, 7, 21, 0, 10);
    DateTime clock() => now;

    test('contracts are immutable maps without side-effect fields', () {
      const tool = AssistantTool(
        id: AssistantToolId('findCustomer'),
        category: AssistantToolCategory.lookup,
        capabilities: {AssistantToolCapability.findCustomer},
        policy: AssistantToolPolicy(
          permissions: {AssistantToolPermission.read},
          risk: AssistantToolRisk.low,
        ),
      );
      expect(tool.toDeterministicMap()['category'], 'lookup');
      expect(tool.policy.permissions, contains(AssistantToolPermission.read));
    });

    test('registry register find list findByCapability defaultTools', () {
      final registry = LocalAssistantToolRegistry.withMockDefaults(clock: clock);
      expect(registry.list().length, LocalMockToolExecutor.catalog.length);
      expect(
        registry.find(const AssistantToolId('findCustomer')),
        isNotNull,
      );
      expect(
        registry
            .findByCapability(AssistantToolCapability.findQuote)
            .single
            .id
            .value,
        'findQuote',
      );
      expect(registry.defaultTools(), hasLength(7));
      registry.unregister(const AssistantToolId('findSupplier'));
      expect(registry.find(const AssistantToolId('findSupplier')), isNull);
    });

    test('router selects by capability priority and respects risk', () {
      final registry = LocalAssistantToolRegistry.withMockDefaults(clock: clock);
      const router = LocalAssistantToolRouter();
      final selected = router.select(
        registry: registry,
        criteria: const AssistantToolSelectionCriteria(
          capability: AssistantToolCapability.findCustomer,
        ),
      );
      expect(selected?.tool.id.value, 'findCustomer');
      expect(selected?.reason, 'capability_priority');

      final denied = router.select(
        registry: registry,
        criteria: const AssistantToolSelectionCriteria(
          capability: AssistantToolCapability.createReminder,
          maxRisk: AssistantToolRisk.low,
          allowFallback: false,
        ),
      );
      expect(denied, isNull);
    });

    test('mock executor returns deterministic lookup without state change',
        () async {
      final observer = CollectingAssistantToolObserver();
      final executor = LocalMockToolExecutor(clock: clock, observer: observer);
      final response = await executor.execute(
        const AssistantToolRequest(
          toolId: AssistantToolId('findCustomer'),
          arguments: {'query': 'Acme'},
          context: AssistantToolExecutionContext(correlationId: 'c1'),
        ),
      );
      expect(response.isSuccess, isTrue);
      expect(response.result.data['customerId'], 'cust-mock-1');
      expect(response.result.message, 'mock:customer:Acme');
      expect(observer.records.single.correlationId, 'c1');
    });

    test('validate catches missing params and unknown tools', () async {
      final executor = LocalMockToolExecutor(clock: clock);
      final missing = await executor.validate(
        const AssistantToolRequest(
          toolId: AssistantToolId('findEvent'),
          arguments: {},
        ),
      );
      expect(missing?.code, AssistantToolErrorCode.invalidParameters);

      final unknown = await executor.execute(
        const AssistantToolRequest(
          toolId: AssistantToolId('nope'),
        ),
      );
      expect(unknown.result.status, AssistantToolExecutionStatus.failed);
      expect(unknown.result.error?.code, AssistantToolErrorCode.unknownTool);
    });

    test('permissions and policy declared on write tools', () {
      final reminder = LocalMockToolExecutor.catalog
          .firstWhere((t) => t.id.value == 'createReminder');
      expect(
        reminder.policy.permissions,
        contains(AssistantToolPermission.write),
      );
      expect(reminder.policy.requiresConfirmation, isTrue);
      expect(reminder.policy.risk, AssistantToolRisk.medium);
    });

    test('flag OFF keeps default behavior', () async {
      final orch = LocalAssistantOrchestrator(
        clock: clock,
        capabilities: AssistantCapabilities.localDefaults(),
      );
      final response = await orch.handle(
        AssistantRequest(
          id: 'req-off',
          rawText: 'buscar cliente Acme',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
          context: const AssistantContext(sessionId: 's-off'),
        ),
      );
      expect(response.friendlyMessage, isNotEmpty);
      expect(orch.toolRegistry.list(), isEmpty);
    });

    test('flag ON injects tool hints and preserves identity', () async {
      final orch = LocalAssistantOrchestrator(
        clock: clock,
        capabilities: AssistantCapabilities.localToolFramework(),
      );
      final request = AssistantRequest(
        id: 'req-on',
        rawText: 'buscar cliente Acme',
        locale: 'pt_BR',
        timezone: 'America/Sao_Paulo',
        timestamp: now,
        origin: AssistantInputOrigin.typedText,
        context: const AssistantContext(sessionId: 's-on'),
      );
      final response = await orch.handle(request);
      expect(response.friendlyMessage, isNotEmpty);
      expect(response.requestId, 'req-on');
      expect(orch.toolRegistry.list(), isNotEmpty);

      final identity = AssistantTurnIdentity.resolve(request);
      expect(identity.sessionId, 's-on');
      expect(identity.conversationId, 's-on');
    });

    test('capability factory and enums', () {
      expect(
        AssistantCapabilities.localDefaults().canUseToolFramework,
        isFalse,
      );
      expect(
        AssistantCapabilities.localToolFramework().canUseToolFramework,
        isTrue,
      );
      expect(AssistantToolPermission.values, hasLength(5));
      expect(AssistantToolErrorCode.values.length, greaterThanOrEqualTo(7));
    });

    test('health and describe on port', () async {
      final executor = LocalMockToolExecutor(clock: clock);
      expect((await executor.health()).isHealthy, isTrue);
      expect(
        executor.describe(const AssistantToolId('findQuote'))?.category,
        AssistantToolCategory.lookup,
      );
      expect(executor.supports(AssistantToolCapability.findContract), isTrue);
    });
  });
}
