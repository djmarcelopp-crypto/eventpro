import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/agenda/models/agenda_block.dart';
import 'package:eventpro/features/agenda/providers/agenda_blocks_provider.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';

import '../quotes/quotes_test_helpers.dart';
import 'agenda_test_helpers.dart';

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

      await tester.tap(find.text('Novo bloqueio'));
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
}
