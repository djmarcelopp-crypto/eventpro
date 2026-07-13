import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../data/services/brasil_api_cnpj_lookup_service.dart';
import '../data/services/cnpj_lookup_service.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final cnpjLookupServiceProvider = Provider<CnpjLookupService>((ref) {
  return BrasilApiCnpjLookupService(
    client: ref.watch(httpClientProvider),
  );
});
