enum PixKeyType {
  cpf,
  cnpj,
  email,
  phone,
  random,
}

extension PixKeyTypeLabel on PixKeyType {
  String get label => switch (this) {
        PixKeyType.cpf => 'CPF',
        PixKeyType.cnpj => 'CNPJ',
        PixKeyType.email => 'E-mail',
        PixKeyType.phone => 'Telefone',
        PixKeyType.random => 'Chave aleatória',
      };
}
