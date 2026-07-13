import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/core/lookup/form_fill_mode.dart';
import 'package:eventpro/core/lookup/models/cnpj_company_data.dart';
import 'package:eventpro/features/settings/utils/settings_cnpj_form_filler.dart';

void main() {
  group('SettingsCnpjFormFiller', () {
    const fullData = CnpjCompanyData(
      legalName: 'Marcelo PP Festas LTDA',
      tradeName: 'DJ Marcelo PP',
      street: 'RUA EXEMPLO',
      number: '100',
      complement: 'Sala 1',
      neighborhood: 'Centro',
      city: 'Campo Grande',
      state: 'MS',
      postalCode: '79002010',
      phoneDigits: '67999998888',
      whatsAppDigits: '5567999998888',
      email: 'contato@djmarcelo.test',
    );

    test('preenche campos vazios', () {
      const current = SettingsCnpjFormFieldValues();

      final result = SettingsCnpjFormFiller.apply(
        current,
        fullData,
        mode: FormFillMode.fillEmptyOnly,
      );

      expect(result.tradeName, 'DJ Marcelo PP');
      expect(result.legalName, 'Marcelo PP Festas LTDA');
      expect(result.street, 'RUA EXEMPLO');
      expect(result.postalCode, '79002-010');
      expect(result.phone, '(67) 99999-8888');
      expect(result.whatsApp, '+55 (67) 99999-8888');
      expect(result.email, 'contato@djmarcelo.test');
    });

    test('preenche WhatsApp somente com celular válido', () {
      const incoming = CnpjCompanyData(
        legalName: 'Empresa Exemplo LTDA',
        phoneDigits: '1133334444',
        whatsAppDigits: '5511987654321',
      );

      const current = SettingsCnpjFormFieldValues();

      final result = SettingsCnpjFormFiller.apply(
        current,
        incoming,
        mode: FormFillMode.fillEmptyOnly,
      );

      expect(result.phone, '(11) 3333-4444');
      expect(result.whatsApp, '+55 (11) 98765-4321');
    });

    test('detecta conflitos em campos preenchidos', () {
      const current = SettingsCnpjFormFieldValues(
        tradeName: 'Nome Atual',
        legalName: 'Razão Atual',
      );

      final conflicts =
          SettingsCnpjFormFiller.findConflicts(current, fullData);

      expect(conflicts, isNotEmpty);
      expect(conflicts.first.fieldLabel, 'Nome fantasia');
    });
  });
}
