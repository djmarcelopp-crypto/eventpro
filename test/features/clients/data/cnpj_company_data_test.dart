import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/data/models/cnpj_company_data.dart';

void main() {
  group('CnpjCompanyData.fromJson', () {
    test('mapeia endereço completo no formato real da BrasilAPI', () {
      final data = CnpjCompanyData.fromJson({
        'razao_social': 'Empresa Exemplo LTDA',
        'nome_fantasia': 'Fantasia Exemplo',
        'descricao_tipo_de_logradouro': 'RUA',
        'logradouro': 'GARIBALDI',
        'numero': '070',
        'complemento': 'SALA 2',
        'bairro': 'VILA RICA',
        'municipio': 'SAO SEBASTIAO DO CAI',
        'uf': 'rs',
        'cep': '95760000',
        'ddd_telefone_1': '5136354333',
        'ddd_telefone_2': '51998765432',
        'email': 'contato@exemplo.test',
      });

      expect(data.street, 'RUA GARIBALDI');
      expect(data.number, '070');
      expect(data.complement, 'SALA 2');
      expect(data.neighborhood, 'VILA RICA');
      expect(data.city, 'SAO SEBASTIAO DO CAI');
      expect(data.state, 'RS');
      expect(data.postalCode, '95760000');
      expect(data.phoneDigits, '5136354333');
      expect(data.whatsAppDigits, '5551998765432');
      expect(data.email, 'contato@exemplo.test');
    });

    test('aceita complemento vazio e preenche telefone fixo sem WhatsApp', () {
      final data = CnpjCompanyData.fromJson({
        'razao_social': 'Empresa Exemplo LTDA',
        'descricao_tipo_de_logradouro': 'AVENIDA',
        'logradouro': 'PAULISTA',
        'numero': '37',
        'complemento': '',
        'bairro': 'BELA VISTA',
        'municipio': 'SAO PAULO',
        'uf': 'SP',
        'cep': '01311902',
        'ddd_telefone_1': '1123851939',
        'ddd_telefone_2': '',
      });

      expect(data.complement, isNull);
      expect(data.phoneDigits, '1123851939');
      expect(data.whatsAppDigits, isNull);
      expect(data.street, 'AVENIDA PAULISTA');
    });

    test('prioriza celular válido para WhatsApp e mantém telefone principal', () {
      final data = CnpjCompanyData.fromJson({
        'razao_social': 'Empresa Exemplo LTDA',
        'ddd_telefone_1': '1133334444',
        'ddd_telefone_2': '11987654321',
      });

      expect(data.phoneDigits, '1133334444');
      expect(data.whatsAppDigits, '5511987654321');
    });

    test('aceita campos numéricos retornados pela API', () {
      final data = CnpjCompanyData.fromJson({
        'razao_social': 'Empresa Exemplo LTDA',
        'logradouro': 'GARIBALDI',
        'numero': 70,
        'cep': 95760000,
        'ddd_telefone_1': 51998765432,
        'ddd_telefone_2': 5136354333,
      });

      expect(data.number, '70');
      expect(data.postalCode, '95760000');
      expect(data.phoneDigits, '51998765432');
      expect(data.whatsAppDigits, '5551998765432');
    });

    test('não duplica tipo de logradouro já presente no campo logradouro', () {
      final data = CnpjCompanyData.fromJson({
        'descricao_tipo_de_logradouro': 'AVENIDA',
        'logradouro': 'AVENIDA ATAULFO DE PAIVA',
        'numero': '153',
      });

      expect(data.street, 'AVENIDA ATAULFO DE PAIVA');
    });

    test('ignora e-mail inválido sem interromper mapeamento', () {
      final data = CnpjCompanyData.fromJson({
        'razao_social': 'Empresa Exemplo LTDA',
        'email': 'invalido',
        'logradouro': 'GARIBALDI',
        'ddd_telefone_1': '5136354333',
      });

      expect(data.email, isNull);
      expect(data.street, 'GARIBALDI');
      expect(data.phoneDigits, '5136354333');
    });
  });
}
