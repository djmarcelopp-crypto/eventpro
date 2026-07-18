import 'package:eventpro/features/financial/models/financial_entry.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:eventpro/features/financial/utils/financial_event_summary_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_financial_entry_repository.dart';

void main() {
  group('FinancialEventSummaryService', () {
    late FakeFinancialEntryRepository entryRepository;
    final createdAt = DateTime(2026, 8, 1, 9, 0);

    FinancialEntry buildEntry({
      required String id,
      required FinancialFlowKind kind,
      required int amountCents,
      String? quoteId,
    }) {
      return FinancialEntry(
        id: id,
        kind: kind,
        description: 'Lançamento $id',
        amountCents: amountCents,
        date: DateTime(2026, 8, 5),
        categoryId: 'category-1',
        quoteId: quoteId,
        createdAt: createdAt,
        updatedAt: createdAt,
      );
    }

    setUp(() {
      entryRepository = FakeFinancialEntryRepository();
    });

    test(
      'fetches entries linked to the quote via the repository and computes the summary',
      () async {
        await entryRepository.insert(
          buildEntry(
            id: 'income',
            kind: FinancialFlowKind.income,
            amountCents: 200000,
            quoteId: 'quote-1',
          ),
        );
        await entryRepository.insert(
          buildEntry(
            id: 'expense',
            kind: FinancialFlowKind.expense,
            amountCents: 80000,
            quoteId: 'quote-1',
          ),
        );
        await entryRepository.insert(
          buildEntry(
            id: 'other-event',
            kind: FinancialFlowKind.income,
            amountCents: 999999,
            quoteId: 'quote-2',
          ),
        );
        final service = FinancialEventSummaryService(
          entryRepository: entryRepository,
        );

        final summary = await service.summaryForQuote('quote-1');

        expect(summary.quoteId, 'quote-1');
        expect(summary.totalIncomeCents, 200000);
        expect(summary.totalExpenseCents, 80000);
        expect(summary.profitCents, 120000);
        expect(summary.entries.map((entry) => entry.id).toSet(), {
          'income',
          'expense',
        });
      },
    );

    test('returns a zeroed summary when the quote has no linked entries', () async {
      final service = FinancialEventSummaryService(
        entryRepository: entryRepository,
      );

      final summary = await service.summaryForQuote('quote-without-entries');

      expect(summary.hasEntries, isFalse);
      expect(summary.totalIncomeCents, 0);
      expect(summary.totalExpenseCents, 0);
      expect(summary.profitCents, 0);
    });
  });
}
