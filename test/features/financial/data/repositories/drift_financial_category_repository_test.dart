import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/financial/data/repositories/drift_financial_category_repository.dart';
import 'package:eventpro/features/financial/models/financial_category.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriftFinancialCategoryRepository', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;
    late DriftFinancialCategoryRepository repository;

    final createdAt = DateTime(2026, 1, 10, 9, 0);

    FinancialCategory buildCategory({
      required String id,
      required String name,
      FinancialFlowKind kind = FinancialFlowKind.expense,
    }) {
      return FinancialCategory(
        id: id,
        name: name,
        kind: kind,
        createdAt: createdAt,
      );
    }

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'financial_category_repo_test_',
      );
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      repository = DriftFinancialCategoryRepository(database);
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('CRUD persists all fields and orders alphabetically by name', () async {
      final zebra = buildCategory(id: 'category-z', name: 'Zeladoria');
      final aluguel = buildCategory(id: 'category-a', name: 'Aluguel');

      await repository.insert(zebra);
      await repository.insert(aluguel);

      final listed = await repository.listAll();
      expect(listed.map((category) => category.name).toList(), [
        'Aluguel',
        'Zeladoria',
      ]);

      final loaded = await repository.findById('category-a');
      expect(loaded?.name, 'Aluguel');

      final updated = aluguel.copyWith(name: 'Aluguel atualizado');
      await repository.update(updated);
      expect(
        (await repository.findById('category-a'))?.name,
        'Aluguel atualizado',
      );

      await repository.delete('category-a');
      expect(await repository.findById('category-a'), isNull);
      expect((await repository.listAll()).single.id, 'category-z');
    });

    test('findById returns null for unknown id', () async {
      expect(await repository.findById('missing'), isNull);
    });

    test('update throws when category does not exist', () async {
      final category = buildCategory(id: 'missing', name: 'Fantasma');

      await expectLater(repository.update(category), throwsStateError);
    });

    test('delete throws when category does not exist', () async {
      await expectLater(repository.delete('missing'), throwsStateError);
    });

    test('close and reopen database keeps persisted categories', () async {
      await repository.insert(
        buildCategory(id: 'category-persisted', name: 'Persistida'),
      );
      await database.close();

      final reopenedDb = AppDatabase.forTesting(dbFile);
      addTearDown(reopenedDb.close);
      final reopenedRepository = DriftFinancialCategoryRepository(reopenedDb);

      final categories = await reopenedRepository.listAll();
      expect(categories, hasLength(1));
      expect(categories.single.name, 'Persistida');
    });
  });
}
