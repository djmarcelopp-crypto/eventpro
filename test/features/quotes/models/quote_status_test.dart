import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/core/theme/app_colors.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';

void main() {
  group('QuoteStatus', () {
    test('labels em português', () {
      expect(QuoteStatus.draft.label, 'Rascunho');
      expect(QuoteStatus.sent.label, 'Enviado');
      expect(QuoteStatus.approved.label, 'Aprovado');
      expect(QuoteStatus.rejected.label, 'Recusado');
      expect(QuoteStatus.cancelled.label, 'Cancelado');
    });

    test('cores do design system', () {
      expect(QuoteStatus.draft.color, AppColors.secondaryText);
      expect(QuoteStatus.sent.color, AppColors.primary);
      expect(QuoteStatus.approved.color, AppColors.success);
      expect(QuoteStatus.rejected.color, AppColors.error);
      expect(QuoteStatus.cancelled.color, AppColors.warning);
    });
  });
}
