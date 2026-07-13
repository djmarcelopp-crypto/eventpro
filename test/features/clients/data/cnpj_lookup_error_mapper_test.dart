import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:eventpro/features/clients/data/exceptions/cnpj_lookup_exception.dart';
import 'package:eventpro/features/clients/data/utils/cnpj_lookup_error_mapper.dart';

void main() {
  group('CnpjLookupErrorMapper', () {
    test('classifica falha de resolução DNS como network', () {
      final error = CnpjLookupErrorMapper.fromClientException(
        http.ClientException('Failed host lookup: brasilapi.com.br'),
      );

      expect(error.failure, CnpjLookupFailure.network);
    });

    test('classifica connection refused como unknown', () {
      final error = CnpjLookupErrorMapper.fromClientException(
        http.ClientException('Connection refused'),
      );

      expect(error.failure, CnpjLookupFailure.unknown);
      expect(error.message, 'Connection refused');
    });

    test('classifica operation not permitted como unknown', () {
      final error = CnpjLookupErrorMapper.fromClientException(
        http.ClientException(
          'Connection failed (OS Error: Operation not permitted, errno = 1)',
        ),
      );

      expect(error.failure, CnpjLookupFailure.unknown);
    });
  });
}
