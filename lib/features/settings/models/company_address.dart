class CompanyAddress {
  const CompanyAddress({
    this.postalCode,
    this.street,
    this.number,
    this.complement,
    this.neighborhood,
    this.city,
    this.state,
  });

  final String? postalCode;
  final String? street;
  final String? number;
  final String? complement;
  final String? neighborhood;
  final String? city;
  final String? state;

  bool get isEmpty {
    return postalCode == null &&
        street == null &&
        number == null &&
        complement == null &&
        neighborhood == null &&
        city == null &&
        state == null;
  }

  CompanyAddress copyWith({
    String? postalCode,
    String? street,
    String? number,
    String? complement,
    String? neighborhood,
    String? city,
    String? state,
  }) {
    return CompanyAddress(
      postalCode: postalCode ?? this.postalCode,
      street: street ?? this.street,
      number: number ?? this.number,
      complement: complement ?? this.complement,
      neighborhood: neighborhood ?? this.neighborhood,
      city: city ?? this.city,
      state: state ?? this.state,
    );
  }

  static CompanyAddress fromForm({
    required String? postalCode,
    required String? street,
    required String? number,
    required String? complement,
    required String? neighborhood,
    required String? city,
    required String? state,
  }) {
    return CompanyAddress(
      postalCode: _optionalDigits(postalCode),
      street: _optionalText(street),
      number: _optionalText(number),
      complement: _optionalText(complement),
      neighborhood: _optionalText(neighborhood),
      city: _optionalText(city),
      state: _optionalUpperState(state),
    );
  }

  static String? _optionalText(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  static String? _optionalDigits(String? value) {
    final digits = value?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (digits.isEmpty) {
      return null;
    }
    return digits;
  }

  static String? _optionalUpperState(String? value) {
    final trimmed = value?.trim().toUpperCase();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
