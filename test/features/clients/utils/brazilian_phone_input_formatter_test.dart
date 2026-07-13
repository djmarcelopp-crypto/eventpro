import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/utils/text_input_masks.dart';

void main() {
  group('BrazilianPhoneInputFormatter', () {
    test('formata telefone fixo', () {
      expect(
        BrazilianPhoneInputFormatter.formatFromDigits('6732321234'),
        '(67) 3232-1234',
      );
    });

    test('formata celular', () {
      expect(
        BrazilianPhoneInputFormatter.formatFromDigits('67981495959'),
        '(67) 98149-5959',
      );
    });

    test('remove prefixo 55 ao formatar', () {
      expect(
        BrazilianPhoneInputFormatter.formatFromDigits('5567981495959'),
        '(67) 98149-5959',
      );
    });

    test('usa máscara de celular quando terceiro dígito é 9', () {
      expect(
        BrazilianPhoneInputFormatter.formatFromDigits('679'),
        '(67) 9',
      );
    });
  });
}
