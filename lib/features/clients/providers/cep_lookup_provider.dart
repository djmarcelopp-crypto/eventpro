import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/brasil_api_cep_lookup_service.dart';
import '../data/services/cep_lookup_service.dart';
import 'cnpj_lookup_provider.dart';

final cepLookupServiceProvider = Provider<CepLookupService>((ref) {
  return BrasilApiCepLookupService(
    client: ref.watch(httpClientProvider),
  );
});
