import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/utils/quote_calculator.dart';
import '../quotes_test_helpers.dart';

void main() {
  group('QuoteCalculator', () {
    test('calcula total da linha com quantidade fracionada', () {
      expect(
        QuoteCalculator.lineTotalCents(quantity: 1.5, unitPriceCents: 10_000),
        15_000,
      );
      expect(
        QuoteCalculator.lineTotalCents(quantity: 1.125, unitPriceCents: 8000),
        9000,
      );
    });

    test('calcula subtotal e total com desconto e frete', () {
      final items = [
        sampleLineItem(quantity: 2, unitPriceCents: 50_000),
        sampleLineItem(quantity: 1, unitPriceCents: 30_000),
      ];

      expect(QuoteCalculator.subtotalCents(items), 130_000);
      expect(
        QuoteCalculator.totalCents(
          subtotalCents: 130_000,
          discountCents: 10_000,
          freightCents: 5000,
        ),
        125_000,
      );
    });

    test('total não fica negativo', () {
      expect(
        QuoteCalculator.totalCents(
          subtotalCents: 1000,
          discountCents: 5000,
          freightCents: 0,
        ),
        0,
      );
    });
  });
}
