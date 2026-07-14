class QuotePdfCompanySection {
  const QuotePdfCompanySection({
    required this.tradeName,
    this.legalName,
    this.cnpj,
    this.stateRegistration,
    this.contactLines = const [],
    this.address,
    this.logoReference,
  });

  final String tradeName;
  final String? legalName;
  final String? cnpj;
  final String? stateRegistration;
  final List<String> contactLines;
  final String? address;
  final String? logoReference;
}
