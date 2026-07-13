import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/utils/quote_quantity_input_formatter.dart';

void main() {
  const formatter = QuoteQuantityInputFormatter();

  TextEditingValue format(String oldText, String newText, {int? cursor}) {
    return formatter.formatEditUpdate(
      TextEditingValue(
        text: oldText,
        selection: TextSelection.collapsed(
          offset: cursor ?? oldText.length,
        ),
      ),
      TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: cursor ?? newText.length,
        ),
      ),
    );
  }

  group('QuoteQuantityInputFormatter', () {
    test('digitação incremental de 1,5', () {
      var value = format('', '1');
      expect(value.text, '1');

      value = format(value.text, '1,', cursor: 2);
      expect(value.text, '1,');

      value = format(value.text, '1,5', cursor: 3);
      expect(value.text, '1,5');
    });

    test('digitação incremental de 1,125', () {
      var value = format('', '1');
      value = format(value.text, '1,');
      value = format(value.text, '1,1');
      value = format(value.text, '1,12');
      value = format(value.text, '1,125');

      expect(value.text, '1,125');
    });

    test('aceita ponto e normaliza para vírgula', () {
      final value = format('', '1.5');
      expect(value.text, '1,5');
    });
  });
}
