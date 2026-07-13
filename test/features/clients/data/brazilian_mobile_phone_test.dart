import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/data/utils/brazilian_mobile_phone.dart';

void main() {
  group('BrazilianMobilePhone', () {
    test('aceita celular com DDD e 9 dígitos', () {
      expect(
        BrazilianMobilePhone.normalizeWhatsAppDigits('11987654321'),
        '5511987654321',
      );
    });

    test('aceita celular já com prefixo 55', () {
      expect(
        BrazilianMobilePhone.normalizeWhatsAppDigits('5511987654321'),
        '5511987654321',
      );
    });

    test('rejeita telefone fixo', () {
      expect(
        BrazilianMobilePhone.normalizeWhatsAppDigits('1133334444'),
        isNull,
      );
    });

    test('rejeita formato duvidoso', () {
      expect(
        BrazilianMobilePhone.normalizeWhatsAppDigits('12345'),
        isNull,
      );
    });
  });
}
