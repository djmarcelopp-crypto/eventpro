import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/agenda/data/mappers/agenda_block_mapper.dart';
import 'package:eventpro/features/agenda/models/agenda_block.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AgendaBlockMapper', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;

    final createdAt = DateTime(2026, 8, 1, 9, 0);
    final start = DateTime(2026, 8, 15, 8, 0);
    final end = DateTime(2026, 8, 15, 12, 0);

    AgendaBlock buildSampleBlock({String? notes}) {
      return AgendaBlock(
        id: 'block-1',
        title: 'Manutenção do galpão',
        notes: notes,
        start: start,
        end: end,
        createdAt: createdAt,
        updatedAt: createdAt,
      );
    }

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'agenda_block_mapper_test_',
      );
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    Future<AgendaBlock> persistAndReload(AgendaBlock block) async {
      await database
          .into(database.agendaBlocks)
          .insert(AgendaBlockMapper.toInsertCompanion(block));
      final row = await (database.select(
        database.agendaBlocks,
      )..where((tbl) => tbl.id.equals(block.id))).getSingle();
      return AgendaBlockMapper.toDomain(row);
    }

    test('round-trips all populated fields', () async {
      final original = buildSampleBlock(notes: 'Fechado para reforma');

      final restored = await persistAndReload(original);

      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.notes, original.notes);
      expect(restored.start, original.start);
      expect(restored.end, original.end);
      expect(restored.createdAt, original.createdAt);
      expect(restored.updatedAt, original.updatedAt);
    });

    test('round-trips null notes', () async {
      final original = buildSampleBlock();

      final restored = await persistAndReload(original);

      expect(restored.notes, isNull);
    });

    test('update companion clears notes when notes is null', () async {
      final withNotes = buildSampleBlock(notes: 'Fechado para reforma');
      await database
          .into(database.agendaBlocks)
          .insert(AgendaBlockMapper.toInsertCompanion(withNotes));

      final cleared = buildSampleBlock();
      await database
          .update(database.agendaBlocks)
          .replace(AgendaBlockMapper.toUpdateCompanion(cleared));

      final row = await (database.select(
        database.agendaBlocks,
      )..where((tbl) => tbl.id.equals(cleared.id))).getSingle();

      expect(row.notes, isNull);
    });
  });
}
