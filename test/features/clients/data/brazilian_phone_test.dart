import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/data/utils/brazilian_phone.dart';

void main() {
  group('BrazilianPhone', () {
    test('normaliza telefone fixo com 10 dígitos', () {
      expect(
        BrazilianPhone.normalizeNationalDigits('6732321234'),
        '6732321234',
      );
    });

    test('normaliza celular com 11 dígitos', () {
      expect(
        BrazilianPhone.normalizeNationalDigits('67981495959'),
        '67981495959',
      );
    });

    test('remove prefixo 55 antes de validar', () {
      expect(
        BrazilianPhone.normalizeNationalDigits('5567981495959'),
        '67981495959',
      );
    });

    test('remove caracteres não numéricos', () {
      expect(
        BrazilianPhone.normalizeNationalDigits('(67) 3232-1234'),
        '6732321234',
      );
    });

    test('rejeita DDD inválido', () {
      expect(
        BrazilianPhone.normalizeNationalDigits('0536354333'),
        isNull,
      );
    });

    test('rejeita quantidade inválida de dígitos', () {
      expect(
        BrazilianPhone.normalizeNationalDigits('12345'),
        isNull,
      );
    });
  });
}
