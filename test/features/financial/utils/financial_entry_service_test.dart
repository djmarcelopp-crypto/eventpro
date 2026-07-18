import 'package:eventpro/features/financial/models/financial_category.dart';
import 'package:eventpro/features/financial/models/financial_entry.dart';
import 'package:eventpro/features/financial/models/financial_entry_delete_result.dart';
import 'package:eventpro/features/financial/models/financial_entry_status.dart';
import 'package:eventpro/features/financial/models/financial_entry_write_result.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:eventpro/features/financial/utils/financial_entry_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_financial_category_repository.dart';
import '../fakes/fake_financial_entry_repository.dart';

void main() {
  group('FinancialEntryService', () {
    late FakeFinancialCategoryRepository categoryRepository;
    late FakeFinancialEntryRepository entryRepository;
    final fixedNow = DateTime(2030, 1, 1, 12, 0);

    FinancialEntryService buildService({DateTime? now}) {
      return FinancialEntryService(
        entryRepository: entryRepository,
        categoryRepository: categoryRepository,
        clock: () => now ?? fixedNow,
      );
    }

    FinancialCategory buildCategory({
      String id = 'category-1',
      FinancialFlowKind kind = FinancialFlowKind.expense,
      bool active = true,
    }) {
      return FinancialCategory(
        id: id,
        name: 'Locação de espaço',
        kind: kind,
        active: active,
        createdAt: DateTime(2020, 1, 1),
      );
    }

    FinancialEntry buildDraft({
      String id = '',
      String description = 'Aluguel do galpão',
      int amountCents = 150000,
      DateTime? date,
      String categoryId = 'category-1',
      FinancialFlowKind kind = FinancialFlowKind.expense,
      FinancialEntryStatus status = FinancialEntryStatus.pending,
      DateTime? paidAt,
    }) {
      return FinancialEntry(
        id: id,
        kind: kind,
        description: description,
        amountCents: amountCents,
        date: date ?? DateTime(2026, 8, 5),
        categoryId: categoryId,
        status: status,
        paidAt: paidAt,
        createdAt: DateTime(2020, 1, 1),
        updatedAt: DateTime(2020, 1, 1),
      );
    }

    setUp(() async {
      categoryRepository = FakeFinancialCategoryRepository();
      entryRepository = FakeFinancialEntryRepository();
      await categoryRepository.insert(buildCategory());
    });

    group('create', () {
      test(
        'persists a valid entry using the injectable clock for id-independent timestamps',
        () async {
          final service = buildService();

          final result = await service.create(buildDraft());

          expect(result.isSuccess, isTrue);
          expect(result.entry!.id, isNotEmpty);
          expect(result.entry!.createdAt, fixedNow);
          expect(result.entry!.updatedAt, fixedNow);
          expect(
            await entryRepository.findById(result.entry!.id),
            isNotNull,
          );
        },
      );

      test(
        'rejects an invalid entry (empty description) without touching the repository',
        () async {
          final service = buildService();

          final result = await service.create(
            buildDraft(description: ''),
          );

          expect(result.status, FinancialEntryWriteStatus.validationFailed);
          expect(result.errors, isNotEmpty);
          expect(await entryRepository.listAll(), isEmpty);
        },
      );

      test('rejects an entry with an unknown categoryId', () async {
        final service = buildService();

        final result = await service.create(
          buildDraft(categoryId: 'missing-category'),
        );

        expect(result.status, FinancialEntryWriteStatus.categoryNotFound);
        expect(await entryRepository.listAll(), isEmpty);
      });

      test('rejects an entry filed under an inactive category', () async {
        await categoryRepository.update(
          buildCategory().copyWith(active: false),
        );
        final service = buildService();

        final result = await service.create(buildDraft());

        expect(result.status, FinancialEntryWriteStatus.categoryInactive);
        expect(await entryRepository.listAll(), isEmpty);
      });

      test(
        'rejects an entry whose kind does not match the category kind',
        () async {
          final service = buildService();

          final result = await service.create(
            buildDraft(kind: FinancialFlowKind.income),
          );

          expect(
            result.status,
            FinancialEntryWriteStatus.categoryKindMismatch,
          );
          expect(await entryRepository.listAll(), isEmpty);
        },
      );

      test(
        'fills paidAt from the injectable clock when marking as paid without one',
        () async {
          final service = buildService();

          final result = await service.create(
            buildDraft(status: FinancialEntryStatus.paid),
          );

          expect(result.isSuccess, isTrue);
          expect(result.entry!.status, FinancialEntryStatus.paid);
          expect(result.entry!.paidAt, fixedNow);
        },
      );

      test(
        'preserves an explicitly informed paidAt instead of overwriting it with the clock',
        () async {
          final explicitPaidAt = DateTime(2026, 8, 6, 9, 0);
          final service = buildService();

          final result = await service.create(
            buildDraft(status: FinancialEntryStatus.paid, paidAt: explicitPaidAt),
          );

          expect(result.entry!.paidAt, explicitPaidAt);
        },
      );

      test('clears any paidAt informed for a pending entry', () async {
        final service = buildService();

        final result = await service.create(
          buildDraft(
            status: FinancialEntryStatus.pending,
            paidAt: DateTime(2026, 8, 6, 9, 0),
          ),
        );

        expect(result.entry!.status, FinancialEntryStatus.pending);
        expect(result.entry!.paidAt, isNull);
      });

      test('returns failure when the repository throws', () async {
        entryRepository.shouldFailOnNextOperation = true;
        final service = buildService();

        final result = await service.create(buildDraft());

        expect(result.status, FinancialEntryWriteStatus.failure);
      });
    });

    group('update', () {
      test('returns notFound for an unknown id', () async {
        final service = buildService();

        final result = await service.update(
          buildDraft(id: 'missing', description: 'Editada'),
        );

        expect(result.status, FinancialEntryWriteStatus.notFound);
      });

      test('preserves id and createdAt while updating updatedAt from the clock', () async {
        final existing = buildDraft(id: 'entry-1');
        await entryRepository.insert(existing);
        final service = buildService();

        final result = await service.update(
          existing.copyWith(description: 'Aluguel revisado'),
        );

        expect(result.isSuccess, isTrue);
        expect(result.entry!.id, existing.id);
        expect(result.entry!.createdAt, existing.createdAt);
        expect(result.entry!.updatedAt, fixedNow);
        expect(result.entry!.description, 'Aluguel revisado');
      });

      test('rejects an unknown categoryId and does not persist', () async {
        final existing = buildDraft(id: 'entry-1');
        await entryRepository.insert(existing);
        final service = buildService();

        final result = await service.update(
          existing.copyWith(categoryId: 'missing-category'),
        );

        expect(result.status, FinancialEntryWriteStatus.categoryNotFound);
        expect(
          (await entryRepository.findById('entry-1'))?.categoryId,
          existing.categoryId,
        );
      });

      test(
        'moving from paid back to pending clears paidAt',
        () async {
          final existing = buildDraft(
            id: 'entry-1',
            status: FinancialEntryStatus.paid,
            paidAt: DateTime(2026, 8, 6, 9, 0),
          );
          await entryRepository.insert(existing);
          final service = buildService();

          final result = await service.update(
            existing.copyWith(status: FinancialEntryStatus.pending),
          );

          expect(result.entry!.status, FinancialEntryStatus.pending);
          expect(result.entry!.paidAt, isNull);
        },
      );

      test(
        'moving from pending to paid without informing paidAt fills it from the clock',
        () async {
          final existing = buildDraft(id: 'entry-1');
          await entryRepository.insert(existing);
          final service = buildService();

          final result = await service.update(
            existing.copyWith(status: FinancialEntryStatus.paid),
          );

          expect(result.entry!.status, FinancialEntryStatus.paid);
          expect(result.entry!.paidAt, fixedNow);
        },
      );

      test('returns failure when the repository throws', () async {
        final existing = buildDraft(id: 'entry-1');
        await entryRepository.insert(existing);
        entryRepository.shouldFailOnNextOperation = true;
        final service = buildService();

        final result = await service.update(
          existing.copyWith(description: 'Nova descrição'),
        );

        expect(result.status, FinancialEntryWriteStatus.failure);
      });
    });

    group('delete', () {
      test('returns notFound for an unknown id', () async {
        final service = buildService();

        final result = await service.delete('missing');

        expect(result.status, FinancialEntryDeleteStatus.notFound);
      });

      test('deletes an existing entry', () async {
        final existing = buildDraft(id: 'entry-1');
        await entryRepository.insert(existing);
        final service = buildService();

        final result = await service.delete('entry-1');

        expect(result.isDeleted, isTrue);
        expect(await entryRepository.findById('entry-1'), isNull);
      });

      test('returns failure when the repository throws', () async {
        final existing = buildDraft(id: 'entry-1');
        await entryRepository.insert(existing);
        entryRepository.shouldFailOnNextOperation = true;
        final service = buildService();

        final result = await service.delete('entry-1');

        expect(result.status, FinancialEntryDeleteStatus.failure);
      });
    });
  });
}
