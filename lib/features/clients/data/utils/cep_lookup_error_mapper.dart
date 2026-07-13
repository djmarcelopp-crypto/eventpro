import 'package:http/http.dart' as http;

import '../exceptions/cep_lookup_exception.dart';
import 'lookup_connectivity.dart';

abstract class CepLookupErrorMapper {
  static CepLookupException fromClientException(http.ClientException error) {
    if (LookupConnectivity.isConnectivityIssue(error.message)) {
      return const CepLookupException(CepLookupFailure.network);
    }

    return CepLookupException(
      CepLookupFailure.unknown,
      message: error.message,
    );
  }
}
