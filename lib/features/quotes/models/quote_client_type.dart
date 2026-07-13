enum QuoteClientType {
  individual,
  company,
}

extension QuoteClientTypeLabels on QuoteClientType {
  String get label => switch (this) {
        QuoteClientType.individual => 'Pessoa Física',
        QuoteClientType.company => 'Pessoa Jurídica',
      };
}
