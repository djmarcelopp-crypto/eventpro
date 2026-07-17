import 'package:eventpro/core/theme/app_colors.dart';
import 'package:eventpro/features/financial/models/financial_entry_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FinancialEntryStatus', () {
    test('labels em português', () {
      expect(FinancialEntryStatus.pending.label, 'Pendente');
      expect(FinancialEntryStatus.paid.label, 'Pago');
    });

    test('cores do design system', () {
      expect(FinancialEntryStatus.pending.color, AppColors.warning);
      expect(FinancialEntryStatus.paid.color, AppColors.success);
    });
  });
}
