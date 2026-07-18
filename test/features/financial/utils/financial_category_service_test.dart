import 'package:eventpro/features/financial/models/financial_category.dart';
import 'package:eventpro/features/financial/models/financial_category_delete_result.dart';
import 'package:eventpro/features/financial/models/financial_category_write_result.dart';
import 'package:eventpro/features/financial/models/financial_entry.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:eventpro/features/financial/utils/financial_category_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_financial_category_repository.dart';
import '../fakes/fake_financial_entry_repository.dart';

void main() {
  group('FinancialCategoryService', () {
    late FakeFinancialCategoryRepository categoryRepository;
    late FakeFinancialEntryRepository entryRepository;
    final fixedNow = DateTime(2030, 1, 1, 12, 0);

    FinancialCategoryService buildService({DateTime? now}) {
      return FinancialCategoryService(
        categoryRepository: categoryRepository,
        entryRepository: entryRepository,
        clock: () => now ?? fixedNow,
      );
    }

    FinancialCategory buildDraft({
      String id = '',
      String name = 'Locação de espaço',
      FinancialFlowKind kind = FinancialFlowKind.expense,
      bool active = true,
    }) {
      return FinancialCategory(
        id: id,
        name: name,
        kind: kind,
        active: active,
        createdAt: DateTime(2020, 1, 1),
      );
    }

    setUp(() {
      categoryRepository = FakeFinancialCategoryRepository();
      entryRepository = FakeFinancialEntryRepository();
    });

    group('create', () {
      test('persists a valid category using the injectable clock', () async {
        final service = buildService();

        final result = await service.create(buildDraft());

        expect(result.isSuccess, isTrue);
        expect(result.category, isNotNull);
        expect(result.category!.id, isNotEmpty);
        expect(result.category!.createdAt, fixedNow);
        expect(
          await categoryRepository.findById(result.category!.id),
          isNotNull,
        );
      });

      test('rejects an empty name without touching the repository', () async {
        final service = buildService();

        final result = await service.create(buildDraft(name: ''));

        expect(result.status, FinancialCategoryWriteStatus.validationFailed);
        expect(result.errors, isNotEmpty);
        expect(await categoryRepository.listAll(), isEmpty);
      });

      test('returns failure when the repository throws', () async {
        categoryRepository.shouldFailOnNextOperation = true;
        final service = buildService();

        final result = await service.create(buildDraft());

        expect(result.status, FinancialCategoryWriteStatus.failure);
      });
    });

    group('update', () {
      test('returns notFound for an unknown id', () async {
        final service = buildService();

        final result = await service.update(
          buildDraft(id: 'missing', name: 'Nova categoria'),
        );

        expect(result.status, FinancialCategoryWriteStatus.notFound);
      });

      test('rejects an empty name and does not persist', () async {
        final existing = buildDraft(id: 'category-1');
        await categoryRepository.insert(existing);
        final service = buildService();

        final result = await service.update(
          existing.copyWith(name: '   '),
        );

        expect(result.status, FinancialCategoryWriteStatus.validationFailed);
        expect(
          (await categoryRepository.findById('category-1'))?.name,
          existing.name,
        );
      });

      test('preserves id and createdAt while updating other fields', () async {
        final existing = buildDraft(id: 'category-1');
        await categoryRepository.insert(existing);
        final service = buildService();

        final result = await service.update(
          existing.copyWith(name: 'Renomeada', active: false),
        );

        expect(result.isSuccess, isTrue);
        expect(result.category!.id, existing.id);
        expect(result.category!.createdAt, existing.createdAt);
        expect(result.category!.name, 'Renomeada');
        expect(result.category!.active, isFalse);
      });

      test('returns failure when the repository throws', () async {
        final existing = buildDraft(id: 'category-1');
        await categoryRepository.insert(existing);
        categoryRepository.shouldFailOnNextOperation = true;
        final service = buildService();

        final result = await service.update(existing.copyWith(name: 'Nova'));

        expect(result.status, FinancialCategoryWriteStatus.failure);
      });
    });

    group('delete', () {
      test('returns notFound for an unknown id', () async {
        final service = buildService();

        final result = await service.delete('missing');

        expect(result.status, FinancialCategoryDeleteStatus.notFound);
      });

      test('deletes a category with no linked entries', () async {
        final existing = buildDraft(id: 'category-1');
        await categoryRepository.insert(existing);
        final service = buildService();

        final result = await service.delete('category-1');

        expect(result.isDeleted, isTrue);
        expect(await categoryRepository.findById('category-1'), isNull);
      });

      test(
        'blocks deletion when entries still reference the category and reports the count',
        () async {
          final existing = buildDraft(id: 'category-1');
          await categoryRepository.insert(existing);
          await entryRepository.insert(
            FinancialEntry(
              id: 'entry-1',
              kind: FinancialFlowKind.expense,
              description: 'Aluguel',
              amountCents: 1000,
              date: DateTime(2026, 8, 5),
              categoryId: 'category-1',
              createdAt: fixedNow,
              updatedAt: fixedNow,
            ),
          );
          await entryRepository.insert(
            FinancialEntry(
              id: 'entry-2',
              kind: FinancialFlowKind.expense,
              description: 'Manutenção',
              amountCents: 500,
              date: DateTime(2026, 8, 6),
              categoryId: 'category-1',
              createdAt: fixedNow,
              updatedAt: fixedNow,
            ),
          );
          final service = buildService();

          final result = await service.delete('category-1');

          expect(result.isBlockedByUsage, isTrue);
          expect(result.blockingEntryCount, 2);
          expect(await categoryRepository.findById('category-1'), isNotNull);
        },
      );

      test('returns failure when the repository throws', () async {
        final existing = buildDraft(id: 'category-1');
        await categoryRepository.insert(existing);
        categoryRepository.shouldFailOnNextOperation = true;
        final service = buildService();

        final result = await service.delete('category-1');

        expect(result.status, FinancialCategoryDeleteStatus.failure);
      });
    });
  });
}
