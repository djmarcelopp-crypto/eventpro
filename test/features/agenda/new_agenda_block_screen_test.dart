import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/agenda/models/agenda_block.dart';
import 'package:eventpro/features/agenda/providers/agenda_blocks_provider.dart';

import 'agenda_test_helpers.dart';
import 'fakes/fake_agenda_block_repository.dart';

AgendaBlock _sampleBlock({
  String id = 'block-1',
  String title = 'Bloqueio original',
}) {
  return AgendaBlock(
    id: id,
    title: title,
    notes: 'Observação original',
    start: DateTime(2026, 8, 20, 8, 0),
    end: DateTime(2026, 8, 20, 12, 0),
    createdAt: DateTime(2026, 8, 1),
    updatedAt: DateTime(2026, 8, 1),
  );
}

void main() {
  group('NewAgendaBlockScreen - criação', () {
    testWidgets('valida campos obrigatórios', (tester) async {
      await pumpAgendaApp(tester, initialLocation: '/agenda/new');

      await tapAgendaSaveButton(tester);

      expect(find.text('Informe um título para o bloqueio'), findsOneWidget);
      expect(find.text('Informe o início do bloqueio'), findsOneWidget);
      expect(find.text('Informe o fim do bloqueio'), findsOneWidget);
    });

    testWidgets('cria bloqueio e retorna para a agenda com feedback', (
      tester,
    ) async {
      await pumpAgendaApp(tester, initialLocation: '/agenda');

      await tester.tap(find.byKey(const Key('agenda_new_block_button')));
      await tester.pumpAndSettle();

      await fillAgendaBlockForm(tester, title: 'Ensaio geral');
      await tapAgendaSaveButton(tester);

      expect(find.text('Bloqueio criado com sucesso'), findsOneWidget);
      expect(find.text('Ensaio geral'), findsOneWidget);
      expect(find.byKey(const Key('agenda_occupancy_list')), findsOneWidget);
    });

    testWidgets('protege contra duplo clique ao salvar', (tester) async {
      final repository = FakeAgendaBlockRepository();
      final container = await pumpAgendaApp(
        tester,
        initialLocation: '/agenda/new',
        repository: repository,
      );

      await fillAgendaBlockForm(tester, title: 'Bloqueio único');

      final saveButton = find.byKey(const Key('agenda_block_save_button'));
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();

      await tester.tap(saveButton);
      await tester.tap(saveButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      final blocks = container.read(agendaBlocksProvider).value ?? const [];
      expect(blocks.where((b) => b.title == 'Bloqueio único').length, 1);
    });

    testWidgets('não navega e exibe erro quando o salvamento falha', (
      tester,
    ) async {
      final repository = FakeAgendaBlockRepository()
        ..shouldFailOnNextOperation = true;

      await pumpAgendaApp(
        tester,
        initialLocation: '/agenda/new',
        repository: repository,
      );

      await fillAgendaBlockForm(tester, title: 'Bloqueio com falha');
      await tapAgendaSaveButton(tester);

      expect(
        find.text('Não foi possível salvar o bloqueio. Tente novamente.'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('agenda_block_title_field')), findsOneWidget);
      expect(find.byKey(const Key('agenda_occupancy_list')), findsNothing);
    });
  });

  group('NewAgendaBlockScreen - edição', () {
    testWidgets('carrega os dados existentes do bloqueio', (tester) async {
      await pumpAgendaApp(
        tester,
        blocks: [_sampleBlock()],
        initialLocation: '/agenda/block-1/edit',
      );

      final titleField = find.descendant(
        of: find.byKey(const Key('agenda_block_title_field')),
        matching: find.byType(TextFormField),
      );
      expect(
        tester.widget<TextFormField>(titleField).controller?.text,
        'Bloqueio original',
      );
    });

    testWidgets('salva alterações e retorna à agenda com feedback', (
      tester,
    ) async {
      await pumpAgendaApp(
        tester,
        blocks: [_sampleBlock()],
        initialLocation: '/agenda/block-1/edit',
      );

      await tester.enterText(
        find.byKey(const Key('agenda_block_title_field')),
        'Bloqueio atualizado',
      );
      await tapAgendaSaveButton(tester);
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.text('Bloqueio atualizado com sucesso'), findsOneWidget);
      expect(find.text('Bloqueio atualizado'), findsOneWidget);
    });
  });
}
