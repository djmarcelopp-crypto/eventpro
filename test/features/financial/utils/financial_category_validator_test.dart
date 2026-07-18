import 'package:eventpro/features/financial/models/financial_category.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:eventpro/features/financial/utils/financial_category_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FinancialCategoryValidator', () {
    FinancialCategory buildCategory({String name = 'Aluguel de equipamentos'}) {
      return FinancialCategory(
        id: 'category-1',
        name: name,
        kind: FinancialFlowKind.expense,
        createdAt: DateTime(2026, 1, 10),
      );
    }

    test('accepts a fully valid category', () {
      final result = FinancialCategoryValidator.validate(buildCategory());

      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('rejects empty name', () {
      final result = FinancialCategoryValidator.validateFields(name: '');

      expect(result.isValid, isFalse);
      expect(
        result.errors,
        contains(FinancialCategoryValidator.nameRequiredError),
      );
    });

    test('rejects blank (whitespace-only) name', () {
      final result = FinancialCategoryValidator.validateFields(name: '   ');

      expect(result.isValid, isFalse);
      expect(
        result.errors,
        contains(FinancialCategoryValidator.nameRequiredError),
      );
    });

    test('rejects null name', () {
      final result = FinancialCategoryValidator.validateFields(name: null);

      expect(result.isValid, isFalse);
      expect(
        result.errors,
        contains(FinancialCategoryValidator.nameRequiredError),
      );
    });
  });
}
