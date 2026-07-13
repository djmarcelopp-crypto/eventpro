import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote_line_item.dart';
import '../quotes_test_helpers.dart';

void main() {
  group('QuoteLineItem', () {
    test('fromCatalogItem converte preço e calcula linha', () {
      final item = QuoteLineItem.fromCatalogItem(
        sampleCatalogItem(price: 1500),
        quantity: 2,
      );

      expect(item.catalogItemId, 'item-1');
      expect(item.name, 'Caixa de som');
      expect(item.unitPriceCents, 150_000);
      expect(item.lineTotalCents, 300_000);
    });

    test('fromCatalogItem aceita quantidade fracionada', () {
      final item = QuoteLineItem.fromCatalogItem(
        sampleCatalogItem(price: 100),
        quantity: 1.5,
      );

      expect(item.lineTotalCents, 15_000);
    });

    test('rejeita quantidade inválida', () {
      expect(
        () => QuoteLineItem.fromCatalogItem(
          sampleCatalogItem(),
          quantity: 1.0001,
        ),
        throwsArgumentError,
      );
    });
  });
}
