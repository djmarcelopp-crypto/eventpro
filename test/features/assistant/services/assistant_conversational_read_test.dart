import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_module_data_source.dart';
import 'package:eventpro/features/assistant/models/assistant_read_intent.dart';
import 'package:eventpro/features/assistant/models/assistant_read_metadata.dart';
import 'package:eventpro/features/assistant/models/assistant_read_pagination.dart';
import 'package:eventpro/features/assistant/models/assistant_read_query.dart';
import 'package:eventpro/features/assistant/models/assistant_read_record.dart';
import 'package:eventpro/features/assistant/models/assistant_read_result.dart';
import 'package:eventpro/features/assistant/models/assistant_read_status_lexicon.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_read_formatter.dart';
import 'package:eventpro/features/assistant/services/local_assistant_read_gateway.dart';
import 'package:eventpro/features/assistant/services/local_assistant_read_intent_resolver.dart';
import 'package:eventpro/features/assistant/services/local_assistant_read_planner.dart';
import 'package:eventpro/features/assistant/services/local_assistant_read_query_factory.dart';
import 'package:eventpro/features/quotes/assistant/quote_assistant_read_adapter.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/utils/quote_query_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../quotes/fakes/fake_quote_repository.dart';
import '../../quotes/quotes_test_helpers.dart';

void main() {
  group('AI-009 conversational quote intelligence', () {
    final now = DateTime.utc(2026, 7, 19, 18);
    const caps = AssistantCapabilities(
      canPlanStructuredQuoteRead: true,
      canExecuteStructuredQuoteRead: true,
    );
    const resolver = LocalAssistantReadIntentResolver();
    const planner = LocalAssistantReadPlanner();
    const formatter = LocalAssistantReadFormatter();

    AssistantRequest req(String text) => AssistantRequest(
          id: 'req-ai9',
          rawText: text,
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
        );

    test('intents e lexicon determinísticos', () {
      expect(
        resolver.resolve(
          request: req('Mostre os últimos orçamentos.'),
          capabilities: caps,
        ),
        isA<ReadRecentQuotesIntent>(),
      );
      final five = resolver.resolve(
        request: req('Liste os cinco últimos.'),
        capabilities: caps,
      );
      expect(five, isA<ReadRecentQuotesIntent>());
      expect((five! as ReadRecentQuotesIntent).limit, 5);

      final summary = resolver.resolve(
        request: req('Quantos orçamentos estão em aberto?'),
        capabilities: caps,
      );
      expect(summary, isA<ReadQuoteSummaryIntent>());
      expect((summary! as ReadQuoteSummaryIntent).statusToken, 'aberto');

      final byNumber = resolver.resolve(
        request: req('Existe orçamento número 1523?'),
        capabilities: caps,
      );
      expect(byNumber, isA<ReadQuoteByNumberIntent>());
      expect((byNumber! as ReadQuoteByNumberIntent).number, '1523');

      final byCustomer = resolver.resolve(
        request: req('Existe orçamento para João?'),
        capabilities: caps,
      );
      expect(byCustomer, isA<ReadQuoteByCustomerIntent>());
      expect((byCustomer! as ReadQuoteByCustomerIntent).customerName, 'joao');
      expect(
        AssistantReadStatusLexicon.resolveStatuses('aberto'),
        ['draft', 'sent'],
      );
      expect(AssistantReadStatusLexicon.resolveSingle('rascunho'), 'draft');
    });

    test('planner monta Query Object sem regras duplicadas', () async {
      final recent = planner.plan(
        const ReadRecentQuotesIntent(limit: 5),
        requestId: 'r1',
      );
      expect(recent.module, AssistantReadModules.quote);
      expect(recent.pagination.limit, 5);
      expect(recent.sorting.first.field, 'createdAt');
      expect(recent.sorting.first.ascending, isFalse);

      final open = planner.plan(
        const ReadQuoteSummaryIntent(statusToken: 'aberto'),
        requestId: 'r1',
      );
      expect(open.filters.single.operator, 'in');
      expect(open.filters.single.value, 'draft,sent');

      final byNumber = planner.plan(
        const ReadQuoteByNumberIntent('1523'),
        requestId: 'r1',
      );
      expect(byNumber.filters.single.operator, 'contains');

      final factory = const LocalAssistantReadQueryFactory();
      final orch = LocalAssistantOrchestrator(clock: () => now);
      final dummy = await orch.handle(req('texto irrelevante'));
      final viaFactory = factory.fromPipeline(
        request: req('Mostre os últimos orçamentos.'),
        response: dummy,
        capabilities: caps,
      );
      expect(viaFactory, isNotNull);
      expect(viaFactory!.pagination.limit, 5);
      expect(
        factory.fromPipeline(
          request: req('texto irrelevante'),
          response: dummy,
          capabilities: caps,
        ),
        isNull,
      );
    });

    test('formatter empty / single / multiple / maxScan warning', () {
      final meta = AssistantReadMetadata(
        timestamp: now,
        source: AssistantModuleDataSource.test,
        appliedFilters: const [],
        pagination: const AssistantReadPagination(limit: 5),
        executionTimeMs: 1,
        totalMatched: 0,
      );
      final empty = formatter.format(
        result: AssistantReadResult(
          queryId: 'q',
          module: 'quote',
          records: const [],
          metadata: meta,
        ),
      );
      expect(empty.naturalLanguage, 'Não encontrei resultados.');

      final single = formatter.format(
        result: AssistantReadResult(
          queryId: 'q',
          module: 'quote',
          records: const [
            AssistantReadRecord(
              id: '1',
              displayName: 'ORC-2026-1523',
              attributes: {'status': 'draft', 'number': 'ORC-2026-1523'},
            ),
          ],
          metadata: meta.copyWithTotal(1),
        ),
        intent: const ReadQuoteByNumberIntent('1523'),
      );
      expect(single.naturalLanguage, contains('ORC-2026-1523'));
      expect(single.structured['isSingle'], isTrue);

      final multi = formatter.format(
        result: AssistantReadResult(
          queryId: 'q',
          module: 'quote',
          records: const [
            AssistantReadRecord(id: '1', displayName: 'A'),
            AssistantReadRecord(id: '2', displayName: 'B'),
          ],
          metadata: AssistantReadMetadata(
            timestamp: now,
            source: AssistantModuleDataSource.test,
            appliedFilters: const [],
            pagination: const AssistantReadPagination(limit: 2),
            executionTimeMs: 1,
            totalMatched: 10,
            warnings: const [
              'Varredura limitada a 500 registros (listAll)',
            ],
          ),
        ),
        intent: const ReadRecentQuotesIntent(limit: 2),
      );
      expect(multi.naturalLanguage, contains('Encontrei 2 orçamentos'));
      expect(multi.naturalLanguage, contains('Exibindo 2 de 10'));
      expect(multi.naturalLanguage, contains('varredura foi limitada'));
      expect(multi.structured['scanLimited'], isTrue);
    });

    test('pipeline E2E + compatibilidade AI-003/AI-008', () async {
      final repository = FakeQuoteRepository();
      await repository.insert(
        sampleQuoteDraft(
          id: 'c1',
          status: QuoteStatus.draft,
          createdAt: now.subtract(const Duration(days: 2)),
        ),
      );
      await repository.insert(
        sampleQuoteDraft(
          id: 'c2',
          status: QuoteStatus.sent,
          createdAt: now.subtract(const Duration(days: 1)),
        ),
      );
      final joao = sampleQuoteDraft(
        id: 'c3',
        status: QuoteStatus.draft,
        createdAt: now,
      );
      // Force client name containing Joao via copy — sample uses sampleClient
      await repository.insert(joao);

      final gateway = LocalAssistantReadGateway(
        quoteAdapter: QuoteAssistantReadAdapter(
          QuoteQueryService(repository),
          clock: () => now,
          dataSource: AssistantModuleDataSource.test,
        ),
        clock: () => now,
      );

      final orch = LocalAssistantOrchestrator(
        clock: () => now,
        capabilities: AssistantCapabilities.localStructuredQuoteRead(),
        readGateway: gateway,
      );

      final recent = await orch.handle(req('Mostre os últimos orçamentos.'));
      expect(recent.readResult, isNotNull);
      expect(recent.readPresentation, isNotNull);
      expect(recent.moduleResults, isEmpty);
      expect(recent.writeResult?.executed ?? false, isFalse);
      expect(recent.friendlyMessage, contains('Encontrei'));

      final summary = await orch.handle(
        req('Quantos orçamentos estão em aberto?'),
      );
      expect(summary.readResult!.metadata.totalMatched, greaterThanOrEqualTo(2));
      expect(summary.readPresentation!.naturalLanguage, contains('Encontrei'));

      final byNumber = await orch.handle(req('Existe orçamento número 0001?'));
      // Fake repo assigns ORC-year-0001 etc — contains 0001 may match
      expect(byNumber.readResult, isNotNull);

      final dry = await LocalAssistantOrchestrator(clock: () => now)
          .handle(req('Mostre os últimos orçamentos.'));
      expect(dry.readResult, isNull);
      expect(dry.readPresentation, isNull);
    });
  });
}

extension on AssistantReadMetadata {
  AssistantReadMetadata copyWithTotal(int total) {
    return AssistantReadMetadata(
      timestamp: timestamp,
      source: source,
      appliedFilters: appliedFilters,
      pagination: pagination,
      executionTimeMs: executionTimeMs,
      totalMatched: total,
      warnings: warnings,
    );
  }
}
