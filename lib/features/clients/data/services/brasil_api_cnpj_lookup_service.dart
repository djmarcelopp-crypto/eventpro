import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../client_form_validators.dart';
import '../exceptions/cnpj_lookup_exception.dart';
import '../models/cnpj_company_data.dart';
import '../utils/cnpj_lookup_error_mapper.dart';
import 'cnpj_lookup_service.dart';

class BrasilApiCnpjLookupService implements CnpjLookupService {
  BrasilApiCnpjLookupService({
    required this.client,
    this.timeout = const Duration(seconds: 10),
  });

  final http.Client client;
  final Duration timeout;

  static const _baseUrl = 'https://brasilapi.com.br/api/cnpj/v1';

  @override
  Future<CnpjCompanyData> lookup(String cnpjDigits) async {
    final digits = ClientFormValidators.extractDigits(cnpjDigits);
    if (digits.length != 14) {
      throw const CnpjLookupException(CnpjLookupFailure.invalidCnpj);
    }

    try {
      final response = await client
          .get(Uri.parse('$_baseUrl/$digits'))
          .timeout(timeout);

      if (response.statusCode == 404) {
        throw const CnpjLookupException(CnpjLookupFailure.notFound);
      }

      if (response.statusCode != 200) {
        throw CnpjLookupException(
          CnpjLookupFailure.unknown,
          message: 'HTTP ${response.statusCode}',
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const CnpjLookupException(CnpjLookupFailure.unknown);
      }

      return CnpjCompanyData.fromJson(decoded);
    } on CnpjLookupException {
      rethrow;
    } on TimeoutException {
      throw const CnpjLookupException(CnpjLookupFailure.timeout);
    } on http.ClientException catch (error) {
      throw CnpjLookupErrorMapper.fromClientException(error);
    } on FormatException {
      throw const CnpjLookupException(CnpjLookupFailure.unknown);
    }
  }
}
