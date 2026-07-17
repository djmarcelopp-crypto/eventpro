import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/financial/data/repositories/drift_financial_category_repository.dart';
import 'package:eventpro/features/financial/data/repositories/drift_financial_entry_repository.dart';
import 'package:eventpro/features/financial/models/financial_category.dart';
import 'package:eventpro/features/financial/models/financial_entry.dart';
import 'package:eventpro/features/financial/models/financial_entry_status.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriftFinancialEntryRepository', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;
    late DriftFinancialEntryRepository repository;

    final createdAt = DateTime(2026, 8, 1, 9, 0);

    FinancialEntry buildEntry({
      required String id,
      required String description,
      DateTime? date,
      FinancialFlowKind kind = FinancialFlowKind.expense,
      String categoryId = 'category-1',
    }) {
      return FinancialEntry(
        id: id,
        kind: kind,
        description: description,
        amountCents: 150000,
        date: date ?? DateTime(2026, 8, 5),
        categoryId: categoryId,
        createdAt: createdAt,
        updatedAt: createdAt,
      );
    }

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'financial_entry_repo_test_',
      );
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      repository = DriftFinancialEntryRepository(database);

      await DriftFinancialCategoryRepository(database).insert(
        FinancialCategory(
          id: 'category-1',
          name: 'Locação de espaço',
          kind: FinancialFlowKind.expense,
          createdAt: createdAt,
        ),
      );
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'CRUD persists all fields and preserves ordering by date',
      () async {
        final later = buildEntry(
          id: 'entry-later',
          description: 'Despesa de agosto',
          date: DateTime(2026, 8, 20),
        );
        final earlier = buildEntry(
          id: 'entry-earlier',
          description: 'Despesa de julho',
          date: DateTime(2026, 7, 10),
        );

        await repository.insert(later);
        await repository.insert(earlier);

        final listed = await repository.listAll();
        expect(listed.map((entry) => entry.description).toList(), [
          'Despesa de julho',
          'Despesa de agosto',
        ]);

        final loaded = await repository.findById('entry-earlier');
        expect(loaded?.description, 'Despesa de julho');

        final updated = earlier.copyWith(
          status: FinancialEntryStatus.paid,
          paidAt: DateTime(2026, 7, 11),
        );
        await repository.update(updated);
        final reloaded = await repository.findById('entry-earlier');
        expect(reloaded?.status, FinancialEntryStatus.paid);
        expect(reloaded?.paidAt, DateTime(2026, 7, 11));

        await repository.delete('entry-earlier');
        expect(await repository.findById('entry-earlier'), isNull);
        expect((await repository.listAll()).single.id, 'entry-later');
      },
    );

    test('findById returns null for unknown id', () async {
      expect(await repository.findById('missing'), isNull);
    });

    test('update throws when entry does not exist', () async {
      final entry = buildEntry(id: 'missing', description: 'Fantasma');

      await expectLater(repository.update(entry), throwsStateError);
    });

    test('delete throws when entry does not exist', () async {
      await expectLater(repository.delete('missing'), throwsStateError);
    });

    test('close and reopen database keeps persisted entries', () async {
      await repository.insert(
        buildEntry(id: 'entry-persisted', description: 'Persistida'),
      );
      await database.close();

      final reopenedDb = AppDatabase.forTesting(dbFile);
      addTearDown(reopenedDb.close);
      final reopenedRepository = DriftFinancialEntryRepository(reopenedDb);

      final entries = await reopenedRepository.listAll();
      expect(entries, hasLength(1));
      expect(entries.single.description, 'Persistida');
    });

    test(
      'inserting an entry with an unknown categoryId violates the foreign key constraint',
      () async {
        final entry = buildEntry(
          id: 'entry-orphan',
          description: 'Órfã',
          categoryId: 'missing-category',
        );

        await expectLater(repository.insert(entry), throwsException);
      },
    );
  });
}
