import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/providers/quote_number_generator.dart';

void main() {
  group('QuoteNumberGenerator', () {
    test('gera números sequenciais no mesmo ano', () {
      final generator = QuoteNumberGenerator();
      final date = DateTime(2026, 6, 15);

      expect(generator.nextNumber(referenceDate: date), 'ORC-2026-0001');
      expect(generator.nextNumber(referenceDate: date), 'ORC-2026-0002');
      expect(generator.nextNumber(referenceDate: date), 'ORC-2026-0003');
    });

    test('reinicia sequência ao mudar o ano', () {
      final generator = QuoteNumberGenerator();

      expect(
        generator.nextNumber(referenceDate: DateTime(2025, 12, 31)),
        'ORC-2025-0001',
      );
      expect(
        generator.nextNumber(referenceDate: DateTime(2026, 1, 1)),
        'ORC-2026-0001',
      );
      expect(
        generator.nextNumber(referenceDate: DateTime(2026, 2, 1)),
        'ORC-2026-0002',
      );
    });

    test('não repete número na mesma sessão', () {
      final generator = QuoteNumberGenerator();
      final numbers = <String>{};
      final date = DateTime(2026, 3, 1);

      for (var i = 0; i < 5; i++) {
        numbers.add(generator.nextNumber(referenceDate: date));
      }

      expect(numbers, hasLength(5));
    });
  });
}
