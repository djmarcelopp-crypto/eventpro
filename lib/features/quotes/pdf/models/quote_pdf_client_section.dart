class QuotePdfClientSection {
  const QuotePdfClientSection({
    required this.typeLabel,
    required this.name,
    this.legalName,
    this.documentLabel,
    this.documentValue,
    this.contactLines = const [],
    this.address,
  });

  final String typeLabel;
  final String name;
  final String? legalName;
  final String? documentLabel;
  final String? documentValue;
  final List<String> contactLines;
  final String? address;
}
