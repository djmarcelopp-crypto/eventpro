enum CepLookupFailure {
  invalidCep,
  notFound,
  network,
  timeout,
  unknown,
}

class CepLookupException implements Exception {
  const CepLookupException(this.failure, {this.message});

  final CepLookupFailure failure;
  final String? message;

  String get userMessage => switch (failure) {
        CepLookupFailure.invalidCep => 'CEP inválido',
        CepLookupFailure.notFound => 'CEP não encontrado',
        CepLookupFailure.network =>
          'Sem conexão. Verifique a internet e tente novamente.',
        CepLookupFailure.timeout => 'Tempo esgotado. Tente novamente.',
        CepLookupFailure.unknown =>
          message ??
              'Não foi possível consultar o CEP. Tente novamente.',
      };
}
