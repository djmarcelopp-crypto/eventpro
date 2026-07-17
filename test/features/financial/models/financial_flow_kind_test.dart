import 'package:eventpro/core/theme/app_colors.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FinancialFlowKind', () {
    test('labels em português', () {
      expect(FinancialFlowKind.income.label, 'Receita');
      expect(FinancialFlowKind.expense.label, 'Despesa');
    });

    test('cores do design system', () {
      expect(FinancialFlowKind.income.color, AppColors.success);
      expect(FinancialFlowKind.expense.color, AppColors.error);
    });
  });
}
