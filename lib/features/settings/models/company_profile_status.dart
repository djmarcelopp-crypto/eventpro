enum CompanyProfileStatus {
  notConfigured,
  incomplete,
  configured,
}

extension CompanyProfileStatusLabel on CompanyProfileStatus {
  String get label => switch (this) {
        CompanyProfileStatus.notConfigured => 'Não configurado',
        CompanyProfileStatus.incomplete => 'Configuração incompleta',
        CompanyProfileStatus.configured => 'Configurado',
      };
}
