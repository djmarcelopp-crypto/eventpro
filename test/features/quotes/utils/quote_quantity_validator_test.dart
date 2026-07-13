import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/utils/quote_quantity_validator.dart';

void main() {
  group('QuoteQuantityValidator', () {
    test('aceita quantidades válidas', () {
      expect(QuoteQuantityValidator.isValid(1.5), isTrue);
      expect(QuoteQuantityValidator.isValid(1.125), isTrue);
      expect(QuoteQuantityValidator.isValid(0.001), isTrue);
      expect(QuoteQuantityValidator.isValid(10), isTrue);
    });

    test('rejeita quantidades inválidas', () {
      expect(QuoteQuantityValidator.isValid(0), isFalse);
      expect(QuoteQuantityValidator.isValid(-1), isFalse);
      expect(QuoteQuantityValidator.isValid(1.0001), isFalse);
    });
  });
}
