import 'package:http/http.dart' as http;

import '../exceptions/cnpj_lookup_exception.dart';
import 'lookup_connectivity.dart';

abstract class CnpjLookupErrorMapper {
  static CnpjLookupException fromClientException(http.ClientException error) {
    if (LookupConnectivity.isConnectivityIssue(error.message)) {
      return const CnpjLookupException(CnpjLookupFailure.network);
    }

    return CnpjLookupException(
      CnpjLookupFailure.unknown,
      message: error.message,
    );
  }
}
