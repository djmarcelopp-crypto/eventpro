enum QuotePixKeyType {
  cpf,
  cnpj,
  email,
  phone,
  random,
}

extension QuotePixKeyTypeLabel on QuotePixKeyType {
  String get label => switch (this) {
        QuotePixKeyType.cpf => 'CPF',
        QuotePixKeyType.cnpj => 'CNPJ',
        QuotePixKeyType.email => 'E-mail',
        QuotePixKeyType.phone => 'Telefone',
        QuotePixKeyType.random => 'Chave aleatória',
      };
}
