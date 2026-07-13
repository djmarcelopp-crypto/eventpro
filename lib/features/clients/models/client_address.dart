class ClientAddress {
  const ClientAddress({
    this.street,
    this.number,
    this.complement,
    this.neighborhood,
    this.city,
    this.state,
  });

  final String? street;
  final String? number;
  final String? complement;
  final String? neighborhood;
  final String? city;
  final String? state;

  bool get isEmpty {
    return street == null &&
        number == null &&
        complement == null &&
        neighborhood == null &&
        city == null &&
        state == null;
  }

  static ClientAddress? fromForm({
    required String? street,
    required String? number,
    required String? complement,
    required String? neighborhood,
    required String? city,
    required String? state,
  }) {
    final address = ClientAddress(
      street: _optionalText(street),
      number: _optionalText(number),
      complement: _optionalText(complement),
      neighborhood: _optionalText(neighborhood),
      city: _optionalText(city),
      state: _optionalText(state),
    );

    return address.isEmpty ? null : address;
  }

  static String? _optionalText(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
