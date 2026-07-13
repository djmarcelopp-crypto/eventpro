import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/data/models/cnpj_company_data.dart';
import 'package:eventpro/features/clients/utils/cnpj_form_filler.dart';
import 'package:eventpro/features/clients/utils/form_fill_mode.dart';

void main() {
  group('CnpjFormFiller', () {
    const fullAddress = CnpjCompanyData(
      legalName: 'Empresa Ficticia LTDA',
      tradeName: 'Marca Ficticia',
      street: 'RUA DAS FLORES',
      number: '100',
      complement: 'Sala 1',
      neighborhood: 'Centro',
      city: 'Cidade Exemplo',
      state: 'SP',
      postalCode: '12345678',
      phoneDigits: '1133334444',
      whatsAppDigits: '5511987654321',
      email: 'contato@empresaficticia.test',
    );

    test('preenche endereço completo e telefone em campos vazios', () {
      const current = CnpjFormFieldValues();

      final result = CnpjFormFiller.apply(
        current,
        fullAddress,
        mode: FormFillMode.fillEmptyOnly,
      );

      expect(result.street, 'RUA DAS FLORES');
      expect(result.number, '100');
      expect(result.complement, 'Sala 1');
      expect(result.neighborhood, 'Centro');
      expect(result.city, 'Cidade Exemplo');
      expect(result.state, 'SP');
      expect(result.postalCode, '12345-678');
      expect(result.phone, '(11) 3333-4444');
      expect(result.whatsApp, '+55 (11) 98765-4321');
      expect(result.email, 'contato@empresaficticia.test');
    });

    test('mantém complemento vazio quando API não retorna complemento', () {
      const incoming = CnpjCompanyData(
        legalName: 'Empresa Exemplo LTDA',
        street: 'AVENIDA PAULISTA',
        number: '37',
        neighborhood: 'Bela Vista',
        city: 'Sao Paulo',
        state: 'SP',
        phoneDigits: '1123851939',
      );

      const current = CnpjFormFieldValues(complement: '');

      final result = CnpjFormFiller.apply(
        current,
        incoming,
        mode: FormFillMode.fillEmptyOnly,
      );

      expect(result.complement, '');
      expect(result.street, 'AVENIDA PAULISTA');
      expect(result.phone, '(11) 2385-1939');
      expect(result.whatsApp, '');
    });

    test('preenche WhatsApp somente com celular válido', () {
      const incoming = CnpjCompanyData(
        legalName: 'Empresa Exemplo LTDA',
        phoneDigits: '11987654321',
        whatsAppDigits: '5511987654321',
      );

      const current = CnpjFormFieldValues();

      final result = CnpjFormFiller.apply(
        current,
        incoming,
        mode: FormFillMode.fillEmptyOnly,
      );

      expect(result.phone, '(11) 98765-4321');
      expect(result.whatsApp, '+55 (11) 98765-4321');
    });

    test('preenche telefone fixo sem WhatsApp', () {
      const incoming = CnpjCompanyData(
        legalName: 'Empresa Exemplo LTDA',
        street: 'RUA GARIBALDI',
        city: 'Cidade Exemplo',
        state: 'RS',
        phoneDigits: '5136354333',
      );

      const current = CnpjFormFieldValues();

      final result = CnpjFormFiller.apply(
        current,
        incoming,
        mode: FormFillMode.fillEmptyOnly,
      );

      expect(result.phone, '(51) 3635-4333');
      expect(result.whatsApp, '');
      expect(result.street, 'RUA GARIBALDI');
    });

    test('preenche somente campos vazios sem sobrescrever dados digitados', () {
      const current = CnpjFormFieldValues(
        name: 'Nome Manual',
        email: 'manual@test.com',
      );

      final result = CnpjFormFiller.apply(
        current,
        fullAddress,
        mode: FormFillMode.fillEmptyOnly,
      );

      expect(result.name, 'Nome Manual');
      expect(result.email, 'manual@test.com');
      expect(result.tradeName, 'Marca Ficticia');
      expect(result.street, 'RUA DAS FLORES');
      expect(result.phone, '(11) 3333-4444');
    });

    test('substitui todos os campos no modo replaceAll', () {
      const current = CnpjFormFieldValues(
        name: 'Nome Manual',
        email: 'manual@test.com',
      );

      final result = CnpjFormFiller.apply(
        current,
        fullAddress,
        mode: FormFillMode.replaceAll,
      );

      expect(result.name, 'Empresa Ficticia LTDA');
      expect(result.email, 'contato@empresaficticia.test');
      expect(result.phone, '(11) 3333-4444');
    });

    test('detecta conflitos em campos preenchidos', () {
      const current = CnpjFormFieldValues(
        name: 'Nome Manual',
        city: 'Outra Cidade',
        phone: '(67) 1111-1111',
      );

      final conflicts = CnpjFormFiller.findConflicts(current, fullAddress);

      expect(conflicts, hasLength(3));
      expect(conflicts[0].fieldLabel, 'Nome');
      expect(conflicts[1].fieldLabel, 'Telefone');
      expect(conflicts[2].fieldLabel, 'Cidade');
    });
  });
}
