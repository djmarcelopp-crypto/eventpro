import 'package:eventpro/features/financial/models/financial_category.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FinancialCategory', () {
    FinancialCategory buildCategory({
      FinancialFlowKind kind = FinancialFlowKind.expense,
      bool active = true,
    }) {
      return FinancialCategory(
        id: 'category-1',
        name: 'Locação de espaço',
        kind: kind,
        active: active,
        createdAt: DateTime(2026, 1, 10, 9, 0),
      );
    }

    test('active defaults to true when not informed', () {
      final category = FinancialCategory(
        id: 'category-1',
        name: 'Aluguel de equipamentos',
        kind: FinancialFlowKind.expense,
        createdAt: DateTime(2026, 1, 10),
      );

      expect(category.active, isTrue);
    });

    test('copyWith preserves original values when no override is given', () {
      final original = buildCategory();

      final copy = original.copyWith();

      expect(copy.id, original.id);
      expect(copy.name, original.name);
      expect(copy.kind, original.kind);
      expect(copy.active, original.active);
      expect(copy.createdAt, original.createdAt);
    });

    test('copyWith overrides only the informed fields', () {
      final original = buildCategory();

      final updated = original.copyWith(
        name: 'Locação de espaço (renomeada)',
        active: false,
      );

      expect(updated.name, 'Locação de espaço (renomeada)');
      expect(updated.active, isFalse);
      expect(updated.id, original.id);
      expect(updated.kind, original.kind);
      expect(updated.createdAt, original.createdAt);
    });

    test('income and expense categories keep the informed kind', () {
      final income = buildCategory(kind: FinancialFlowKind.income);
      final expense = buildCategory(kind: FinancialFlowKind.expense);

      expect(income.kind, FinancialFlowKind.income);
      expect(expense.kind, FinancialFlowKind.expense);
    });
  });
}
