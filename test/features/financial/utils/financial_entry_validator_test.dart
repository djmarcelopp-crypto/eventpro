import 'package:eventpro/features/financial/models/financial_entry.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:eventpro/features/financial/utils/financial_entry_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FinancialEntryValidator', () {
    final date = DateTime(2026, 8, 5);

    FinancialEntry buildEntry({
      String description = 'Aluguel do galpão',
      int amountCents = 150000,
      DateTime? dateValue,
      String categoryId = 'category-1',
    }) {
      return FinancialEntry(
        id: 'entry-1',
        kind: FinancialFlowKind.expense,
        description: description,
        amountCents: amountCents,
        date: dateValue ?? date,
        categoryId: categoryId,
        createdAt: date,
        updatedAt: date,
      );
    }

    test('accepts a fully valid entry', () {
      final result = FinancialEntryValidator.validate(buildEntry());

      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('rejects empty description', () {
      final result = FinancialEntryValidator.validateFields(
        description: '',
        amountCents: 100,
        date: date,
        categoryId: 'category-1',
      );

      expect(result.isValid, isFalse);
      expect(
        result.errors,
        contains(FinancialEntryValidator.descriptionRequiredError),
      );
    });

    test('rejects blank (whitespace-only) description', () {
      final result = FinancialEntryValidator.validateFields(
        description: '   ',
        amountCents: 100,
        date: date,
        categoryId: 'category-1',
      );

      expect(result.isValid, isFalse);
      expect(
        result.errors,
        contains(FinancialEntryValidator.descriptionRequiredError),
      );
    });

    test('rejects null description', () {
      final result = FinancialEntryValidator.validateFields(
        description: null,
        amountCents: 100,
        date: date,
        categoryId: 'category-1',
      );

      expect(
        result.errors,
        contains(FinancialEntryValidator.descriptionRequiredError),
      );
    });

    test('rejects null amount', () {
      final result = FinancialEntryValidator.validateFields(
        description: 'Aluguel',
        amountCents: null,
        date: date,
        categoryId: 'category-1',
      );

      expect(result.isValid, isFalse);
      expect(
        result.errors,
        contains(FinancialEntryValidator.amountGreaterThanZeroError),
      );
    });

    test('rejects zero amount', () {
      final result = FinancialEntryValidator.validateFields(
        description: 'Aluguel',
        amountCents: 0,
        date: date,
        categoryId: 'category-1',
      );

      expect(result.isValid, isFalse);
      expect(
        result.errors,
        contains(FinancialEntryValidator.amountGreaterThanZeroError),
      );
    });

    test('rejects negative amount', () {
      final result = FinancialEntryValidator.validateFields(
        description: 'Aluguel',
        amountCents: -100,
        date: date,
        categoryId: 'category-1',
      );

      expect(result.isValid, isFalse);
      expect(
        result.errors,
        contains(FinancialEntryValidator.amountGreaterThanZeroError),
      );
    });

    test('rejects missing date', () {
      final result = FinancialEntryValidator.validateFields(
        description: 'Aluguel',
        amountCents: 100,
        date: null,
        categoryId: 'category-1',
      );

      expect(result.isValid, isFalse);
      expect(
        result.errors,
        contains(FinancialEntryValidator.dateRequiredError),
      );
    });

    test('rejects empty categoryId', () {
      final result = FinancialEntryValidator.validateFields(
        description: 'Aluguel',
        amountCents: 100,
        date: date,
        categoryId: '',
      );

      expect(result.isValid, isFalse);
      expect(
        result.errors,
        contains(FinancialEntryValidator.categoryRequiredError),
      );
    });

    test('rejects null categoryId', () {
      final result = FinancialEntryValidator.validateFields(
        description: 'Aluguel',
        amountCents: 100,
        date: date,
        categoryId: null,
      );

      expect(result.isValid, isFalse);
      expect(
        result.errors,
        contains(FinancialEntryValidator.categoryRequiredError),
      );
    });

    test('accumulates multiple errors at once', () {
      final result = FinancialEntryValidator.validateFields(
        description: '',
        amountCents: 0,
        date: null,
        categoryId: null,
      );

      expect(result.errors, hasLength(4));
    });
  });
}
