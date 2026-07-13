import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/brasil_api_cnpj_lookup_service.dart';
import '../services/cnpj_lookup_service.dart';
import 'http_client_provider.dart';

final cnpjLookupServiceProvider = Provider<CnpjLookupService>((ref) {
  return BrasilApiCnpjLookupService(
    client: ref.watch(httpClientProvider),
  );
});
