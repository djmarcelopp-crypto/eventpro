import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../validation/input_digits.dart';
import '../exceptions/cep_lookup_exception.dart';
import '../models/cep_address_data.dart';
import '../utils/cep_lookup_error_mapper.dart';
import 'cep_lookup_service.dart';

class BrasilApiCepLookupService implements CepLookupService {
  BrasilApiCepLookupService({
    required this.client,
    this.timeout = const Duration(seconds: 10),
  });

  final http.Client client;
  final Duration timeout;

  static const _baseUrl = 'https://brasilapi.com.br/api/cep/v1';

  @override
  Future<CepAddressData> lookup(String postalCodeDigits) async {
    final digits = InputDigits.extract(postalCodeDigits);
    if (digits.length != 8) {
      throw const CepLookupException(CepLookupFailure.invalidCep);
    }

    try {
      final response = await client
          .get(Uri.parse('$_baseUrl/$digits'))
          .timeout(timeout);

      if (response.statusCode == 404) {
        throw const CepLookupException(CepLookupFailure.notFound);
      }

      if (response.statusCode != 200) {
        throw CepLookupException(
          CepLookupFailure.unknown,
          message: 'HTTP ${response.statusCode}',
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const CepLookupException(CepLookupFailure.unknown);
      }

      return CepAddressData.fromJson(decoded);
    } on CepLookupException {
      rethrow;
    } on TimeoutException {
      throw const CepLookupException(CepLookupFailure.timeout);
    } on http.ClientException catch (error) {
      throw CepLookupErrorMapper.fromClientException(error);
    } on FormatException {
      throw const CepLookupException(CepLookupFailure.unknown);
    }
  }
}
