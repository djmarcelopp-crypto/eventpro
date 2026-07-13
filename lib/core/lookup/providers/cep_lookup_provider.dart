import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/brasil_api_cep_lookup_service.dart';
import '../services/cep_lookup_service.dart';
import 'http_client_provider.dart';

final cepLookupServiceProvider = Provider<CepLookupService>((ref) {
  return BrasilApiCepLookupService(
    client: ref.watch(httpClientProvider),
  );
});
