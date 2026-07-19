import 'package:eventpro/features/assistant/models/assistant_context.dart';
import 'package:eventpro/features/assistant/models/assistant_insight_intent.dart';
import 'package:eventpro/features/assistant/models/assistant_insight_kind.dart';
import 'package:eventpro/features/assistant/models/assistant_insight_request.dart';
import 'package:eventpro/features/assistant/models/assistant_insight_warning.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_module_data_source.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/assistant_conversation_session_registry.dart';
import 'package:eventpro/features/assistant/services/local_assistant_insight_formatter.dart';
import 'package:eventpro/features/assistant/services/local_assistant_insight_gateway.dart';
import 'package:eventpro/features/assistant/services/local_assistant_insight_intent_resolver.dart';
import 'package:eventpro/features/assistant/services/local_assistant_insight_planner.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_read_gateway.dart';
import 'package:eventpro/features/quotes/assistant/quote_assistant_insight_adapter.dart';
import 'package:eventpro/features/quotes/assistant/quote_assistant_read_adapter.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/utils/quote_insight_service.dart';
import 'package:eventpro/features/quotes/utils/quote_query_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../quotes/fakes/fake_quote_repository.dart';
import '../../quotes/quotes_test_helpers.dart';

void main() {
  group('AI-011 quote insights engine', () {
    final now = DateTime.utc(2026, 7, 19, 20);
    const caps = AssistantCapabilities(
      canPlanQuoteInsights: true,
      canExecuteQuoteInsights: true,
    );
    const resolver = LocalAssistantInsightIntentResolver();
    const planner = LocalAssistantInsightPlanner();
    const formatter = LocalAssistantInsightFormatter();

    AssistantRequest req(String text, {String id = 'req-ai11'}) =>
        AssistantRequest(
          id: id,
          rawText: text,
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
        );

    test('planner traduz intents sem I/O', () {
      final count = planner.plan(
        const CountInsightIntent(statusToken: 'aberto'),
        requestId: 'r1',
      );
      expect(count.kind, AssistantInsightKind.count);
      expect(count.statusToken, 'aberto');
      expect(count.module, AssistantInsightModules.quote);
      expect(
        count.requiredCapabilities,
        contains(AssistantInsightCapabilities.quoteInsights),
      );

      final dist = planner.plan(
        const DistributionInsightIntent(),
        requestId: 'r1',
      );
      expect(dist.kind, AssistantInsightKind.distribution);
      expect(dist.groupBy, 'status');

      final top = planner.plan(const TopEntityInsightIntent(), requestId: 'r1');
      expect(top.kind, AssistantInsightKind.topEntity);

      final last = planner.plan(const LastCreatedInsightIntent(), requestId: 'r1');
      expect(last.kind, AssistantInsightKind.lastCreated);

      final month = planner.plan(
        const CreatedThisMonthInsightIntent(),
        requestId: 'r1',
        referenceTimestamp: now,
      );
      expect(month.kind, AssistantInsightKind.createdThisMonth);
      expect(month.referenceTimestamp, now);
    });

    test('intent resolver cobre kinds analíticos', () {
      expect(
        resolver.resolve(
          request: req('Quantos orçamentos existem?'),
          capabilities: caps,
        ),
        isA<CountInsightIntent>(),
      );
      expect(
        (resolver.resolve(
          request: req('Quantos estão em aberto?'),
          capabilities: caps,
        ) as CountInsightIntent)
            .statusToken,
        'aberto',
      );
      expect(
        (resolver.resolve(
          request: req('Quantos estão em rascunho?'),
          capabilities: caps,
        ) as CountInsightIntent)
            .statusToken,
        'rascunho',
      );
      expect(
        resolver.resolve(
          request: req('Existe concentração por status?'),
          capabilities: caps,
        ),
        isA<DistributionInsightIntent>(),
      );
      expect(
        resolver.resolve(
          request: req('Qual cliente possui mais orçamentos?'),
          capabilities: caps,
        ),
        isA<TopEntityInsightIntent>(),
      );
      expect(
        resolver.resolve(
          request: req('Qual foi o último orçamento?'),
          capabilities: caps,
        ),
        isA<LastCreatedInsightIntent>(),
      );
      expect(
        resolver.resolve(
          request: req('Quantos foram criados este mês?'),
          capabilities: caps,
        ),
        isA<CreatedThisMonthInsightIntent>(),
      );
      expect(
        resolver.resolve(
          request: req('Mostre os últimos orçamentos.'),
          capabilities: caps,
        ),
        isNull,
      );
      expect(
        resolver.resolve(
          request: req('Quantos orçamentos existem?'),
          capabilities: AssistantCapabilities.localDefaults(),
        ),
        isNull,
      );
    });

    test('service: contagem, distribuição, top, último, mês, vazio, maxScan',
        () async {
      final emptyService = QuoteInsightService(
        FakeQuoteRepository(),
        clock: () => now,
      );
      final empty = await emptyService.compute(
        planner.plan(const CountInsightIntent(), requestId: 'e'),
      );
      expect(empty.metrics.single.value, 0);
      expect(empty.summary.text, contains('Existem 0'));

      final repository = FakeQuoteRepository();
      await repository.insert(
        sampleQuoteDraft(
          id: 'a',
          status: QuoteStatus.draft,
          createdAt: DateTime.utc(2026, 7, 1),
        ).copyWith(
          clientSnapshot:
              QuoteClientSnapshot.fromClient(sampleClient(name: 'João')),
        ),
      );
      await repository.insert(
        sampleQuoteDraft(
          id: 'b',
          status: QuoteStatus.sent,
          createdAt: DateTime.utc(2026, 7, 10),
        ).copyWith(
          clientSnapshot:
              QuoteClientSnapshot.fromClient(sampleClient(name: 'João')),
        ),
      );
      await repository.insert(
        sampleQuoteDraft(
          id: 'c',
          status: QuoteStatus.approved,
          createdAt: DateTime.utc(2026, 6, 1),
        ).copyWith(
          clientSnapshot:
              QuoteClientSnapshot.fromClient(sampleClient(name: 'Maria')),
        ),
      );
      await repository.insert(
        sampleQuoteDraft(
          id: 'd',
          status: QuoteStatus.draft,
          createdAt: DateTime.utc(2026, 7, 18),
        ).copyWith(
          clientSnapshot:
              QuoteClientSnapshot.fromClient(sampleClient(name: 'João')),
        ),
      );

      final service = QuoteInsightService(repository, clock: () => now);

      final total = await service.compute(
        planner.plan(const CountInsightIntent(), requestId: 't'),
      );
      expect(total.metrics.single.value, 4);

      final open = await service.compute(
        planner.plan(
          const CountInsightIntent(statusToken: 'aberto'),
          requestId: 'o',
        ),
      );
      expect(open.metrics.single.value, 3);
      expect(open.summary.text, contains('aberto'));

      final draft = await service.compute(
        planner.plan(
          const CountInsightIntent(statusToken: 'rascunho'),
          requestId: 'd',
        ),
      );
      expect(draft.metrics.single.value, 2);

      final dist = await service.compute(
        planner.plan(const DistributionInsightIntent(), requestId: 'dist'),
      );
      expect(dist.dimensions, isNotEmpty);
      expect(
        dist.dimensions.firstWhere((d) => d.value == 'draft').count,
        2,
      );
      expect(dist.summary.text, contains('status'));

      final top = await service.compute(
        planner.plan(const TopEntityInsightIntent(), requestId: 'top'),
      );
      expect(top.summary.text, contains('João'));
      expect(top.summary.text, contains('3'));

      final last = await service.compute(
        planner.plan(const LastCreatedInsightIntent(), requestId: 'last'),
      );
      expect(last.insights.single.attributes['quoteId'], 'd');

      final month = await service.compute(
        planner.plan(
          const CreatedThisMonthInsightIntent(),
          requestId: 'm',
          referenceTimestamp: now,
        ),
      );
      expect(month.metrics.single.value, 3);

      final cappedRepo = FakeQuoteRepository();
      for (var i = 0; i < 5; i++) {
        await cappedRepo.insert(
          sampleQuoteDraft(
            id: 'cap-$i',
            status: QuoteStatus.draft,
            createdAt: now.subtract(Duration(days: i)),
          ),
        );
      }
      final cappedService = QuoteInsightService(
        cappedRepo,
        maxScan: 3,
        clock: () => now,
      );
      final capped = await cappedService.compute(
        planner.plan(const CountInsightIntent(), requestId: 'cap'),
      );
      expect(capped.scanCapped, isTrue);
      expect(capped.scannedCount, 3);
      expect(capped.metrics.single.value, 3);
      expect(
        capped.warnings.any((w) => w.code == AssistantInsightWarning.maxScanCode),
        isTrue,
      );
    });

    test('formatter NL + structured + warnings', () async {
      final repository = FakeQuoteRepository();
      await repository.insert(
        sampleQuoteDraft(id: '1', status: QuoteStatus.draft, createdAt: now),
      );
      final adapter = QuoteAssistantInsightAdapter(
        QuoteInsightService(repository, maxScan: 1, clock: () => now),
        clock: () => now,
        dataSource: AssistantModuleDataSource.test,
      );
      // Force cap warning with 2 quotes and maxScan 1
      await repository.insert(
        sampleQuoteDraft(
          id: '2',
          status: QuoteStatus.sent,
          createdAt: now.subtract(const Duration(days: 1)),
        ),
      );
      final result = await adapter.execute(
        planner.plan(const CountInsightIntent(), requestId: 'fmt'),
      );
      final presentation = formatter.format(result);
      expect(presentation.naturalLanguage, contains('orçamentos'));
      expect(presentation.naturalLanguage, contains('primeiros'));
      expect(presentation.structured['valid'], isTrue);
      expect(presentation.warnings, isNotEmpty);
    });

    test('pipeline E2E + compatibilidade AI-010', () async {
      final repository = FakeQuoteRepository();
      await repository.insert(
        sampleQuoteDraft(
          id: 'e1',
          status: QuoteStatus.draft,
          createdAt: now.subtract(const Duration(days: 2)),
        ).copyWith(
          clientSnapshot:
              QuoteClientSnapshot.fromClient(sampleClient(name: 'Ana')),
        ),
      );
      await repository.insert(
        sampleQuoteDraft(
          id: 'e2',
          status: QuoteStatus.sent,
          createdAt: now.subtract(const Duration(days: 1)),
        ).copyWith(
          clientSnapshot:
              QuoteClientSnapshot.fromClient(sampleClient(name: 'Ana')),
        ),
      );
      await repository.insert(
        sampleQuoteDraft(
          id: 'e3',
          status: QuoteStatus.approved,
          createdAt: now,
        ).copyWith(
          clientSnapshot:
              QuoteClientSnapshot.fromClient(sampleClient(name: 'Bruno')),
        ),
      );

      final insightGateway = LocalAssistantInsightGateway(
        quoteAdapter: QuoteAssistantInsightAdapter(
          QuoteInsightService(repository, clock: () => now),
          clock: () => now,
          dataSource: AssistantModuleDataSource.test,
        ),
        clock: () => now,
      );
      final readGateway = LocalAssistantReadGateway(
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
        capabilities: AssistantCapabilities.localQuoteInsights(),
        insightGateway: insightGateway,
        readGateway: readGateway,
        conversationSessions: sessions,
      );

      final count = await orch.handle(req('Quantos orçamentos existem?'));
      expect(count.insightResult, isNotNull);
      expect(count.insightPresentation, isNotNull);
      expect(count.readResult, isNull);
      expect(count.insightResult!.metrics.single.value, 3);
      expect(count.friendlyMessage, contains('Existem 3'));
      expect(count.writeResult?.executed ?? false, isFalse);

      final open = await orch.handle(req('Quantos estão em aberto?'));
      expect(open.insightPresentation!.naturalLanguage, contains('aberto'));

      final top = await orch.handle(
        req('Qual cliente possui mais orçamentos?'),
      );
      expect(top.insightPresentation!.naturalLanguage, contains('Ana'));

      final dist = await orch.handle(
        req('Existe concentração por status?'),
      );
      expect(dist.insightResult!.dimensions, isNotEmpty);

      final last = await orch.handle(req('Qual foi o último orçamento?'));
      expect(last.insightResult!.insights.single.attributes['quoteId'], 'e3');

      final month = await orch.handle(
        req('Quantos foram criados este mês?'),
      );
      expect(month.insightResult!.metrics.single.value, 3);

      // AI-010 conversation follow-up still works (not stolen by insights).
      const sid = 'ai11-conv';
      final recent = await orch.handle(
        AssistantRequest(
          id: 'c1',
          rawText: 'Mostre os últimos cinco.',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
          context: const AssistantContext(sessionId: sid),
        ),
      );
      expect(recent.readResult, isNotNull);
      expect(recent.insightResult, isNull);

      final details = await orch.handle(
        AssistantRequest(
          id: 'c2',
          rawText: 'Mostre os detalhes.',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
          context: const AssistantContext(sessionId: sid),
        ),
      );
      expect(details.conversationPresentation, isNotNull);
      expect(details.insightResult, isNull);
    });
  });
}
