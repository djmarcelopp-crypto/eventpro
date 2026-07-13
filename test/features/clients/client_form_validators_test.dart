import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/client_form_validators.dart';

void main() {
  group('ClientFormValidators', () {
    test('validateName exige nome com pelo menos 2 caracteres', () {
      expect(ClientFormValidators.validateName(null), 'Informe o nome do cliente');
      expect(ClientFormValidators.validateName('A'), 'Nome deve ter pelo menos 2 caracteres');
      expect(ClientFormValidators.validateName('Maria Silva'), isNull);
    });

    test('validateWhatsApp exige 13 dígitos com DDI 55', () {
      expect(ClientFormValidators.validateWhatsApp(null), 'Informe o WhatsApp');
      expect(
        ClientFormValidators.validateWhatsApp('+55 (67) 9814'),
        'WhatsApp inválido',
      );
      expect(
        ClientFormValidators.validateWhatsApp('+55 (67) 98149-5959'),
        isNull,
      );
    });

    test('validateEmail valida somente quando preenchido', () {
      expect(ClientFormValidators.validateEmail(null), isNull);
      expect(ClientFormValidators.validateEmail('email-invalido'), 'E-mail inválido');
      expect(ClientFormValidators.validateEmail('maria@email.com'), isNull);
    });

    test('validatePostalCode valida somente quando preenchido', () {
      expect(ClientFormValidators.validatePostalCode(null), isNull);
      expect(ClientFormValidators.validatePostalCode('123'), 'CEP inválido');
      expect(ClientFormValidators.validatePostalCode('79002-050'), isNull);
    });

    test('validateCpf valida dígitos verificadores quando preenchido', () {
      expect(ClientFormValidators.validateCpf(null), isNull);
      expect(ClientFormValidators.validateCpf('123'), 'CPF inválido');
      expect(ClientFormValidators.validateCpf('123.456.789-01'), 'CPF inválido');
      expect(ClientFormValidators.validateCpf('529.982.247-25'), isNull);
    });

    test('validateCnpj valida dígitos verificadores quando preenchido', () {
      expect(ClientFormValidators.validateCnpj(null), isNull);
      expect(ClientFormValidators.validateCnpj('123'), 'CNPJ inválido');
      expect(ClientFormValidators.validateCnpj('12.345.678/0001-99'), 'CNPJ inválido');
      expect(ClientFormValidators.validateCnpj('11.222.333/0001-81'), isNull);
    });

    test('validateState valida UF com 2 letras', () {
      expect(ClientFormValidators.validateState(null), isNull);
      expect(ClientFormValidators.validateState('S'), 'UF inválida');
      expect(ClientFormValidators.validateState('SP'), isNull);
    });

    test('validateBirthday rejeita datas futuras', () {
      expect(ClientFormValidators.validateBirthday(null), isNull);
      expect(
        ClientFormValidators.validateBirthday(
          DateTime.now().add(const Duration(days: 1)),
        ),
        'Data de aniversário não pode ser futura',
      );
      expect(
        ClientFormValidators.validateBirthday(DateTime(1990, 5, 10)),
        isNull,
      );
    });
  });
}
