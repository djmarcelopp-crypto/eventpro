import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/financial/data/mappers/financial_category_mapper.dart';
import 'package:eventpro/features/financial/models/financial_category.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FinancialCategoryMapper', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;

    final createdAt = DateTime(2026, 1, 10, 9, 0);

    FinancialCategory buildSampleCategory({
      FinancialFlowKind kind = FinancialFlowKind.expense,
      bool active = true,
    }) {
      return FinancialCategory(
        id: 'category-1',
        name: 'Locação de espaço',
        kind: kind,
        active: active,
        createdAt: createdAt,
      );
    }

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'financial_category_mapper_test_',
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

    Future<FinancialCategory> persistAndReload(
      FinancialCategory category,
    ) async {
      await database
          .into(database.financialCategories)
          .insert(FinancialCategoryMapper.toInsertCompanion(category));
      final row = await (database.select(
        database.financialCategories,
      )..where((tbl) => tbl.id.equals(category.id))).getSingle();
      return FinancialCategoryMapper.toDomain(row);
    }

    test('round-trips an income category', () async {
      final original = buildSampleCategory(kind: FinancialFlowKind.income);

      final restored = await persistAndReload(original);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.kind, FinancialFlowKind.income);
      expect(restored.active, original.active);
      expect(restored.createdAt, original.createdAt);
    });

    test('round-trips an expense category', () async {
      final original = buildSampleCategory(kind: FinancialFlowKind.expense);

      final restored = await persistAndReload(original);

      expect(restored.kind, FinancialFlowKind.expense);
    });

    test('round-trips inactive category', () async {
      final original = buildSampleCategory(active: false);

      final restored = await persistAndReload(original);

      expect(restored.active, isFalse);
    });

    test('update companion overwrites the previous row', () async {
      final original = buildSampleCategory();
      await database
          .into(database.financialCategories)
          .insert(FinancialCategoryMapper.toInsertCompanion(original));

      final renamed = original.copyWith(name: 'Locação de espaço (renomeada)');
      await database
          .update(database.financialCategories)
          .replace(FinancialCategoryMapper.toUpdateCompanion(renamed));

      final row = await (database.select(
        database.financialCategories,
      )..where((tbl) => tbl.id.equals(original.id))).getSingle();

      expect(row.name, 'Locação de espaço (renomeada)');
    });
  });
}
