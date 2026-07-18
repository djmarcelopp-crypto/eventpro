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
      String? quoteId,
    }) {
      return FinancialEntry(
        id: id,
        kind: kind,
        description: description,
        amountCents: 150000,
        date: date ?? DateTime(2026, 8, 5),
        categoryId: categoryId,
        quoteId: quoteId,
        createdAt: createdAt,
        updatedAt: createdAt,
      );
    }

    Future<void> insertSampleQuote(String id) {
      return database
          .into(database.quotes)
          .insert(
            QuotesCompanion.insert(
              id: id,
              number: 'ORC-2026-$id',
              status: 'approved',
              subtotalCents: 50000,
              discountCents: 0,
              freightCents: 0,
              totalCents: 50000,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
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

    group('listByQuoteId', () {
      test('returns only entries linked to the given quote, ordered by date', () async {
        await insertSampleQuote('quote-1');
        await insertSampleQuote('quote-2');

        await repository.insert(
          buildEntry(
            id: 'entry-later',
            description: 'Buffet',
            date: DateTime(2026, 8, 20),
            quoteId: 'quote-1',
          ),
        );
        await repository.insert(
          buildEntry(
            id: 'entry-earlier',
            description: 'Decoração',
            date: DateTime(2026, 8, 10),
            quoteId: 'quote-1',
          ),
        );
        await repository.insert(
          buildEntry(
            id: 'entry-other-quote',
            description: 'Outro evento',
            quoteId: 'quote-2',
          ),
        );
        await repository.insert(
          buildEntry(id: 'entry-unlinked', description: 'Sem evento'),
        );

        final linked = await repository.listByQuoteId('quote-1');

        expect(linked.map((entry) => entry.id).toList(), [
          'entry-earlier',
          'entry-later',
        ]);
      });

      test('returns an empty list when no entries are linked', () async {
        await insertSampleQuote('quote-1');

        expect(await repository.listByQuoteId('quote-1'), isEmpty);
      });
    });

    test(
      'inserting an entry with an unknown quoteId violates the foreign key constraint',
      () async {
        final entry = buildEntry(
          id: 'entry-dangling-quote',
          description: 'Evento inexistente',
          quoteId: 'missing-quote',
        );

        await expectLater(repository.insert(entry), throwsException);
      },
    );

    test('quoteId round-trips through insert and findById', () async {
      await insertSampleQuote('quote-1');
      await repository.insert(
        buildEntry(id: 'entry-linked', description: 'Vinculada', quoteId: 'quote-1'),
      );

      final loaded = await repository.findById('entry-linked');

      expect(loaded?.quoteId, 'quote-1');
    });
  });
}
