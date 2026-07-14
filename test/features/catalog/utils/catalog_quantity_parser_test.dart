import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/utils/catalog_quantity_parser.dart';
import 'package:eventpro/features/catalog/utils/catalog_quantity_validator.dart';

void main() {
  group('CatalogQuantityParser', () {
    test('aceita vírgula e ponto com até 3 casas decimais', () {
      expect(CatalogQuantityParser.tryParse('1,5'), 1.5);
      expect(CatalogQuantityParser.tryParse('2.25'), 2.25);
      expect(CatalogQuantityParser.tryParse('3,125'), 3.125);
    });

    test('rejeita zero e mais de 3 casas decimais', () {
      expect(CatalogQuantityParser.tryParse('0'), isNull);
      expect(CatalogQuantityParser.tryParse('1,2345'), isNull);
      expect(CatalogQuantityValidator.isValid(1.2345), isFalse);
    });

    test('formata quantidade para input', () {
      expect(CatalogQuantityParser.formatForInput(2), '2');
      expect(CatalogQuantityParser.formatForInput(1.5), '1,5');
    });
  });
}
