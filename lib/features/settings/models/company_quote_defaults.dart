class CompanyQuoteDefaults {
  const CompanyQuoteDefaults({
    this.defaultValidityDays = 7,
    this.defaultPublicNotes,
  });

  final int defaultValidityDays;
  final String? defaultPublicNotes;

  CompanyQuoteDefaults copyWith({
    int? defaultValidityDays,
    String? defaultPublicNotes,
    bool clearDefaultPublicNotes = false,
  }) {
    return CompanyQuoteDefaults(
      defaultValidityDays: defaultValidityDays ?? this.defaultValidityDays,
      defaultPublicNotes: clearDefaultPublicNotes
          ? null
          : (defaultPublicNotes ?? this.defaultPublicNotes),
    );
  }
}
