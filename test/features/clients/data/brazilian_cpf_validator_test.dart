import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/data/utils/brazilian_cpf_validator.dart';

void main() {
  group('BrazilianCpfValidator', () {
    test('aceita CPF válido', () {
      expect(BrazilianCpfValidator.isValid('52998224725'), isTrue);
    });

    test('rejeita CPF com dígito verificador inválido', () {
      expect(BrazilianCpfValidator.isValid('12345678901'), isFalse);
    });

    test('rejeita sequência repetida', () {
      expect(BrazilianCpfValidator.isValid('11111111111'), isFalse);
    });

    test('rejeita tamanho incorreto', () {
      expect(BrazilianCpfValidator.isValid('123'), isFalse);
    });
  });
}
