import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/utils/quote_money.dart';

void main() {
  group('QuoteMoney', () {
    test('converte reais para centavos', () {
      expect(QuoteMoney.reaisToCents(1500), 150_000);
      expect(QuoteMoney.reaisToCents(10.50), 1050);
      expect(QuoteMoney.reaisToCents(99.99), 9999);
    });

    test('converte centavos para reais', () {
      expect(QuoteMoney.centsToReais(150_000), 1500);
      expect(QuoteMoney.centsToReais(1050), 10.5);
    });
  });
}
