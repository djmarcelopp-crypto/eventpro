import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/agenda/data/repositories/drift_agenda_block_repository.dart';
import 'package:eventpro/features/agenda/models/agenda_block.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriftAgendaBlockRepository', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;
    late DriftAgendaBlockRepository repository;

    final createdAt = DateTime(2026, 8, 1, 9, 0);

    AgendaBlock buildBlock({
      required String id,
      required String title,
      DateTime? start,
      DateTime? end,
      String? notes,
    }) {
      return AgendaBlock(
        id: id,
        title: title,
        notes: notes,
        start: start ?? DateTime(2026, 8, 15, 8, 0),
        end: end ?? DateTime(2026, 8, 15, 12, 0),
        createdAt: createdAt,
        updatedAt: createdAt,
      );
    }

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('agenda_block_repo_test_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      repository = DriftAgendaBlockRepository(database);
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'CRUD persists all fields and preserves ordering by start',
      () async {
        final later = buildBlock(
          id: 'block-later',
          title: 'Bloqueio tarde',
          start: DateTime(2026, 8, 16, 8, 0),
          end: DateTime(2026, 8, 16, 12, 0),
        );
        final earlier = buildBlock(
          id: 'block-earlier',
          title: 'Bloqueio manhã',
          start: DateTime(2026, 8, 15, 8, 0),
          end: DateTime(2026, 8, 15, 12, 0),
          notes: 'Fechado para reforma',
        );

        await repository.insert(later);
        await repository.insert(earlier);

        final listed = await repository.listAll();
        expect(
          listed.map((block) => block.title).toList(),
          ['Bloqueio manhã', 'Bloqueio tarde'],
        );
        expect(listed.first.notes, 'Fechado para reforma');

        final loaded = await repository.findById('block-earlier');
        expect(loaded?.title, 'Bloqueio manhã');

        final updated = earlier.copyWith(title: 'Bloqueio manhã atualizado');
        await repository.update(updated);
        expect(
          (await repository.findById('block-earlier'))?.title,
          'Bloqueio manhã atualizado',
        );

        await repository.delete('block-earlier');
        expect(await repository.findById('block-earlier'), isNull);
        expect((await repository.listAll()).single.id, 'block-later');
      },
    );

    test('update throws when block does not exist', () async {
      final block = buildBlock(id: 'missing', title: 'Bloqueio fantasma');

      await expectLater(repository.update(block), throwsStateError);
    });

    test('delete throws when block does not exist', () async {
      await expectLater(repository.delete('missing'), throwsStateError);
    });

    test('close and reopen database keeps persisted agenda blocks', () async {
      await repository.insert(
        buildBlock(id: 'block-persisted', title: 'Bloqueio persistido'),
      );
      await database.close();

      final reopenedDb = AppDatabase.forTesting(dbFile);
      addTearDown(reopenedDb.close);
      final reopenedRepository = DriftAgendaBlockRepository(reopenedDb);

      final blocks = await reopenedRepository.listAll();
      expect(blocks, hasLength(1));
      expect(blocks.single.title, 'Bloqueio persistido');
    });
  });
}
