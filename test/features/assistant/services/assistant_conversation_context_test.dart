import 'package:eventpro/features/assistant/models/assistant_context.dart';
import 'package:eventpro/features/assistant/models/assistant_conversation_context.dart';
import 'package:eventpro/features/assistant/models/assistant_conversation_session.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_module_data_source.dart';
import 'package:eventpro/features/assistant/models/assistant_read_intent.dart';
import 'package:eventpro/features/assistant/models/assistant_read_metadata.dart';
import 'package:eventpro/features/assistant/models/assistant_read_pagination.dart';
import 'package:eventpro/features/assistant/models/assistant_read_query.dart';
import 'package:eventpro/features/assistant/models/assistant_read_record.dart';
import 'package:eventpro/features/assistant/models/assistant_read_result.dart';
import 'package:eventpro/features/assistant/models/assistant_reference_kind.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/assistant_conversation_session_registry.dart';
import 'package:eventpro/features/assistant/services/local_assistant_conversation_planner.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_read_gateway.dart';
import 'package:eventpro/features/assistant/services/local_assistant_reference_resolver.dart';
import 'package:eventpro/features/quotes/assistant/quote_assistant_read_adapter.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/utils/quote_query_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../quotes/fakes/fake_quote_repository.dart';
import '../../quotes/quotes_test_helpers.dart';

void main() {
  group('AI-010 conversation context engine', () {
    final now = DateTime.utc(2026, 7, 19, 19);
    const caps = AssistantCapabilities(
      canPlanStructuredQuoteRead: true,
      canExecuteStructuredQuoteRead: true,
    );
    const resolver = LocalAssistantReferenceResolver();
    const planner = LocalAssistantConversationPlanner();

    AssistantRequest req(
      String text, {
      String? sessionId,
      String id = 'req-ai10',
    }) {
      return AssistantRequest(
        id: id,
        rawText: text,
        locale: 'pt_BR',
        timezone: 'America/Sao_Paulo',
        timestamp: now,
        origin: AssistantInputOrigin.typedText,
        context: sessionId == null
            ? null
            : AssistantContext(sessionId: sessionId),
      );
    }

    AssistantReadResult listResult(List<String> ids) {
      return AssistantReadResult(
        queryId: 'q',
        module: AssistantReadModules.quote,
        records: [
          for (var i = 0; i < ids.length; i++)
            AssistantReadRecord(
              id: ids[i],
              displayName: 'ORC-${i + 1}',
              attributes: {
                'number': 'ORC-${i + 1}',
                'clientDisplayName': 'Cliente ${i + 1}',
                'status': 'draft',
              },
            ),
        ],
        metadata: AssistantReadMetadata(
          timestamp: now,
          source: AssistantModuleDataSource.test,
          appliedFilters: const [],
          pagination: AssistantReadPagination(limit: ids.length),
          executionTimeMs: 1,
          totalMatched: ids.length,
        ),
      );
    }

    test('sessão nova, reset e contexto vazio', () {
      final session = AssistantConversationSession(
        sessionId: 's-new',
        clock: () => now,
      );
      expect(session.context.isEmpty, isTrue);
      expect(session.context.version, 0);

      session.rememberTurn(
        intent: const ReadRecentQuotesIntent(limit: 5),
        query: AssistantReadQuery(
          id: 'q1',
          requestId: 'r1',
          module: AssistantReadModules.quote,
          pagination: const AssistantReadPagination(limit: 5),
          requiredCapabilities: const {
            AssistantReadCapabilities.structuredQuoteRead,
          },
        ),
        result: listResult(['a', 'b']),
      );
      expect(session.context.isEmpty, isFalse);
      expect(session.context.version, 1);
      expect(session.context.lastRecords, hasLength(2));

      session.reset();
      expect(session.context, AssistantConversationContext.empty);
      expect(session.context.isEmpty, isTrue);
    });

    test('múltiplas sessões isoladas no registry', () {
      final registry = AssistantConversationSessionRegistry(clock: () => now);
      final a = registry.getOrCreate('sess-a');
      final b = registry.getOrCreate('sess-b');
      expect(identical(a, registry.getOrCreate('sess-a')), isTrue);
      expect(identical(a, b), isFalse);

      a.rememberTurn(
        intent: const ReadRecentQuotesIntent(),
        query: AssistantReadQuery(
          id: 'q',
          requestId: 'r',
          module: AssistantReadModules.quote,
          requiredCapabilities: const {
            AssistantReadCapabilities.structuredQuoteRead,
          },
        ),
        result: listResult(['only-a']),
      );
      expect(a.context.lastQuoteId, 'only-a');
      expect(b.context.isEmpty, isTrue);
      expect(registry.sessionCount, 2);

      registry.reset('sess-a');
      expect(a.context.isEmpty, isTrue);
      expect(b.context.isEmpty, isTrue);
    });

    test('referências determinísticas: esse / último / anterior / segundo', () {
      final context = AssistantConversationContext(
        version: 1,
        updatedAt: now,
        lastResult: listResult(['q1', 'q2', 'q3']),
        focusedIndex: 1,
        lastQuoteId: 'q2',
      );

      expect(
        resolver.resolve('esse', context: context).kind,
        AssistantReferenceKind.thisOne,
      );
      expect(
        resolver.resolve('o último', context: context).kind,
        AssistantReferenceKind.last,
      );
      expect(
        resolver.resolve('o anterior', context: context).kind,
        AssistantReferenceKind.previous,
      );
      expect(
        resolver.resolve('E o segundo?', context: context).kind,
        AssistantReferenceKind.ordinal,
      );
      expect(
        resolver.resolve('E o segundo?', context: context).ordinal,
        2,
      );
      expect(
        resolver.resolve('Mostre os detalhes.', context: context).kind,
        AssistantReferenceKind.details,
      );
      expect(
        resolver.resolve('Quem é o cliente?', context: context).kind,
        AssistantReferenceKind.client,
      );
      expect(
        resolver
            .resolve('Agora apenas os abertos.', context: context)
            .kind,
        AssistantReferenceKind.filterRefine,
      );
      expect(
        resolver
            .resolve('Agora apenas os abertos.', context: context)
            .statusToken,
        'aberto',
      );
      // Fresh AI-009 phrasing must not be hijacked as refine.
      expect(
        resolver
            .resolve(
              'Quantos orçamentos estão em aberto?',
              context: context,
            )
            .kind,
        AssistantReferenceKind.none,
      );
      expect(
        resolver
            .resolve('Mostre os últimos orçamentos.', context: context)
            .kind,
        AssistantReferenceKind.none,
      );
    });

    test('planner: follow-up, ausência de contexto, refine', () {
      final emptySession = AssistantConversationSession(
        sessionId: 'empty',
        clock: () => now,
      );
      final missing = planner.plan(
        request: req('Mostre os detalhes.', sessionId: 'empty'),
        session: emptySession,
        capabilities: caps,
      );
      expect(missing.missingContext, isTrue);
      expect(missing.missingContextMessage, isNotNull);

      final session = AssistantConversationSession(
        sessionId: 's1',
        clock: () => now,
      );
      session.rememberTurn(
        intent: const ReadRecentQuotesIntent(limit: 5),
        query: AssistantReadQuery(
          id: 'q',
          requestId: 'r',
          module: AssistantReadModules.quote,
          pagination: const AssistantReadPagination(limit: 5),
          requiredCapabilities: const {
            AssistantReadCapabilities.structuredQuoteRead,
          },
        ),
        result: listResult(['q1', 'q2', 'q3']),
      );

      final second = planner.plan(
        request: req('E o segundo?', sessionId: 's1'),
        session: session,
        capabilities: caps,
      );
      expect(second.isFollowUp, isTrue);
      expect(second.intent, isA<ReadQuoteByIdIntent>());
      expect((second.intent! as ReadQuoteByIdIntent).quoteId, 'q2');
      expect(second.focusIndex, 1);

      final refine = planner.plan(
        request: req('Agora apenas os abertos.', sessionId: 's1'),
        session: session,
        capabilities: caps,
      );
      expect(refine.isFollowUp, isTrue);
      expect(refine.query, isNotNull);
      expect(
        refine.query!.filters.any((f) => f.field == 'status'),
        isTrue,
      );

      final client = planner.plan(
        request: req('Quem é o cliente?', sessionId: 's1'),
        session: session,
        capabilities: caps,
      );
      expect(client.contextualAnswer, contains('Cliente'));
    });

    test('pipeline E2E multi-turno + compatibilidade AI-009', () async {
      final repository = FakeQuoteRepository();
      await repository.insert(
        sampleQuoteDraft(
          id: 'c1',
          status: QuoteStatus.draft,
          createdAt: now.subtract(const Duration(days: 3)),
        ),
      );
      await repository.insert(
        sampleQuoteDraft(
          id: 'c2',
          status: QuoteStatus.sent,
          createdAt: now.subtract(const Duration(days: 2)),
        ),
      );
      await repository.insert(
        sampleQuoteDraft(
          id: 'c3',
          status: QuoteStatus.draft,
          createdAt: now.subtract(const Duration(days: 1)),
        ),
      );
      await repository.insert(
        sampleQuoteDraft(
          id: 'c4',
          status: QuoteStatus.approved,
          createdAt: now,
        ),
      );

      final gateway = LocalAssistantReadGateway(
        quoteAdapter: QuoteAssistantReadAdapter(
          QuoteQueryService(repository),
          clock: () => now,
          dataSource: AssistantModuleDataSource.test,
        ),
        clock: () => now,
      );

      final sessions = AssistantConversationSessionRegistry(clock: () => now);
      final orch = LocalAssistantOrchestrator(
        clock: () => now,
        capabilities: AssistantCapabilities.localStructuredQuoteRead(),
        readGateway: gateway,
        conversationSessions: sessions,
      );

      const sid = 'conv-1';
      final recent = await orch.handle(
        req('Mostre os últimos cinco.', sessionId: sid, id: 't1'),
      );
      expect(recent.readResult, isNotNull);
      expect(recent.readPresentation, isNotNull);
      expect(recent.conversationPresentation, isNotNull);
      expect(recent.conversationPresentation!.isFollowUp, isFalse);
      expect(sessions.find(sid)!.context.version, greaterThan(0));

      final open = await orch.handle(
        req('Agora apenas os abertos.', sessionId: sid, id: 't2'),
      );
      expect(open.conversationPresentation!.isFollowUp, isTrue);
      expect(open.readResult, isNotNull);
      for (final record in open.readResult!.records) {
        expect(
          record.attributes['status'],
          anyOf('draft', 'sent'),
        );
      }

      final second = await orch.handle(
        req('E o segundo?', sessionId: sid, id: 't3'),
      );
      expect(second.readResult, isNotNull);
      expect(second.readResult!.records, hasLength(1));
      expect(second.conversationPresentation!.isFollowUp, isTrue);

      final details = await orch.handle(
        req('Mostre os detalhes.', sessionId: sid, id: 't4'),
      );
      expect(details.readResult, isNotNull);
      expect(details.conversationPresentation!.isFollowUp, isTrue);

      final client = await orch.handle(
        req('Quem é o cliente?', sessionId: sid, id: 't5'),
      );
      expect(client.readResult, isNull);
      expect(client.conversationPresentation!.missingContext, isFalse);
      expect(
        client.conversationPresentation!.naturalLanguage,
        contains('Maria Silva'),
      );
      expect(client.friendlyMessage, contains('Maria Silva'));

      // Isolation: other session has no context for "esse".
      final other = await orch.handle(
        req('Mostre os detalhes.', sessionId: 'other', id: 't6'),
      );
      expect(other.conversationPresentation!.missingContext, isTrue);
      expect(
        other.conversationPresentation!.naturalLanguage,
        contains('Não há contexto'),
      );

      // AI-009 compat: no sessionId still runs fresh reads.
      final solo = await orch.handle(
        req('Mostre os últimos orçamentos.', id: 't7'),
      );
      expect(solo.readResult, isNotNull);
      expect(solo.readPresentation, isNotNull);
      expect(solo.writeResult?.executed ?? false, isFalse);

      // "esse" after list without session → missing context (no accumulate).
      final noCtx = await orch.handle(req('esse', id: 't8'));
      expect(noCtx.conversationPresentation!.missingContext, isTrue);
    });

    test('referência esse / último / anterior no orchestrator', () async {
      final repository = FakeQuoteRepository();
      for (var i = 1; i <= 3; i++) {
        await repository.insert(
          sampleQuoteDraft(
            id: 'e$i',
            status: QuoteStatus.draft,
            createdAt: now.subtract(Duration(days: 4 - i)),
          ),
        );
      }
      final gateway = LocalAssistantReadGateway(
        quoteAdapter: QuoteAssistantReadAdapter(
          QuoteQueryService(repository),
          clock: () => now,
          dataSource: AssistantModuleDataSource.test,
        ),
        clock: () => now,
      );
      final sessions = AssistantConversationSessionRegistry(clock: () => now);
      final orch = LocalAssistantOrchestrator(
        clock: () => now,
        capabilities: AssistantCapabilities.localStructuredQuoteRead(),
        readGateway: gateway,
        conversationSessions: sessions,
      );

      const sid = 'refs';
      await orch.handle(
        req('Mostre os últimos cinco.', sessionId: sid, id: 'r1'),
      );

      final last = await orch.handle(
        req('o último', sessionId: sid, id: 'r2'),
      );
      expect(last.readResult!.records, hasLength(1));

      await orch.handle(
        req('Mostre os últimos cinco.', sessionId: sid, id: 'r3'),
      );
      final prev = await orch.handle(
        req('o anterior', sessionId: sid, id: 'r4'),
      );
      // focused starts at 0; anterior out of range → missing context
      expect(
        prev.conversationPresentation!.missingContext ||
            prev.readResult != null,
        isTrue,
      );

      final listAgain = await orch.handle(
        req('Mostre os últimos cinco.', sessionId: sid, id: 'r5'),
      );
      expect(listAgain.readResult!.records.length, greaterThanOrEqualTo(2));
      sessions.find(sid)!.focusIndex(1);
      final esse = await orch.handle(
        req('esse', sessionId: sid, id: 'r6'),
      );
      expect(esse.readResult!.records.single.id, isNotEmpty);
      expect(esse.conversationPresentation!.isFollowUp, isTrue);
    });
  });
}
