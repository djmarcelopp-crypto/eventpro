enum CnpjLookupFailure {
  invalidCnpj,
  notFound,
  network,
  timeout,
  unknown,
}

class CnpjLookupException implements Exception {
  const CnpjLookupException(this.failure, {this.message});

  final CnpjLookupFailure failure;
  final String? message;

  String get userMessage => switch (failure) {
        CnpjLookupFailure.invalidCnpj => 'CNPJ inválido',
        CnpjLookupFailure.notFound =>
          'Empresa não encontrada para este CNPJ',
        CnpjLookupFailure.network =>
          'Sem conexão. Verifique a internet e tente novamente.',
        CnpjLookupFailure.timeout => 'Tempo esgotado. Tente novamente.',
        CnpjLookupFailure.unknown =>
          message ??
              'Não foi possível consultar o CNPJ. Tente novamente.',
      };
}
