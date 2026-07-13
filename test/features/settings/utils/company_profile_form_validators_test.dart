import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/settings/models/company_profile.dart';
import 'package:eventpro/features/settings/models/company_quote_defaults.dart';
import 'package:eventpro/features/settings/models/pix_key_type.dart';
import 'package:eventpro/features/settings/utils/company_profile_form_validators.dart';

void main() {
  group('CompanyProfileFormValidators', () {
    test('exige nome comercial', () {
      expect(
        CompanyProfileFormValidators.validateTradeName(''),
        isNotNull,
      );
      expect(
        CompanyProfileFormValidators.validateTradeName('DJ Marcelo'),
        isNull,
      );
    });

    test('exige pelo menos um contato', () {
      expect(
        CompanyProfileFormValidators.validateAtLeastOneContact(
          phone: null,
          whatsApp: null,
          email: null,
        ),
        isNotNull,
      );
      expect(
        CompanyProfileFormValidators.validateAtLeastOneContact(
          phone: '67999998888',
          whatsApp: null,
          email: null,
        ),
        isNull,
      );
    });

    test('validade padrão deve ser maior que zero', () {
      const message = 'A validade padrão deve ser maior que zero';

      expect(
        CompanyProfileFormValidators.validateDefaultValidityDays(''),
        'Informe a validade padrão em dias',
      );
      expect(
        CompanyProfileFormValidators.validateDefaultValidityDays('0'),
        message,
      );
      expect(
        CompanyProfileFormValidators.validateDefaultValidityDays('-3'),
        message,
      );
      expect(
        CompanyProfileFormValidators.validateDefaultValidityDays('abc'),
        message,
      );
      expect(
        CompanyProfileFormValidators.validateDefaultValidityDays('7.5'),
        message,
      );
      expect(
        CompanyProfileFormValidators.validateDefaultValidityDays('7'),
        isNull,
      );
      expect(
        CompanyProfileFormValidators.validateDefaultValidityDays('30'),
        isNull,
      );
    });

    test('isMinimumValid exige nome, contato e validade maior que zero', () {
      expect(
        CompanyProfileFormValidators.isMinimumValid(
          CompanyProfile(
            tradeName: '',
            phoneDigits: '67999998888',
            quoteDefaults: const CompanyQuoteDefaults(defaultValidityDays: 7),
            createdAt: DateTime(2026, 7, 13),
            updatedAt: DateTime(2026, 7, 13),
          ),
        ),
        isFalse,
      );
      expect(
        CompanyProfileFormValidators.isMinimumValid(
          CompanyProfile(
            tradeName: 'DJ Marcelo PP',
            phoneDigits: null,
            email: null,
            quoteDefaults: const CompanyQuoteDefaults(defaultValidityDays: 7),
            createdAt: DateTime(2026, 7, 13),
            updatedAt: DateTime(2026, 7, 13),
          ),
        ),
        isFalse,
      );
      expect(
        CompanyProfileFormValidators.isMinimumValid(
          CompanyProfile(
            tradeName: 'DJ Marcelo PP',
            phoneDigits: '67999998888',
            quoteDefaults: const CompanyQuoteDefaults(defaultValidityDays: 0),
            createdAt: DateTime(2026, 7, 13),
            updatedAt: DateTime(2026, 7, 13),
          ),
        ),
        isFalse,
      );
      expect(
        CompanyProfileFormValidators.isMinimumValid(
          CompanyProfile(
            tradeName: 'DJ Marcelo PP',
            phoneDigits: '67999998888',
            quoteDefaults: const CompanyQuoteDefaults(defaultValidityDays: 7),
            createdAt: DateTime(2026, 7, 13),
            updatedAt: DateTime(2026, 7, 13),
          ),
        ),
        isTrue,
      );
    });

    test('responsável legal condicional exige nome e CPF quando iniciado', () {
      expect(
        CompanyProfileFormValidators.validateLegalRepresentative(
          fullName: '',
          cpf: '',
          role: '',
        ),
        isNull,
      );
      expect(
        CompanyProfileFormValidators.validateLegalRepresentative(
          fullName: 'Maria Silva',
          cpf: '',
          role: '',
        ),
        isNotNull,
      );
      expect(
        CompanyProfileFormValidators.validateLegalRepresentative(
          fullName: 'Maria Silva',
          cpf: '52998224725',
          role: 'Sócia',
        ),
        isNull,
      );
    });

    test('PIX não é exigido quando apenas condições de pagamento são preenchidas', () {
      expect(
        CompanyProfileFormValidators.validatePix(
          pixKeyType: null,
          pixKey: '',
        ),
        isNull,
      );
    });

    test('PIX exige tipo e chave quando um deles é preenchido', () {
      expect(
        CompanyProfileFormValidators.validatePix(
          pixKeyType: PixKeyType.email,
          pixKey: '',
        ),
        isNotNull,
      );
      expect(
        CompanyProfileFormValidators.validatePix(
          pixKeyType: null,
          pixKey: 'contato@empresa.com',
        ),
        isNotNull,
      );
      expect(
        CompanyProfileFormValidators.validatePix(
          pixKeyType: PixKeyType.email,
          pixKey: 'contato@empresa.com',
        ),
        isNull,
      );
    });

    test('erro de PIX não expõe a chave informada', () {
      const secretKey = 'segredo-super-secreto@empresa.com';
      final error = CompanyProfileFormValidators.validatePix(
        pixKeyType: PixKeyType.email,
        pixKey: 'invalido',
      );

      expect(error, isNotNull);
      expect(error!, isNot(contains(secretKey)));
      expect(error, 'Chave PIX inválida para o tipo selecionado');
    });
  });
}
