import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:eventpro/features/clients/data/exceptions/cep_lookup_exception.dart';
import 'package:eventpro/features/clients/data/models/cep_address_data.dart';
import 'package:eventpro/features/clients/data/services/brasil_api_cep_lookup_service.dart';

void main() {
  group('CepAddressData', () {
    test('mapeia JSON fictício da BrasilAPI', () {
      final data = CepAddressData.fromJson({
        'cep': '79002050',
        'street': 'Rua Exemplo',
        'neighborhood': 'Centro',
        'city': 'Campo Grande',
        'state': 'MS',
      });

      expect(data.postalCode, '79002050');
      expect(data.street, 'Rua Exemplo');
      expect(data.neighborhood, 'Centro');
      expect(data.city, 'Campo Grande');
      expect(data.state, 'MS');
    });
  });

  group('BrasilApiCepLookupService', () {
    const postalCode = '79002050';

    test('retorna dados quando API responde 200', () async {
      final client = MockClient((request) async {
        expect(
          request.url.toString(),
          'https://brasilapi.com.br/api/cep/v1/$postalCode',
        );
        return http.Response(
          jsonEncode({
            'cep': '79002050',
            'street': 'Rua Exemplo',
            'neighborhood': 'Centro',
            'city': 'Campo Grande',
            'state': 'MS',
          }),
          200,
        );
      });

      final service = BrasilApiCepLookupService(client: client);
      final data = await service.lookup(postalCode);

      expect(data.street, 'Rua Exemplo');
      expect(data.city, 'Campo Grande');
    });

    test('lança notFound para HTTP 404', () async {
      final client = MockClient((_) async => http.Response('', 404));
      final service = BrasilApiCepLookupService(client: client);

      expect(
        () => service.lookup(postalCode),
        throwsA(
          isA<CepLookupException>().having(
            (error) => error.failure,
            'failure',
            CepLookupFailure.notFound,
          ),
        ),
      );
    });

    test('lança network para falha de conectividade', () async {
      final client = MockClient((_) async {
        throw http.ClientException('Failed host lookup: brasilapi.com.br');
      });
      final service = BrasilApiCepLookupService(client: client);

      expect(
        () => service.lookup(postalCode),
        throwsA(
          isA<CepLookupException>().having(
            (error) => error.failure,
            'failure',
            CepLookupFailure.network,
          ),
        ),
      );
    });

    test('lança timeout quando a requisição excede o limite', () async {
      final client = MockClient((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        return http.Response('{}', 200);
      });
      final service = BrasilApiCepLookupService(
        client: client,
        timeout: Duration.zero,
      );

      expect(
        () => service.lookup(postalCode),
        throwsA(
          isA<CepLookupException>().having(
            (error) => error.failure,
            'failure',
            CepLookupFailure.timeout,
          ),
        ),
      );
    });

    test('lança invalidCep quando CEP não tem 8 dígitos', () async {
      final client = MockClient((_) async => http.Response('{}', 200));
      final service = BrasilApiCepLookupService(client: client);

      expect(
        () => service.lookup('123'),
        throwsA(
          isA<CepLookupException>().having(
            (error) => error.failure,
            'failure',
            CepLookupFailure.invalidCep,
          ),
        ),
      );
    });
  });
}
