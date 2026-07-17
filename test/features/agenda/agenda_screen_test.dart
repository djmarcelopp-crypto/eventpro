import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/agenda/data/repositories/agenda_block_repository.dart';
import 'package:eventpro/features/agenda/models/agenda_block.dart';
import 'package:eventpro/features/agenda/providers/agenda_block_clock_provider.dart';
import 'package:eventpro/features/agenda/providers/agenda_blocks_provider.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';

import '../quotes/quotes_test_helpers.dart';
import 'agenda_test_helpers.dart';
import 'fakes/fake_agenda_block_repository.dart';

class _HangingAgendaBlocksNotifier extends AgendaBlocksNotifier {
  @override
  Future<List<AgendaBlock>> build() {
    return Completer<List<AgendaBlock>>().future;
  }
}

class _ThrowingAgendaBlocksNotifier extends AgendaBlocksNotifier {
  @override
  Future<List<AgendaBlock>> build() async {
    throw Exception('Falha simulada de leitura da agenda');
  }
}

/// CP-F hardening helper: counts calls delegated to a wrapped
/// [AgendaBlockRepository], so tests can prove that querying the Agenda
/// Inteligente never touches the repository (i.e. never reads/writes
/// persisted state) beyond the initial bootstrap/hydration read.
class _CountingAgendaBlockRepository implements AgendaBlockRepository {
  _CountingAgendaBlockRepository(this._delegate);

  final AgendaBlockRepository _delegate;
  int listAllCallCount = 0;
  int writeCallCount = 0;

  @override
  Future<List<AgendaBlock>> listAll() {
    listAllCallCount++;
    return _delegate.listAll();
  }

  @override
  Future<AgendaBlock?> findById(String id) => _delegate.findById(id);

  @override
  Future<void> insert(AgendaBlock block) {
    writeCallCount++;
    return _delegate.insert(block);
  }

  @override
  Future<void> update(AgendaBlock block) {
    writeCallCount++;
    return _delegate.update(block);
  }

  @override
  Future<void> delete(String id) {
    writeCallCount++;
    return _delegate.delete(id);
  }
}

Quote _quoteWithEvent({
  required String id,
  required QuoteStatus status,
  DateTime? date,
  String? startTime,
  String? endTime,
  String? name,
}) {
  return sampleQuoteDraft(id: id, status: status).copyWith(
    eventSnapshot: QuoteEventSnapshot(
      name: name,
      date: date,
      startTime: startTime,
      endTime: endTime,
    ),
  );
}

AgendaBlock _sampleBlock({
  String id = 'block-1',
  String title = 'Montagem de palco',
  DateTime? start,
  DateTime? end,
}) {
  return AgendaBlock(
    id: id,
    title: title,
    start: start ?? DateTime(2026, 8, 20, 8, 0),
    end: end ?? DateTime(2026, 8, 20, 12, 0),
    createdAt: DateTime(2026, 8, 1),
    updatedAt: DateTime(2026, 8, 1),
  );
}

Future<void> askQuestion(WidgetTester tester, String phrase) async {
  await tester.ensureVisible(find.byKey(const Key('agenda_query_field')));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('agenda_query_field')), phrase);
  await tester.tap(find.byKey(const Key('agenda_query_button')));
  await tester.pumpAndSettle();
}

void main() {
  group('AgendaScreen', () {
    testWidgets('exibe estado vazio quando não há ocupações', (tester) async {
      await pumpAgendaApp(tester);

      expect(
        find.text('Nenhum evento ou bloqueio na agenda'),
        findsOneWidget,
      );
      expect(find.text('Novo bloqueio'), findsOneWidget);
    });

    testWidgets('botão "Novo bloqueio" do estado vazio abre o formulário', (
      tester,
    ) async {
      await pumpAgendaApp(tester);

      final newBlockButton = find.text('Novo bloqueio');
      await tester.ensureVisible(newBlockButton);
      await tester.pumpAndSettle();
      await tester.tap(newBlockButton);
      await tester.pumpAndSettle();

      expect(find.text('Novo bloqueio'), findsOneWidget);
      expect(find.byKey(const Key('agenda_block_title_field')), findsOneWidget);
    });

    testWidgets('exibe orçamento sent como Proposta', (tester) async {
      final quote = _quoteWithEvent(
        id: 'quote-1',
        status: QuoteStatus.sent,
        date: DateTime(2026, 8, 10),
        startTime: '09:00',
        endTime: '11:00',
        name: 'Aniversário Ana',
      );

      await pumpAgendaApp(tester, quotes: [quote]);

      expect(find.text('Proposta'), findsOneWidget);
      expect(find.text('Aniversário Ana'), findsOneWidget);
      expect(find.byKey(const Key('agenda_occupancy_item_quote-quote-1')), findsOneWidget);
    });

    testWidgets('exibe orçamento approved como Confirmado', (tester) async {
      final quote = _quoteWithEvent(
        id: 'quote-2',
        status: QuoteStatus.approved,
        date: DateTime(2026, 8, 12),
        name: 'Casamento Bruno',
      );

      await pumpAgendaApp(tester, quotes: [quote]);

      expect(find.text('Confirmado'), findsOneWidget);
      expect(find.text('Casamento Bruno'), findsOneWidget);
    });

    testWidgets('exibe bloqueio manual', (tester) async {
      await pumpAgendaApp(tester, blocks: [_sampleBlock()]);

      expect(find.text('Bloqueio'), findsOneWidget);
      expect(find.text('Montagem de palco'), findsOneWidget);
    });

    testWidgets(
      'ignora orçamentos rejeitados, cancelados ou sem data do evento',
      (tester) async {
        final rejected = _quoteWithEvent(
          id: 'quote-rejected',
          status: QuoteStatus.rejected,
          date: DateTime(2026, 8, 15),
        );
        final cancelled = _quoteWithEvent(
          id: 'quote-cancelled',
          status: QuoteStatus.cancelled,
          date: DateTime(2026, 8, 16),
        );
        final noDate = _quoteWithEvent(
          id: 'quote-no-date',
          status: QuoteStatus.sent,
        );

        await pumpAgendaApp(
          tester,
          quotes: [rejected, cancelled, noDate],
        );

        expect(
          find.text('Nenhum evento ou bloqueio na agenda'),
          findsOneWidget,
        );
      },
    );

    testWidgets('ordena ocupações por data/hora', (tester) async {
      final later = _quoteWithEvent(
        id: 'quote-later',
        status: QuoteStatus.sent,
        date: DateTime(2026, 9, 1),
        name: 'Evento de setembro',
      );
      final earlier = _sampleBlock(
        id: 'block-earlier',
        title: 'Bloqueio de agosto',
        start: DateTime(2026, 8, 1, 8, 0),
        end: DateTime(2026, 8, 1, 10, 0),
      );

      await pumpAgendaApp(tester, quotes: [later], blocks: [earlier]);

      final listFinder = find.byKey(const Key('agenda_occupancy_list'));
      final titles = tester
          .widgetList<Text>(
            find.descendant(of: listFinder, matching: find.byType(Text)),
          )
          .map((widget) => widget.data)
          .toList();

      expect(
        titles.indexOf('Bloqueio de agosto'),
        lessThan(titles.indexOf('Evento de setembro')),
      );
    });

    testWidgets('exibe indicador de carregamento', (tester) async {
      await pumpAgendaApp(
        tester,
        hydrateBlocks: false,
        settleAfterPump: false,
        extraOverrides: [
          agendaBlocksProvider.overrideWith(
            () => _HangingAgendaBlocksNotifier(),
          ),
        ],
      );

      expect(find.byKey(const Key('agenda_loading_indicator')), findsOneWidget);
      expect(find.byKey(const Key('agenda_occupancy_list')), findsNothing);
    });

    testWidgets('exibe estado de erro com opção de tentar novamente', (
      tester,
    ) async {
      await pumpAgendaApp(
        tester,
        hydrateBlocks: false,
        extraOverrides: [
          agendaBlocksProvider.overrideWith(
            () => _ThrowingAgendaBlocksNotifier(),
          ),
        ],
      );

      expect(
        find.text('Não foi possível carregar a agenda.'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('agenda_retry_button')), findsOneWidget);
    });

    testWidgets('toca ocupação de orçamento abre o detalhe do orçamento', (
      tester,
    ) async {
      final quote = _quoteWithEvent(
        id: 'quote-tap',
        status: QuoteStatus.sent,
        date: DateTime(2026, 8, 10),
        name: 'Evento tocável',
      );

      await pumpAgendaApp(tester, quotes: [quote]);

      await tester.tap(find.text('Evento tocável'));
      await tester.pumpAndSettle();

      expect(find.text('quote-detail-quote-tap'), findsOneWidget);
    });

    testWidgets('toca bloqueio manual abre o detalhe do bloqueio', (
      tester,
    ) async {
      await pumpAgendaApp(tester, blocks: [_sampleBlock()]);

      await tester.tap(find.text('Montagem de palco'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('agenda_block_edit_button')), findsOneWidget);
      expect(find.byKey(const Key('agenda_block_delete_button')), findsOneWidget);
    });
  });

  group('AgendaScreen — Agenda Inteligente', () {
    testWidgets('responde consulta de dia livre com agenda vazia', (
      tester,
    ) async {
      await pumpAgendaApp(tester);

      await askQuestion(tester, 'Como está minha agenda no dia 20/08/2026?');

      expect(
        find.text('Sua agenda está livre em 20/08/2026.'),
        findsOneWidget,
      );
      expect(
        find.text('Nenhum evento ou bloqueio na agenda'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('responde consulta de dia parcialmente ocupado', (
      tester,
    ) async {
      final block = _sampleBlock(
        start: DateTime(2026, 8, 20, 9, 0),
        end: DateTime(2026, 8, 20, 11, 0),
      );

      await pumpAgendaApp(tester, blocks: [block]);

      await askQuestion(tester, 'Como está minha agenda no dia 20/08/2026?');

      expect(
        find.text(
          'Sua agenda está parcialmente ocupada em 20/08/2026. '
          'Existe 1 ocupação.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('responde consulta de semana com resumo de dias', (
      tester,
    ) async {
      final busyDay = _sampleBlock(
        title: 'Bloqueio da semana',
        start: DateTime(2026, 8, 19, 0, 0),
        end: DateTime(2026, 8, 20, 0, 0),
      );

      await pumpAgendaApp(
        tester,
        blocks: [busyDay],
        extraOverrides: [
          agendaBlockClockProvider.overrideWithValue(
            () => DateTime(2026, 8, 19, 10, 0),
          ),
        ],
      );

      await askQuestion(tester, 'Quais dias desta semana estão livres?');

      expect(
        find.text('Nesta semana: 6 dias livres e 1 ocupado.'),
        findsOneWidget,
      );
    });

    testWidgets('mostra erro para pergunta ambígua', (tester) async {
      await pumpAgendaApp(tester);

      await askQuestion(tester, 'Tenho agenda hoje ou amanhã?');

      expect(
        find.text(
          'Não entendi exatamente o que você quis perguntar — a frase '
          'tem mais de uma interpretação possível. Pode reformular de '
          'forma mais específica (ex.: "Tenho agenda livre no sábado?")?',
        ),
        findsOneWidget,
      );
    });

    testWidgets('mostra erro para pergunta não suportada', (tester) async {
      await pumpAgendaApp(tester);

      await askQuestion(tester, 'Qual é a previsão do tempo?');

      expect(
        find.text(
          'Ainda não sei responder esse tipo de pergunta sobre a agenda. '
          'Tente perguntar sobre um dia, uma semana, um mês ou um '
          'intervalo de datas específico.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('impede duplo clique durante a consulta', (tester) async {
      await pumpAgendaApp(tester);

      await tester.ensureVisible(find.byKey(const Key('agenda_query_field')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('agenda_query_field')),
        'Como está minha agenda no dia 20/08/2026?',
      );
      await tester.pumpAndSettle();

      final queryButton = find.byKey(const Key('agenda_query_button'));
      await tester.tap(queryButton);
      await tester.tap(queryButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(
        find.text('Sua agenda está livre em 20/08/2026.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('limpa a resposta quando a pergunta é alterada', (
      tester,
    ) async {
      await pumpAgendaApp(tester);

      await askQuestion(tester, 'Como está minha agenda no dia 20/08/2026?');
      expect(
        find.text('Sua agenda está livre em 20/08/2026.'),
        findsOneWidget,
      );

      await tester.enterText(
        find.byKey(const Key('agenda_query_field')),
        'Como está minha agenda no dia 21/08/2026?',
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Sua agenda está livre em 20/08/2026.'),
        findsNothing,
      );
      expect(find.byKey(const Key('agenda_query_response')), findsNothing);
    });

    testWidgets('mantém a lista de ocupações após consultar a agenda', (
      tester,
    ) async {
      await pumpAgendaApp(tester, blocks: [_sampleBlock()]);

      await askQuestion(tester, 'Como está minha agenda no dia 20/08/2026?');

      expect(find.text('Bloqueio'), findsOneWidget);
      expect(find.text('Montagem de palco'), findsOneWidget);
      expect(find.byKey(const Key('agenda_occupancy_list')), findsOneWidget);

      await tester.tap(find.text('Montagem de palco'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('agenda_block_edit_button')), findsOneWidget);
    });
  });

  group('AgendaScreen — Agenda Inteligente (hardening CP-F)', () {
    testWidgets(
      'consultar a agenda não realiza nenhuma leitura ou escrita adicional '
      'no repositório de bloqueios',
      (tester) async {
        final countingRepository = _CountingAgendaBlockRepository(
          FakeAgendaBlockRepository(initialBlocks: [_sampleBlock()]),
        );

        await pumpAgendaApp(tester, repository: countingRepository);

        final callsAfterBootstrap = countingRepository.listAllCallCount;

        await askQuestion(tester, 'Como está minha agenda no dia 20/08/2026?');
        await askQuestion(tester, 'Quais dias desta semana estão livres?');
        await askQuestion(tester, 'Qual é a previsão do tempo?');

        expect(countingRepository.listAllCallCount, callsAfterBootstrap);
        expect(countingRepository.writeCallCount, 0);
      },
    );

    testWidgets(
      'consultar a agenda não altera a lista de bloqueios hidratada',
      (tester) async {
        final block = _sampleBlock();
        final container = await pumpAgendaApp(tester, blocks: [block]);

        final blocksBefore = container.read(agendaBlocksProvider).value;

        await askQuestion(tester, 'Como está minha agenda no dia 20/08/2026?');

        final blocksAfter = container.read(agendaBlocksProvider).value;
        expect(blocksAfter, equals(blocksBefore));
        expect(blocksAfter!.single.id, block.id);
      },
    );

    testWidgets(
      'campo, botão e resposta expõem rótulos acessíveis para leitores de tela',
      (tester) async {
        await pumpAgendaApp(tester, blocks: [_sampleBlock()]);

        expect(find.bySemanticsLabel('Pergunta'), findsOneWidget);
        expect(
          find.byWidgetPredicate(
            (widget) => widget is Semantics && widget.properties.button == true,
          ),
          findsWidgets,
        );

        await askQuestion(tester, 'Como está minha agenda no dia 20/08/2026?');

        final responseFinder = find.byKey(const Key('agenda_query_response'));
        expect(responseFinder, findsOneWidget);

        final responseText = tester.widget<Text>(responseFinder).data!;
        expect(responseText, isNotEmpty);
        // A mensagem em si (não apenas a cor) deve carregar o significado,
        // para não depender de percepção visual de cor.
        expect(responseText, contains('Sua agenda está'));
      },
    );
  });
}
