import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/utils/quote_quantity_parser.dart';

void main() {
  group('QuoteQuantityParser', () {
    test('aceita vírgula como separador decimal', () {
      expect(QuoteQuantityParser.tryParse('1,5'), 1.5);
    });

    test('aceita ponto como separador decimal', () {
      expect(QuoteQuantityParser.tryParse('1.5'), 1.5);
    });

    test('aceita até 3 casas decimais', () {
      expect(QuoteQuantityParser.tryParse('1,125'), 1.125);
    });

    test('retorna null para vazio ou inválido', () {
      expect(QuoteQuantityParser.tryParse(''), isNull);
      expect(QuoteQuantityParser.tryParse('0'), isNull);
      expect(QuoteQuantityParser.tryParse('1,0001'), isNull);
    });

    test('valida quantidade incompleta durante digitação', () {
      expect(
        QuoteQuantityParser.validateForDisplay('1,'),
        'Quantidade incompleta',
      );
    });
  });
}
