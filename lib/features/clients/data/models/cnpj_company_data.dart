import '../../utils/email_sanitizer.dart';
import '../utils/brazilian_mobile_phone.dart';
import '../utils/brazilian_phone.dart';

class CnpjCompanyData {
  const CnpjCompanyData({
    this.legalName,
    this.tradeName,
    this.street,
    this.number,
    this.complement,
    this.neighborhood,
    this.city,
    this.state,
    this.postalCode,
    this.phoneDigits,
    this.whatsAppDigits,
    this.email,
  });

  final String? legalName;
  final String? tradeName;
  final String? street;
  final String? number;
  final String? complement;
  final String? neighborhood;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? phoneDigits;
  final String? whatsAppDigits;
  final String? email;

  factory CnpjCompanyData.fromJson(Map<String, dynamic> json) {
    final legalName = _optionalJsonText(json['razao_social']);
    final rawTradeName = _optionalJsonText(json['nome_fantasia']);
    final tradeName = _normalizeTradeName(rawTradeName, legalName);
    final primaryPhone = _optionalJsonText(json['ddd_telefone_1']);
    final secondaryPhone = _optionalJsonText(json['ddd_telefone_2']);

    return CnpjCompanyData(
      legalName: legalName,
      tradeName: tradeName,
      street: _resolveStreet(
        _optionalJsonText(json['descricao_tipo_de_logradouro']),
        _optionalJsonText(json['logradouro']),
      ),
      number: _optionalJsonText(json['numero']),
      complement: _optionalJsonText(json['complemento']),
      neighborhood: _optionalJsonText(json['bairro']),
      city: _optionalJsonText(json['municipio']),
      state: _optionalJsonText(json['uf'])?.toUpperCase(),
      postalCode: _optionalJsonText(json['cep']),
      phoneDigits: _resolvePhoneDigits(primaryPhone, secondaryPhone),
      whatsAppDigits: _resolveMobileWhatsAppDigits(primaryPhone, secondaryPhone),
      email: EmailSanitizer.sanitize(_optionalJsonText(json['email'])),
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

  static String? _resolveStreet(String? streetType, String? streetName) {
    if (streetName == null) {
      return streetType;
    }

    if (streetType == null) {
      return streetName;
    }

    final normalizedStreetName = streetName.toUpperCase();
    final normalizedStreetType = streetType.toUpperCase();

    if (normalizedStreetName.startsWith(normalizedStreetType)) {
      return streetName;
    }

    return '$streetType $streetName';
  }

  static String? _normalizeTradeName(String? tradeName, String? legalName) {
    if (tradeName == null) {
      return null;
    }
    if (legalName != null &&
        tradeName.toLowerCase() == legalName.toLowerCase()) {
      return null;
    }
    return tradeName;
  }

  static String? _resolvePhoneDigits(
    String? primaryPhone,
    String? secondaryPhone,
  ) {
    for (final phone in [primaryPhone, secondaryPhone]) {
      final digits = BrazilianPhone.normalizeNationalDigits(phone);
      if (digits != null) {
        return digits;
      }
    }
    return null;
  }

  static String? _resolveMobileWhatsAppDigits(
    String? primaryPhone,
    String? secondaryPhone,
  ) {
    for (final phone in [primaryPhone, secondaryPhone]) {
      final digits = BrazilianMobilePhone.normalizeWhatsAppDigits(phone);
      if (digits != null) {
        return digits;
      }
    }
    return null;
  }
}
