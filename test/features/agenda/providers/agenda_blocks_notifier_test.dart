import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/agenda/data/repositories/agenda_block_repository.dart';
import 'package:eventpro/features/agenda/models/agenda_block.dart';
import 'package:eventpro/features/agenda/providers/agenda_block_repository_provider.dart';
import 'package:eventpro/features/agenda/providers/agenda_blocks_provider.dart';

import '../fakes/fake_agenda_block_repository.dart';

AgendaBlock _sampleBlock({
  required String title,
  DateTime? start,
  DateTime? end,
  String? notes,
}) {
  return AgendaBlock(
    id: 'draft-id',
    title: title,
    notes: notes,
    start: start ?? DateTime(2026, 8, 15, 8, 0),
    end: end ?? DateTime(2026, 8, 15, 12, 0),
    createdAt: DateTime(2026, 8, 1, 9, 0),
    updatedAt: DateTime(2026, 8, 1, 9, 0),
  );
}

ProviderContainer _createContainer({AgendaBlockRepository? repository}) {
  final container = ProviderContainer(
    overrides: [
      agendaBlockRepositoryProvider.overrideWithValue(
        repository ?? FakeAgendaBlockRepository(),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('AgendaBlocksNotifier', () {
    test('inicia com lista vazia', () async {
      final container = _createContainer();

      final blocks = await container.read(agendaBlocksProvider.future);

      expect(blocks, isEmpty);
    });

    test('hydrate substitui o state pela lista informada', () async {
      final container = _createContainer();
      await container.read(agendaBlocksProvider.future);
      final blocks = [
        _sampleBlock(title: 'Bloqueio 1'),
        _sampleBlock(title: 'Bloqueio 2'),
      ];

      container.read(agendaBlocksProvider.notifier).hydrate(blocks);

      expect(container.read(agendaBlocksProvider).value, blocks);
    });

    test('addBlock adiciona bloco válido à lista', () async {
      final container = _createContainer();
      await container.read(agendaBlocksProvider.future);

      final saved = await container
          .read(agendaBlocksProvider.notifier)
          .addBlock(_sampleBlock(title: 'Manutenção do galpão'));

      expect(saved, isTrue);
      final blocks = container.read(agendaBlocksProvider).value!;
      expect(blocks, hasLength(1));
      expect(blocks.first.title, 'Manutenção do galpão');
    });

    test('addBlock preserva ordem de cadastro', () async {
      final container = _createContainer();
      await container.read(agendaBlocksProvider.future);
      final notifier = container.read(agendaBlocksProvider.notifier);

      await notifier.addBlock(_sampleBlock(title: 'Bloqueio 1'));
      await notifier.addBlock(_sampleBlock(title: 'Bloqueio 2'));

      final titles = container
          .read(agendaBlocksProvider)
          .value!
          .map((block) => block.title)
          .toList();
      expect(titles, ['Bloqueio 1', 'Bloqueio 2']);
    });

    test('addBlock gera id e timestamps próprios, ignorando o rascunho', () async {
      final container = _createContainer();
      await container.read(agendaBlocksProvider.future);
      final notifier = container.read(agendaBlocksProvider.notifier);

      await notifier.addBlock(_sampleBlock(title: 'Bloqueio 1'));

      final saved = container.read(agendaBlocksProvider).value!.single;
      expect(saved.id, isNot('draft-id'));
      expect(saved.createdAt, saved.updatedAt);
    });

    test('addBlock rejeita bloco com título vazio e não persiste', () async {
      final repository = FakeAgendaBlockRepository();
      final container = _createContainer(repository: repository);
      await container.read(agendaBlocksProvider.future);

      final saved = await container
          .read(agendaBlocksProvider.notifier)
          .addBlock(_sampleBlock(title: '   '));

      expect(saved, isFalse);
      expect(container.read(agendaBlocksProvider).value, isEmpty);
      expect(await repository.listAll(), isEmpty);
    });

    test('addBlock rejeita fim anterior ou igual ao início', () async {
      final container = _createContainer();
      await container.read(agendaBlocksProvider.future);
      final start = DateTime(2026, 8, 15, 8, 0);

      final saved = await container
          .read(agendaBlocksProvider.notifier)
          .addBlock(
            _sampleBlock(title: 'Bloqueio inválido', start: start, end: start),
          );

      expect(saved, isFalse);
      expect(container.read(agendaBlocksProvider).value, isEmpty);
    });

    test('findById retorna bloco existente ou null', () async {
      final container = _createContainer();
      await container.read(agendaBlocksProvider.future);
      final notifier = container.read(agendaBlocksProvider.notifier);

      await notifier.addBlock(_sampleBlock(title: 'Manutenção do galpão'));
      final persistedId = container.read(agendaBlocksProvider).value!.single.id;

      expect(notifier.findById(persistedId)?.title, 'Manutenção do galpão');
      expect(notifier.findById('missing'), isNull);
    });

    test(
      'updateBlock preserva id, createdAt e atualiza updatedAt',
      () async {
        final container = _createContainer();
        await container.read(agendaBlocksProvider.future);
        final notifier = container.read(agendaBlocksProvider.notifier);

        await notifier.addBlock(_sampleBlock(title: 'Manutenção do galpão'));
        final persisted = container.read(agendaBlocksProvider).value!.single;

        final saved = await notifier.updateBlock(
          persisted.copyWith(title: 'Manutenção remarcada'),
        );

        expect(saved, isTrue);
        final updated = container.read(agendaBlocksProvider).value!.first;
        expect(updated.id, persisted.id);
        expect(updated.createdAt, persisted.createdAt);
        expect(updated.title, 'Manutenção remarcada');
      },
    );

    test('updateBlock retorna false quando o bloco não existe', () async {
      final container = _createContainer();
      await container.read(agendaBlocksProvider.future);

      final saved = await container
          .read(agendaBlocksProvider.notifier)
          .updateBlock(_sampleBlock(title: 'Fantasma').copyWith(id: 'missing'));

      expect(saved, isFalse);
    });

    test(
      'updateBlock rejeita dados inválidos e não altera o state',
      () async {
        final container = _createContainer();
        await container.read(agendaBlocksProvider.future);
        final notifier = container.read(agendaBlocksProvider.notifier);

        await notifier.addBlock(_sampleBlock(title: 'Manutenção do galpão'));
        final persisted = container.read(agendaBlocksProvider).value!.single;

        final saved = await notifier.updateBlock(
          persisted.copyWith(title: ''),
        );

        expect(saved, isFalse);
        expect(
          container.read(agendaBlocksProvider).value!.single.title,
          'Manutenção do galpão',
        );
      },
    );

    test('deleteBlock remove bloco da lista', () async {
      final container = _createContainer();
      await container.read(agendaBlocksProvider.future);
      final notifier = container.read(agendaBlocksProvider.notifier);

      await notifier.addBlock(_sampleBlock(title: 'Bloqueio 1'));
      final firstId = container.read(agendaBlocksProvider).value!.first.id;
      await notifier.addBlock(_sampleBlock(title: 'Bloqueio 2'));
      final secondId = container.read(agendaBlocksProvider).value!.last.id;

      final deleted = await notifier.deleteBlock(firstId);

      expect(deleted, isTrue);
      final remaining = container.read(agendaBlocksProvider).value!;
      expect(remaining, hasLength(1));
      expect(remaining.first.id, secondId);
    });

    test('falha de insert não altera state', () async {
      final repository = FakeAgendaBlockRepository()
        ..shouldFailOnNextOperation = true;
      final container = _createContainer(repository: repository);
      await container.read(agendaBlocksProvider.future);

      final saved = await container
          .read(agendaBlocksProvider.notifier)
          .addBlock(_sampleBlock(title: 'Manutenção do galpão'));

      expect(saved, isFalse);
      expect(container.read(agendaBlocksProvider).value, isEmpty);
    });

    test('falha de update não altera state', () async {
      final repository = FakeAgendaBlockRepository();
      final container = _createContainer(repository: repository);
      await container.read(agendaBlocksProvider.future);
      final notifier = container.read(agendaBlocksProvider.notifier);

      await notifier.addBlock(_sampleBlock(title: 'Manutenção do galpão'));
      final persisted = container.read(agendaBlocksProvider).value!.single;
      repository.shouldFailOnNextOperation = true;

      final saved = await notifier.updateBlock(
        persisted.copyWith(title: 'Manutenção remarcada'),
      );

      expect(saved, isFalse);
      expect(
        container.read(agendaBlocksProvider).value!.single.title,
        'Manutenção do galpão',
      );
    });

    test('falha de delete não altera state', () async {
      final repository = FakeAgendaBlockRepository();
      final container = _createContainer(repository: repository);
      await container.read(agendaBlocksProvider.future);
      final notifier = container.read(agendaBlocksProvider.notifier);

      await notifier.addBlock(_sampleBlock(title: 'Manutenção do galpão'));
      final persisted = container.read(agendaBlocksProvider).value!.single;
      repository.shouldFailOnNextOperation = true;

      final deleted = await notifier.deleteBlock(persisted.id);

      expect(deleted, isFalse);
      expect(container.read(agendaBlocksProvider).value, hasLength(1));
    });
  });
}
