class CepAddressData {
  const CepAddressData({
    this.postalCode,
    this.street,
    this.neighborhood,
    this.city,
    this.state,
  });

  final String? postalCode;
  final String? street;
  final String? neighborhood;
  final String? city;
  final String? state;

  factory CepAddressData.fromJson(Map<String, dynamic> json) {
    return CepAddressData(
      postalCode: _optionalJsonText(json['cep']),
      street: _optionalJsonText(json['street']),
      neighborhood: _optionalJsonText(json['neighborhood']),
      city: _optionalJsonText(json['city']),
      state: _optionalJsonText(json['state'])?.toUpperCase(),
    );
  }

  static String? _optionalJsonText(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      return _optionalText(value);
    }

    if (value is num) {
      return _optionalText(value.toString());
    }

    return _optionalText(value.toString());
  }

  static String? _optionalText(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
