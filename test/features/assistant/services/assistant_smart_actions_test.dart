import 'package:eventpro/features/assistant/models/assistant_action_intent.dart';
import 'package:eventpro/features/assistant/models/assistant_action_kind.dart';
import 'package:eventpro/features/assistant/models/assistant_action_request.dart';
import 'package:eventpro/features/assistant/models/assistant_action_target.dart';
import 'package:eventpro/features/assistant/models/assistant_action_warning.dart';
import 'package:eventpro/features/assistant/models/assistant_context.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_module_data_source.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/local_assistant_action_adapter.dart';
import 'package:eventpro/features/assistant/services/local_assistant_action_formatter.dart';
import 'package:eventpro/features/assistant/services/local_assistant_action_gateway.dart';
import 'package:eventpro/features/assistant/services/local_assistant_action_intent_resolver.dart';
import 'package:eventpro/features/assistant/services/local_assistant_action_planner.dart';
import 'package:eventpro/features/assistant/services/local_assistant_insight_gateway.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:eventpro/features/quotes/assistant/quote_assistant_insight_adapter.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/utils/quote_insight_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../quotes/fakes/fake_quote_repository.dart';
import '../../quotes/quotes_test_helpers.dart';

void main() {
  group('AI-012 smart action engine', () {
    final now = DateTime.utc(2026, 7, 19, 21);
    const caps = AssistantCapabilities(
      canPlanSmartActions: true,
      canExecuteSmartActions: true,
    );
    const resolver = LocalAssistantActionIntentResolver();
    const planner = LocalAssistantActionPlanner();
    const formatter = LocalAssistantActionFormatter();

    AssistantRequest req(
      String text, {
      String id = 'req-ai12',
      AssistantContext? context,
    }) {
      return AssistantRequest(
        id: id,
        rawText: text,
        locale: 'pt_BR',
        timezone: 'America/Sao_Paulo',
        timestamp: now,
        origin: AssistantInputOrigin.typedText,
        context: context,
      );
    }

    test('planner produz requests sem navegar', () {
      final quotes = planner.plan(
        const OpenQuotesActionIntent(),
        request: req('Abra orçamentos'),
      );
      expect(quotes.kind, AssistantActionKind.openQuotes);
      expect(quotes.target.routePath, '/quotes');
      expect(
        quotes.requiredCapabilities,
        contains(AssistantActionCapabilities.smartActions),
      );

      final dash = planner.plan(
        const OpenDashboardActionIntent(),
        request: req('dashboard'),
      );
      expect(dash.kind, AssistantActionKind.openDashboard);
      expect(dash.target.module, AssistantActionModules.dashboard);

      final settings = planner.plan(
        const OpenSettingsActionIntent(),
        request: req('config'),
      );
      expect(settings.target.routePath, '/settings');

      final last = planner.plan(
        const OpenLastQuoteActionIntent(quoteId: 'q-1', quoteLabel: 'ORC-1'),
        request: req('abrir', context: const AssistantContext(sessionId: 's')),
      );
      expect(last.kind, AssistantActionKind.openLastQuote);
      expect(last.target.entityId, 'q-1');
      expect(last.target.routePath, '/quotes/q-1');
      expect(last.sessionId, 's');
    });

    test('intent resolver cobre ações e ignora insights/reads', () {
      expect(
        resolver.resolve(
          request: req('Abra a tela de Orçamentos.'),
          capabilities: caps,
        ),
        isA<OpenQuotesActionIntent>(),
      );
      expect(
        resolver.resolve(
          request: req('Abra o dashboard.'),
          capabilities: caps,
        ),
        isA<OpenDashboardActionIntent>(),
      );
      expect(
        resolver.resolve(
          request: req('Abra configurações.'),
          capabilities: caps,
        ),
        isA<OpenSettingsActionIntent>(),
      );
      expect(
        resolver.resolve(
          request: req('Abra o último orçamento.'),
          capabilities: caps,
        ),
        isA<OpenLastQuoteActionIntent>(),
      );
      expect(
        resolver.resolve(
          request: req('Abra o cliente.'),
          capabilities: caps,
        ),
        isA<OpenClientActionIntent>(),
      );
      expect(
        resolver.resolve(
          request: req('Quantos orçamentos existem?'),
          capabilities: caps,
        ),
        isNull,
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
          request: req('Abra orçamentos.'),
          capabilities: AssistantCapabilities.localDefaults(),
        ),
        isNull,
      );
    });

    test('gateway + adapter: sucesso, alvo inexistente, desconhecida, idempotência',
        () async {
      final adapter = LocalAssistantActionAdapter(
        clock: () => now,
        knownEntityIds: {'quote-1', 'client-1'},
      );
      final gateway = LocalAssistantActionGateway(
        adapter: adapter,
        clock: () => now,
      );

      final openQuotes = await gateway.execute(
        planner.plan(
          const OpenQuotesActionIntent(),
          request: req('Abra orçamentos', id: 'a1'),
        ),
      );
      expect(openQuotes.valid, isTrue);
      expect(openQuotes.executed, isTrue);
      expect(openQuotes.summary, 'Abri a tela de Orçamentos.');
      expect(openQuotes.actions.single.target.routePath, '/quotes');

      final missing = await gateway.execute(
        planner.plan(
          const OpenLastQuoteActionIntent(),
          request: req('Abra o último', id: 'a2'),
        ),
      );
      expect(missing.valid, isFalse);
      expect(missing.executed, isFalse);
      expect(
        missing.warnings.any(
          (w) => w.code == AssistantActionWarning.missingTarget,
        ),
        isTrue,
      );

      final unknownEntity = await gateway.execute(
        planner.plan(
          const OpenLastQuoteActionIntent(quoteId: 'missing-id'),
          request: req('abrir', id: 'a3'),
        ),
      );
      expect(unknownEntity.valid, isFalse);
      expect(unknownEntity.failureMessage, contains('inexistente'));

      final unknown = await gateway.execute(
        AssistantActionRequest(
          id: 'u',
          requestId: 'a4',
          kind: AssistantActionKind.unknown,
          target: const AssistantActionTarget(module: 'x'),
          requiredCapabilities: const {
            AssistantActionCapabilities.smartActions,
          },
        ),
      );
      expect(unknown.valid, isFalse);
      expect(
        unknown.warnings.any(
          (w) => w.code == AssistantActionWarning.unknownAction,
        ),
        isTrue,
      );

      final first = await gateway.execute(
        planner.plan(
          const OpenDashboardActionIntent(),
          request: req('dashboard', id: 'idem'),
        ),
      );
      final second = await gateway.execute(
        planner.plan(
          const OpenDashboardActionIntent(),
          request: req('dashboard', id: 'idem'),
        ),
      );
      expect(first.executed, isTrue);
      expect(second.executed, isTrue);
      expect(second.metadata.idempotentReplay, isTrue);
      expect(
        second.warnings.any(
          (w) => w.code == AssistantActionWarning.idempotentReplay,
        ),
        isTrue,
      );

      final presentation = formatter.format(openQuotes);
      expect(presentation.naturalLanguage, contains('Orçamentos'));
      expect(presentation.structured['executed'], isTrue);
    });

    test('pipeline E2E + compatibilidade AI-011', () async {
      final repository = FakeQuoteRepository();
      await repository.insert(
        sampleQuoteDraft(
          id: 'iq1',
          status: QuoteStatus.draft,
          createdAt: now,
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

      final actionAdapter = LocalAssistantActionAdapter(
        clock: () => now,
        knownEntityIds: {'quote-42'},
      );
      final orch = LocalAssistantOrchestrator(
        clock: () => now,
        capabilities: AssistantCapabilities.localSmartActions(),
        insightGateway: insightGateway,
        actionGateway: LocalAssistantActionGateway(
          adapter: actionAdapter,
          clock: () => now,
        ),
      );

      final open = await orch.handle(req('Abra a tela de Orçamentos.'));
      expect(open.actionResult, isNotNull);
      expect(open.actionPresentation, isNotNull);
      expect(open.actionPresentation!.naturalLanguage, contains('Orçamentos'));
      expect(open.insightResult, isNull);
      expect(open.readResult, isNull);
      expect(open.writeResult?.executed ?? false, isFalse);

      final lastMissing = await orch.handle(req('Abra o último orçamento.'));
      expect(lastMissing.actionResult!.valid, isFalse);
      expect(lastMissing.actionPresentation!.naturalLanguage, contains('Alvo'));

      final lastOk = await orch.handle(
        req(
          'Abra o último orçamento.',
          id: 'last-ok',
          context: const AssistantContext(activeQuoteId: 'quote-42'),
        ),
      );
      expect(lastOk.actionResult!.valid, isTrue);
      expect(lastOk.actionResult!.actions.single.target.entityId, 'quote-42');
      expect(lastOk.friendlyMessage, contains('último orçamento'));

      // AI-011 insight still works when not an action phrase.
      final insight = await orch.handle(req('Quantos orçamentos existem?'));
      expect(insight.actionResult, isNull);
      expect(insight.insightResult, isNotNull);
      expect(insight.insightResult!.metrics.single.value, 1);
    });
  });
}
