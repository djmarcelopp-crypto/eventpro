import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/utils/text_input_masks.dart';

TextEditingValue _formatValue(
  TextInputFormatter formatter,
  String oldText,
  String newText,
) {
  return formatter.formatEditUpdate(
    TextEditingValue(text: oldText),
    TextEditingValue(text: newText),
  );
}

void main() {
  group('DigitMaskFormatter', () {
    test('formata CPF', () {
      final formatter = CpfInputFormatter();
      final result = _formatValue(formatter, '', '12345678901');
      expect(result.text, '123.456.789-01');
    });

    test('formata CNPJ', () {
      final formatter = CnpjInputFormatter();
      final result = _formatValue(formatter, '', '12345678000199');
      expect(result.text, '12.345.678/0001-99');
    });
  });

  group('BrazilianWhatsAppInputFormatter', () {
    test('formata WhatsApp brasileiro completo', () {
      final formatter = BrazilianWhatsAppInputFormatter();
      final result = _formatValue(formatter, '', '5567981495959');
      expect(result.text, '+55 (67) 98149-5959');
    });

    test('adiciona DDI 55 automaticamente', () {
      final formatter = BrazilianWhatsAppInputFormatter();
      final result = _formatValue(formatter, '', '67981495959');
      expect(result.text, '+55 (67) 98149-5959');
    });
  });

  group('UpperCaseTextFormatter', () {
    test('converte UF para maiúsculas e limita a 2 letras', () {
      final formatter = UpperCaseTextFormatter();
      final result = _formatValue(formatter, '', 'sp');
      expect(result.text, 'SP');
    });

    test('remove caracteres não alfabéticos', () {
      final formatter = UpperCaseTextFormatter();
      final result = _formatValue(formatter, '', '1s2');
      expect(result.text, 'S');
    });
  });

  group('applyDigitMask', () {
    test('aplica máscara parcial de CPF', () {
      expect(
        applyDigitMask('123456', '###.###.###-##'),
        '123.456',
      );
    });
  });
}
