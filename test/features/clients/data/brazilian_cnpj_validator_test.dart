import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/data/utils/brazilian_cnpj_validator.dart';

void main() {
  group('BrazilianCnpjValidator', () {
    test('aceita CNPJ válido usado nos testes', () {
      expect(BrazilianCnpjValidator.isValid('11222333000181'), isTrue);
    });

    test('rejeita CNPJ com dígito verificador inválido', () {
      expect(BrazilianCnpjValidator.isValid('12345678000199'), isFalse);
    });

    test('rejeita sequência repetida', () {
      expect(BrazilianCnpjValidator.isValid('11111111111111'), isFalse);
    });

    test('rejeita tamanho incorreto', () {
      expect(BrazilianCnpjValidator.isValid('123'), isFalse);
    });
  });
}
