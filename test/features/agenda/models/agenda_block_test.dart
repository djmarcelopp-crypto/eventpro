import 'package:eventpro/features/agenda/models/agenda_block.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AgendaBlock', () {
    AgendaBlock buildBlock({String? notes}) {
      return AgendaBlock(
        id: 'block-1',
        title: 'Manutenção do galpão',
        notes: notes,
        start: DateTime(2026, 8, 15, 8, 0),
        end: DateTime(2026, 8, 15, 12, 0),
        createdAt: DateTime(2026, 8, 1, 9, 0),
        updatedAt: DateTime(2026, 8, 1, 9, 0),
      );
    }

    test('copyWith preserves original values when no override is given', () {
      final original = buildBlock(notes: 'Fechado para reforma');

      final copy = original.copyWith();

      expect(copy.id, original.id);
      expect(copy.title, original.title);
      expect(copy.notes, original.notes);
      expect(copy.start, original.start);
      expect(copy.end, original.end);
      expect(copy.createdAt, original.createdAt);
      expect(copy.updatedAt, original.updatedAt);
    });

    test('copyWith overrides only the informed fields', () {
      final original = buildBlock();
      final newStart = DateTime(2026, 8, 16, 8, 0);
      final newEnd = DateTime(2026, 8, 16, 12, 0);

      final updated = original.copyWith(
        title: 'Bloqueio remarcado',
        start: newStart,
        end: newEnd,
      );

      expect(updated.title, 'Bloqueio remarcado');
      expect(updated.start, newStart);
      expect(updated.end, newEnd);
      expect(updated.id, original.id);
      expect(updated.createdAt, original.createdAt);
    });

    test('copyWith clearNotes removes existing notes', () {
      final original = buildBlock(notes: 'Fechado para reforma');

      final cleared = original.copyWith(clearNotes: true);

      expect(cleared.notes, isNull);
    });

    test('copyWith without clearNotes keeps existing notes', () {
      final original = buildBlock(notes: 'Fechado para reforma');

      final copy = original.copyWith(title: 'Outro título');

      expect(copy.notes, 'Fechado para reforma');
    });
  });
}
