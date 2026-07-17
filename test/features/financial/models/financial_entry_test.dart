import 'package:eventpro/features/financial/models/financial_entry.dart';
import 'package:eventpro/features/financial/models/financial_entry_status.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FinancialEntry', () {
    FinancialEntry buildEntry({
      FinancialFlowKind kind = FinancialFlowKind.expense,
      FinancialEntryStatus status = FinancialEntryStatus.pending,
      DateTime? paidAt,
      String? notes,
      String? quoteId,
    }) {
      return FinancialEntry(
        id: 'entry-1',
        kind: kind,
        description: 'Aluguel do galpão',
        amountCents: 150000,
        date: DateTime(2026, 8, 5),
        categoryId: 'category-1',
        status: status,
        paidAt: paidAt,
        notes: notes,
        quoteId: quoteId,
        createdAt: DateTime(2026, 8, 1, 9, 0),
        updatedAt: DateTime(2026, 8, 1, 9, 0),
      );
    }

    test('status defaults to pending and paidAt/notes default to null', () {
      final entry = FinancialEntry(
        id: 'entry-1',
        kind: FinancialFlowKind.income,
        description: 'Sinal do evento',
        amountCents: 200000,
        date: DateTime(2026, 8, 5),
        categoryId: 'category-1',
        createdAt: DateTime(2026, 8, 1),
        updatedAt: DateTime(2026, 8, 1),
      );

      expect(entry.status, FinancialEntryStatus.pending);
      expect(entry.paidAt, isNull);
      expect(entry.notes, isNull);
      expect(entry.quoteId, isNull);
    });

    test('isIncome and isExpense reflect kind', () {
      final income = buildEntry(kind: FinancialFlowKind.income);
      final expense = buildEntry(kind: FinancialFlowKind.expense);

      expect(income.isIncome, isTrue);
      expect(income.isExpense, isFalse);
      expect(expense.isIncome, isFalse);
      expect(expense.isExpense, isTrue);
    });

    test('isPaid reflects status', () {
      final pending = buildEntry(status: FinancialEntryStatus.pending);
      final paid = buildEntry(status: FinancialEntryStatus.paid);

      expect(pending.isPaid, isFalse);
      expect(paid.isPaid, isTrue);
    });

    test('copyWith preserves original values when no override is given', () {
      final original = buildEntry(notes: 'Pago via Pix');

      final copy = original.copyWith();

      expect(copy.id, original.id);
      expect(copy.kind, original.kind);
      expect(copy.description, original.description);
      expect(copy.amountCents, original.amountCents);
      expect(copy.date, original.date);
      expect(copy.categoryId, original.categoryId);
      expect(copy.status, original.status);
      expect(copy.paidAt, original.paidAt);
      expect(copy.notes, original.notes);
      expect(copy.createdAt, original.createdAt);
      expect(copy.updatedAt, original.updatedAt);
    });

    test('copyWith overrides only the informed fields', () {
      final original = buildEntry();
      final paidAt = DateTime(2026, 8, 6, 10, 0);

      final updated = original.copyWith(
        status: FinancialEntryStatus.paid,
        paidAt: paidAt,
        amountCents: 175000,
      );

      expect(updated.status, FinancialEntryStatus.paid);
      expect(updated.paidAt, paidAt);
      expect(updated.amountCents, 175000);
      expect(updated.id, original.id);
      expect(updated.description, original.description);
      expect(updated.categoryId, original.categoryId);
    });

    test('copyWith clearPaidAt removes existing paidAt', () {
      final original = buildEntry(
        status: FinancialEntryStatus.paid,
        paidAt: DateTime(2026, 8, 6, 10, 0),
      );

      final cleared = original.copyWith(clearPaidAt: true);

      expect(cleared.paidAt, isNull);
    });

    test('copyWith without clearPaidAt keeps existing paidAt', () {
      final paidAt = DateTime(2026, 8, 6, 10, 0);
      final original = buildEntry(
        status: FinancialEntryStatus.paid,
        paidAt: paidAt,
      );

      final copy = original.copyWith(amountCents: 160000);

      expect(copy.paidAt, paidAt);
    });

    test('copyWith clearNotes removes existing notes', () {
      final original = buildEntry(notes: 'Pago via Pix');

      final cleared = original.copyWith(clearNotes: true);

      expect(cleared.notes, isNull);
    });

    test('copyWith without clearNotes keeps existing notes', () {
      final original = buildEntry(notes: 'Pago via Pix');

      final copy = original.copyWith(amountCents: 160000);

      expect(copy.notes, 'Pago via Pix');
    });

    test('copyWith sets quoteId to link an entry to an event', () {
      final original = buildEntry();

      final linked = original.copyWith(quoteId: 'quote-1');

      expect(linked.quoteId, 'quote-1');
    });

    test('copyWith clearQuoteId removes an existing quoteId', () {
      final original = buildEntry(quoteId: 'quote-1');

      final unlinked = original.copyWith(clearQuoteId: true);

      expect(unlinked.quoteId, isNull);
    });

    test('copyWith without clearQuoteId keeps existing quoteId', () {
      final original = buildEntry(quoteId: 'quote-1');

      final copy = original.copyWith(amountCents: 160000);

      expect(copy.quoteId, 'quote-1');
    });
  });
}
