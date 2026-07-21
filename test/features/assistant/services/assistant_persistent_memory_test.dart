import 'package:eventpro/features/assistant/domain/memory/assistant_memory_entry.dart';
import 'package:eventpro/features/assistant/domain/memory/assistant_memory_id.dart';
import 'package:eventpro/features/assistant/domain/memory/assistant_memory_keys.dart';
import 'package:eventpro/features/assistant/domain/memory/assistant_memory_metadata.dart';
import 'package:eventpro/features/assistant/domain/memory/assistant_memory_observer.dart';
import 'package:eventpro/features/assistant/domain/memory/assistant_memory_policy.dart';
import 'package:eventpro/features/assistant/domain/memory/assistant_memory_search.dart';
import 'package:eventpro/features/assistant/domain/memory/assistant_memory_type.dart';
import 'package:eventpro/features/assistant/domain/context/assistant_context_pipeline.dart';
import 'package:eventpro/features/assistant/domain/context/assistant_conversation_id.dart';
import 'package:eventpro/features/assistant/domain/context/assistant_conversation_metadata.dart';
import 'package:eventpro/features/assistant/models/assistant_context.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/local_assistant_context_pipeline.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_persistent_memory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-024 persistent memory engine', () {
    final now = DateTime.utc(2026, 7, 20, 21);
    DateTime clock() => now;

    AssistantMemoryEntry entry({
      String id = 'm1',
      String key = AssistantMemoryKeys.lastClient,
      String value = 'client-42',
      AssistantMemoryType type = AssistantMemoryType.entity,
      AssistantMemoryScope scope = AssistantMemoryScope.session,
      String? sessionId = 's-mem',
      double confidence = 0.9,
      int priority = 1,
      DateTime? expiresAt,
    }) {
      return AssistantMemoryEntry(
        id: AssistantMemoryId(id),
        type: type,
        scope: scope,
        key: key,
        value: value,
        metadata: AssistantMemoryMetadata(
          origin: 'test',
          reason: 'fixture',
          sessionId: sessionId,
          confidence: confidence,
          priority: priority,
          expiresAt: expiresAt,
        ),
        createdAt: now,
        updatedAt: now,
      );
    }

    test('remember / find / search / update / archive / forget', () async {
      final observer = CollectingAssistantMemoryObserver();
      final memory = LocalAssistantPersistentMemory(
        clock: clock,
        observer: observer,
      );

      final stored = await memory.remember(entry());
      expect(stored.key, AssistantMemoryKeys.lastClient);
      expect(await memory.find(stored.id), isNotNull);

      final found = await memory.search(
        const AssistantMemorySearch(
          keys: [AssistantMemoryKeys.lastClient],
          sessionId: 's-mem',
        ),
      );
      expect(found.entries, hasLength(1));
      expect(found.entries.first.value, 'client-42');

      final updated = await memory.update(
        stored.copyWith(value: 'client-99', updatedAt: now),
      );
      expect(updated?.value, 'client-99');

      final archived = await memory.archive(stored.id);
      expect(archived?.status, AssistantMemoryStatus.archived);

      final active = await memory.search(
        const AssistantMemorySearch(keys: [AssistantMemoryKeys.lastClient]),
      );
      expect(active.isEmpty, isTrue);

      final withArchived = await memory.list(includeArchived: true);
      expect(withArchived.entries, hasLength(1));

      expect(await memory.forget(stored.id), isTrue);
      expect(observer.records, isNotEmpty);
      expect(
        observer.records.map((r) => r.operation),
        containsAll(['remember', 'update', 'archive', 'forget']),
      );
    });

    test('replace same key keeps single active entry', () async {
      final memory = LocalAssistantPersistentMemory(clock: clock);
      await memory.remember(entry(id: 'a', value: 'v1'));
      await memory.remember(entry(id: 'b', value: 'v2'));
      final listed = await memory.list();
      expect(listed.entries, hasLength(1));
      expect(listed.entries.first.value, 'v2');
      expect(listed.entries.first.id.value, 'a');
    });

    test('policy expiration archives on search', () async {
      final memory = LocalAssistantPersistentMemory(
        clock: clock,
        policy: const AssistantMemoryPolicy(
          defaultTtl: Duration(hours: 1),
          archiveOnExpire: true,
          minRetention: Duration.zero,
        ),
      );
      await memory.remember(
        entry(
          expiresAt: now.subtract(const Duration(minutes: 1)),
        ),
      );
      final result = await memory.search(
        const AssistantMemorySearch(keys: [AssistantMemoryKeys.lastClient]),
      );
      expect(result.isEmpty, isTrue);
      final archived = await memory.list(includeArchived: true);
      expect(archived.entries.first.status, AssistantMemoryStatus.archived);
    });

    test('well-known keys profiles cover CP-5 retrieval set', () {
      expect(AssistantMemoryKeyProfile.profiles, hasLength(8));
      expect(
        AssistantMemoryKeyProfile.profiles.map((p) => p.key),
        containsAll([
          AssistantMemoryKeys.lastClient,
          AssistantMemoryKeys.lastQuote,
          AssistantMemoryKeys.lastEvent,
          AssistantMemoryKeys.lastSupplier,
          AssistantMemoryKeys.lastDecision,
          AssistantMemoryKeys.lastWorkflow,
          AssistantMemoryKeys.lastCapability,
          AssistantMemoryKeys.lastEntity,
        ]),
      );
    });

    test('context pipeline injects persistent memory hints opt-in', () async {
      final memory = LocalAssistantPersistentMemory(clock: clock);
      await memory.rememberLast(
        key: AssistantMemoryKeys.lastQuote,
        value: 'quote-7',
        type: AssistantMemoryType.business,
        scope: AssistantMemoryScope.session,
        metadata: const AssistantMemoryMetadata(
          sessionId: 's-ctx',
          confidence: 0.8,
          origin: 'test',
        ),
      );

      final pipeline = LocalAssistantContextPipeline(
        persistentMemory: memory,
      );
      final result = pipeline.run(
        AssistantContextPipelineRequest(
          conversationId: const AssistantConversationId('s-ctx'),
          requestId: 'req-1',
          now: now,
          metadata: const AssistantConversationMetadata(sessionId: 's-ctx'),
        ),
      );

      expect(
        result.executionContext.traceHints
            .any((h) => h.startsWith('persistentMemory:')),
        isTrue,
      );
      expect(
        result.executionContext.traceHints
            .any((h) => h.contains('last.quote:quote-7')),
        isTrue,
      );
    });

    test('context pipeline without memory keeps prior behavior', () {
      final pipeline = LocalAssistantContextPipeline();
      final result = pipeline.run(
        AssistantContextPipelineRequest(
          conversationId: const AssistantConversationId('c1'),
          requestId: 'req-2',
          now: now,
        ),
      );
      expect(
        result.executionContext.traceHints
            .any((h) => h.startsWith('persistentMemory:')),
        isFalse,
      );
    });

    test('orchestrator opt-in propagates memory hints', () async {
      final memory = LocalAssistantPersistentMemory(clock: clock);
      await memory.rememberLast(
        key: AssistantMemoryKeys.lastClient,
        value: 'cli-1',
        type: AssistantMemoryType.entity,
        scope: AssistantMemoryScope.session,
        metadata: const AssistantMemoryMetadata(
          sessionId: 's-orch',
          confidence: 1.0,
          origin: 'test',
        ),
      );

      final orch = LocalAssistantOrchestrator(
        clock: clock,
        capabilities: AssistantCapabilities.localPersistentMemory(),
        persistentMemory: memory,
      );

      final response = await orch.handle(
        AssistantRequest(
          id: 'req-orch',
          rawText: 'oi',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
          context: const AssistantContext(sessionId: 's-orch'),
        ),
      );

      // Default reply path still works; memory must not break pipeline.
      expect(response.friendlyMessage, isNotEmpty);
    });

    test('policy evaluator maps expiration and replacement', () {
      final evaluator = const AssistantMemoryPolicyEvaluator(
        policy: AssistantMemoryPolicy(
          defaultTtl: Duration(days: 1),
          archiveOnExpire: true,
          replaceSameKey: true,
          minRetention: Duration.zero,
        ),
      );
      final expired = entry(
        expiresAt: now.subtract(const Duration(seconds: 1)),
      );
      expect(
        evaluator.evaluateExpiration(expired, now: now).action,
        AssistantMemoryPolicyAction.archive,
      );
      expect(
        evaluator
            .evaluateReplacement(existing: expired, incoming: entry(id: 'x'))
            .action,
        AssistantMemoryPolicyAction.replace,
      );
      expect(
        evaluator.evaluateCapacity(currentCount: 500).action,
        AssistantMemoryPolicyAction.evict,
      );
    });

    test('capability factory enables persistent memory + context engine', () {
      final caps = AssistantCapabilities.localPersistentMemory();
      expect(caps.canUsePersistentMemory, isTrue);
      expect(caps.canUseContextEngine, isTrue);
      expect(AssistantCapabilities.localDefaults().canUsePersistentMemory,
          isFalse);
    });
  });
}
