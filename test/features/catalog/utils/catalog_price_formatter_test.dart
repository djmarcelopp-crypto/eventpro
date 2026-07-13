import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/utils/catalog_price_formatter.dart';

void main() {
  group('CatalogPriceFormatter', () {
    test('format exibe valor em pt-BR com símbolo', () {
      expect(CatalogPriceFormatter.format(1500), 'R\$ 1.500,00');
      expect(CatalogPriceFormatter.format(0.5), 'R\$ 0,50');
      expect(CatalogPriceFormatter.format(1000000), 'R\$ 1.000.000,00');
    });

    test('formatForInput exibe sem símbolo', () {
      expect(CatalogPriceFormatter.formatForInput(1500), '1.500,00');
    });

    test('formatEditable preserva centavos parciais', () {
      expect(CatalogPriceFormatter.formatEditable('10,5'), '10,5');
      expect(CatalogPriceFormatter.formatEditable('1.500,75'), '1.500,75');
      expect(CatalogPriceFormatter.formatEditable('10,'), '10,');
    });

    test('parse aceita 1500', () {
      expect(CatalogPriceFormatter.parse('1500'), 1500);
    });

    test('parse aceita 1500,00', () {
      expect(CatalogPriceFormatter.parse('1500,00'), 1500);
    });

    test('parse aceita 1.500,00', () {
      expect(CatalogPriceFormatter.parse('1.500,00'), 1500);
    });

    test('parse aceita 1.500 sem decimais', () {
      expect(CatalogPriceFormatter.parse('1.500'), 1500);
    });

    test('parse aceita valor colado com R\$ e espaços', () {
      expect(CatalogPriceFormatter.parse('R\$ 1.500,00'), 1500);
      expect(CatalogPriceFormatter.parse(' R\$  2.500,50 '), 2500.5);
    });

    test('parse aceita formato com ponto decimal', () {
      expect(CatalogPriceFormatter.parse('1500.00'), 1500);
    });

    test('parse retorna null para entrada inválida', () {
      expect(CatalogPriceFormatter.parse(''), isNull);
      expect(CatalogPriceFormatter.parse('abc'), isNull);
      expect(CatalogPriceFormatter.parse('12,34,56'), isNull);
    });
  });
}
