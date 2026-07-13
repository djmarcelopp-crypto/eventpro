import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/utils/quote_date_formatter.dart';
import 'package:eventpro/features/quotes/utils/quote_form_validators.dart';

void main() {
  group('QuoteFormValidators', () {
    test('rejeita validade anterior à data atual', () {
      final today = DateTime(2026, 7, 13, 15, 30);
      final yesterday = DateTime(2026, 7, 12);

      expect(
        QuoteFormValidators.validateValidUntil(yesterday, today),
        'A validade não pode ser anterior à data atual',
      );
    });

    test('aceita validade na data atual ignorando horário', () {
      final todayMorning = DateTime(2026, 7, 13, 8);
      final todayEvening = DateTime(2026, 7, 13, 22, 45);

      expect(
        QuoteFormValidators.validateValidUntil(todayEvening, todayMorning),
        isNull,
      );
    });

    test('aceita validade futura', () {
      final today = DateTime(2026, 7, 13);
      final future = QuoteDateFormatter.addDays(today, 7);

      expect(
        QuoteFormValidators.validateValidUntil(future, today),
        isNull,
      );
    });
  });
}
