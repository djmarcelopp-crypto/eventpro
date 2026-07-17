import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/financial/data/mappers/financial_entry_mapper.dart';
import 'package:eventpro/features/financial/models/financial_entry.dart';
import 'package:eventpro/features/financial/models/financial_entry_status.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FinancialEntryMapper', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;

    final createdAt = DateTime(2026, 8, 1, 9, 0);
    final date = DateTime(2026, 8, 5);

    Future<void> insertSampleCategory(String id) {
      return database
          .into(database.financialCategories)
          .insert(
            FinancialCategoriesCompanion.insert(
              id: id,
              name: 'Locação de espaço',
              kind: FinancialFlowKind.expense.name,
              active: true,
              createdAt: 1_700_000_000_000,
            ),
          );
    }

    FinancialEntry buildSampleEntry({
      FinancialFlowKind kind = FinancialFlowKind.expense,
      FinancialEntryStatus status = FinancialEntryStatus.pending,
      DateTime? paidAt,
      String? notes,
    }) {
      return FinancialEntry(
        id: 'entry-1',
        kind: kind,
        description: 'Aluguel do galpão',
        amountCents: 150000,
        date: date,
        categoryId: 'category-1',
        status: status,
        paidAt: paidAt,
        notes: notes,
        createdAt: createdAt,
        updatedAt: createdAt,
      );
    }

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'financial_entry_mapper_test_',
      );
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      await insertSampleCategory('category-1');
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    Future<FinancialEntry> persistAndReload(FinancialEntry entry) async {
      await database
          .into(database.financialEntries)
          .insert(FinancialEntryMapper.toInsertCompanion(entry));
      final row = await (database.select(
        database.financialEntries,
      )..where((tbl) => tbl.id.equals(entry.id))).getSingle();
      return FinancialEntryMapper.toDomain(row);
    }

    test('round-trips all populated fields', () async {
      final paidAt = DateTime(2026, 8, 6, 10, 30);
      final original = buildSampleEntry(
        status: FinancialEntryStatus.paid,
        paidAt: paidAt,
        notes: 'Pago via Pix',
      );

      final restored = await persistAndReload(original);

      expect(restored.id, original.id);
      expect(restored.kind, original.kind);
      expect(restored.description, original.description);
      expect(restored.amountCents, original.amountCents);
      expect(restored.date, original.date);
      expect(restored.categoryId, original.categoryId);
      expect(restored.status, original.status);
      expect(restored.paidAt, original.paidAt);
      expect(restored.notes, original.notes);
      expect(restored.createdAt, original.createdAt);
      expect(restored.updatedAt, original.updatedAt);
    });

    test('round-trips null paidAt and null notes', () async {
      final original = buildSampleEntry();

      final restored = await persistAndReload(original);

      expect(restored.paidAt, isNull);
      expect(restored.notes, isNull);
    });

    test('round-trips income kind', () async {
      final original = buildSampleEntry(kind: FinancialFlowKind.income);

      final restored = await persistAndReload(original);

      expect(restored.kind, FinancialFlowKind.income);
    });

    test('civil date is preserved exactly without timezone drift', () async {
      final original = buildSampleEntry();

      final restored = await persistAndReload(original);

      expect(restored.date.year, date.year);
      expect(restored.date.month, date.month);
      expect(restored.date.day, date.day);
    });

    test('amountCents round-trips as an integer', () async {
      final original = buildSampleEntry();

      final restored = await persistAndReload(original);

      expect(restored.amountCents, 150000);
      expect(restored.amountCents, isA<int>());
    });

    test('update companion clears notes and paidAt when both are null', () async {
      final withValues = buildSampleEntry(
        status: FinancialEntryStatus.paid,
        paidAt: DateTime(2026, 8, 6, 10, 30),
        notes: 'Pago via Pix',
      );
      await database
          .into(database.financialEntries)
          .insert(FinancialEntryMapper.toInsertCompanion(withValues));

      final cleared = buildSampleEntry();
      await database
          .update(database.financialEntries)
          .replace(FinancialEntryMapper.toUpdateCompanion(cleared));

      final row = await (database.select(
        database.financialEntries,
      )..where((tbl) => tbl.id.equals(cleared.id))).getSingle();

      expect(row.paidAt, isNull);
      expect(row.notes, isNull);
      expect(row.status, 'pending');
    });
  });
}
