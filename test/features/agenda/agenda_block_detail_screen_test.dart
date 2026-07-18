import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/agenda/models/agenda_block.dart';
import 'package:eventpro/features/agenda/providers/agenda_blocks_provider.dart';

import 'agenda_test_helpers.dart';
import 'fakes/fake_agenda_block_repository.dart';

AgendaBlock _sampleBlock({
  String id = 'block-1',
  String title = 'Montagem de palco',
}) {
  return AgendaBlock(
    id: id,
    title: title,
    notes: 'Levar cabos extras',
    start: DateTime(2026, 8, 20, 8, 0),
    end: DateTime(2026, 8, 20, 12, 0),
    createdAt: DateTime(2026, 8, 1),
    updatedAt: DateTime(2026, 8, 1),
  );
}

void main() {
  group('AgendaBlockDetailScreen', () {
    testWidgets('exibe dados do bloqueio', (tester) async {
      await pumpAgendaApp(
        tester,
        blocks: [_sampleBlock()],
        initialLocation: '/agenda/block-1',
      );

      expect(find.text('Montagem de palco'), findsOneWidget);
      expect(find.text('Levar cabos extras'), findsOneWidget);
      expect(find.byKey(const Key('agenda_block_edit_button')), findsOneWidget);
      expect(find.byKey(const Key('agenda_block_delete_button')), findsOneWidget);
    });

    testWidgets('exibe mensagem quando o bloqueio não existe', (tester) async {
      await pumpAgendaApp(tester, initialLocation: '/agenda/inexistente');

      expect(find.text('Bloqueio não encontrado'), findsOneWidget);
    });

    testWidgets('cancelar exclusão mantém o bloqueio', (tester) async {
      await pumpAgendaApp(
        tester,
        blocks: [_sampleBlock()],
        initialLocation: '/agenda/block-1',
      );

      await tester.tap(find.byKey(const Key('agenda_block_delete_button')));
      await tester.pumpAndSettle();

      expect(find.text('Excluir bloqueio'), findsOneWidget);

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.text('Montagem de palco'), findsOneWidget);
      expect(find.byKey(const Key('agenda_block_edit_button')), findsOneWidget);
    });

    testWidgets('confirmar exclusão remove o bloqueio e mostra feedback', (
      tester,
    ) async {
      final container = await pumpAgendaApp(
        tester,
        blocks: [_sampleBlock()],
        initialLocation: '/agenda/block-1',
      );

      await tester.tap(find.byKey(const Key('agenda_block_delete_button')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('agenda_block_delete_confirm_button')),
      );
      await tester.pumpAndSettle();
      await tester.pump();
      await tester.pump();

      expect(find.text('Bloqueio excluído com sucesso'), findsOneWidget);
      expect(
        find.text('Nenhum evento ou bloqueio na agenda'),
        findsOneWidget,
      );
      expect(container.read(agendaBlocksProvider).value, isEmpty);
    });

    testWidgets(
      'falha ao excluir mantém o bloqueio e exibe mensagem de erro',
      (tester) async {
        final repository = FakeAgendaBlockRepository(
          initialBlocks: [_sampleBlock()],
        )..shouldFailOnNextOperation = true;

        await pumpAgendaApp(
          tester,
          blocks: [_sampleBlock()],
          initialLocation: '/agenda/block-1',
          repository: repository,
        );

        await tester.tap(find.byKey(const Key('agenda_block_delete_button')));
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const Key('agenda_block_delete_confirm_button')),
        );
        await tester.pumpAndSettle();

        expect(
          find.text('Não foi possível excluir o bloqueio. Tente novamente.'),
          findsOneWidget,
        );
        expect(find.text('Montagem de palco'), findsOneWidget);
        expect(
          find.byKey(const Key('agenda_block_edit_button')),
          findsOneWidget,
        );
      },
    );

    testWidgets('editar navega para o formulário preenchido', (tester) async {
      await pumpAgendaApp(
        tester,
        blocks: [_sampleBlock()],
        initialLocation: '/agenda/block-1',
      );

      await tester.tap(find.byKey(const Key('agenda_block_edit_button')));
      await tester.pumpAndSettle();

      expect(find.text('Editar bloqueio'), findsOneWidget);
      expect(find.byKey(const Key('agenda_block_title_field')), findsOneWidget);
    });
  });
}
