import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:eventpro/features/clients/data/exceptions/cnpj_lookup_exception.dart';
import 'package:eventpro/features/clients/data/models/cnpj_company_data.dart';
import 'package:eventpro/features/clients/data/services/brasil_api_cnpj_lookup_service.dart';

void main() {
  group('CnpjCompanyData', () {
    test('mapeia JSON fictício e prioriza celular válido', () {
      final jsonString = File('test/fixtures/cnpj_response.json').readAsStringSync();
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final data = CnpjCompanyData.fromJson(json);

      expect(data.legalName, 'Empresa Ficticia LTDA');
      expect(data.tradeName, 'Marca Ficticia');
      expect(data.street, 'RUA DAS FLORES');
      expect(data.number, '100');
      expect(data.complement, 'Sala 1');
      expect(data.neighborhood, 'Centro');
      expect(data.city, 'Cidade Exemplo');
      expect(data.state, 'SP');
      expect(data.postalCode, '12345678');
      expect(data.phoneDigits, '1133334444');
      expect(data.whatsAppDigits, '5511987654321');
      expect(data.email, 'contato@empresaficticia.test');
    });

    test('ignora nome fantasia igual à razão social', () {
      final data = CnpjCompanyData.fromJson({
        'razao_social': 'Empresa Ficticia LTDA',
        'nome_fantasia': 'Empresa Ficticia LTDA',
      });

      expect(data.tradeName, isNull);
    });
  });

  group('BrasilApiCnpjLookupService', () {
    const cnpj = '11222333000181';

    test('retorna dados quando API responde 200', () async {
      final client = MockClient((request) async {
        expect(
          request.url.toString(),
          'https://brasilapi.com.br/api/cnpj/v1/$cnpj',
        );
        return http.Response(
          jsonEncode({
            'razao_social': 'Empresa Ficticia LTDA',
            'nome_fantasia': 'Marca Ficticia',
            'ddd_telefone_1': '1133334444',
            'ddd_telefone_2': '11987654321',
          }),
          200,
        );
      });

      final service = BrasilApiCnpjLookupService(client: client);
      final data = await service.lookup(cnpj);

      expect(data.legalName, 'Empresa Ficticia LTDA');
      expect(data.tradeName, 'Marca Ficticia');
      expect(data.phoneDigits, '1133334444');
      expect(data.whatsAppDigits, '5511987654321');
    });

    test('lança notFound para HTTP 404', () async {
      final client = MockClient((_) async => http.Response('', 404));
      final service = BrasilApiCnpjLookupService(client: client);

      expect(
        () => service.lookup(cnpj),
        throwsA(
          isA<CnpjLookupException>().having(
            (error) => error.failure,
            'failure',
            CnpjLookupFailure.notFound,
          ),
        ),
      );
    });

    test('lança network para falha de conectividade', () async {
      final client = MockClient((_) async {
        throw http.ClientException('Failed host lookup: brasilapi.com.br');
      });
      final service = BrasilApiCnpjLookupService(client: client);

      expect(
        () => service.lookup(cnpj),
        throwsA(
          isA<CnpjLookupException>().having(
            (error) => error.failure,
            'failure',
            CnpjLookupFailure.network,
          ),
        ),
      );
    });

    test('lança unknown para ClientException sem indício de offline', () async {
      final client = MockClient((_) async {
        throw http.ClientException('Connection refused');
      });
      final service = BrasilApiCnpjLookupService(client: client);

      expect(
        () => service.lookup(cnpj),
        throwsA(
          isA<CnpjLookupException>().having(
            (error) => error.failure,
            'failure',
            CnpjLookupFailure.unknown,
          ),
        ),
      );
    });

    test('lança timeout quando a requisição excede o limite', () async {
      final client = MockClient((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        return http.Response('{}', 200);
      });
      final service = BrasilApiCnpjLookupService(
        client: client,
        timeout: Duration.zero,
      );

      expect(
        () => service.lookup(cnpj),
        throwsA(
          isA<CnpjLookupException>().having(
            (error) => error.failure,
            'failure',
            CnpjLookupFailure.timeout,
          ),
        ),
      );
    });

    test('lança invalidCnpj quando CNPJ não tem 14 dígitos', () async {
      final client = MockClient((_) async => http.Response('{}', 200));
      final service = BrasilApiCnpjLookupService(client: client);

      expect(
        () => service.lookup('123'),
        throwsA(
          isA<CnpjLookupException>().having(
            (error) => error.failure,
            'failure',
            CnpjLookupFailure.invalidCnpj,
          ),
        ),
      );
    });
  });
}
