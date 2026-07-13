import 'company_address.dart';
import 'company_payment_info.dart';
import 'company_quote_defaults.dart';
import 'legal_representative.dart';

class CompanyProfile {
  const CompanyProfile({
    required this.tradeName,
    this.legalName,
    this.cnpjDigits,
    this.stateRegistration,
    this.logoReference,
    this.phoneDigits,
    this.whatsAppDigits,
    this.email,
    this.instagram,
    this.website,
    this.address = const CompanyAddress(),
    this.legalRepresentative,
    this.paymentInfo,
    this.quoteDefaults = const CompanyQuoteDefaults(),
    required this.createdAt,
    required this.updatedAt,
  });

  final String tradeName;
  final String? legalName;
  final String? cnpjDigits;
  final String? stateRegistration;
  final String? logoReference;
  final String? phoneDigits;
  final String? whatsAppDigits;
  final String? email;
  final String? instagram;
  final String? website;
  final CompanyAddress address;
  final LegalRepresentative? legalRepresentative;
  final CompanyPaymentInfo? paymentInfo;
  final CompanyQuoteDefaults quoteDefaults;
  final DateTime createdAt;
  final DateTime updatedAt;

  CompanyProfile copyWith({
    String? tradeName,
    String? legalName,
    String? cnpjDigits,
    String? stateRegistration,
    String? logoReference,
    String? phoneDigits,
    String? whatsAppDigits,
    String? email,
    String? instagram,
    String? website,
    CompanyAddress? address,
    LegalRepresentative? legalRepresentative,
    CompanyPaymentInfo? paymentInfo,
    CompanyQuoteDefaults? quoteDefaults,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearLegalName = false,
    bool clearCnpjDigits = false,
    bool clearStateRegistration = false,
    bool clearLogoReference = false,
    bool clearPhoneDigits = false,
    bool clearWhatsAppDigits = false,
    bool clearEmail = false,
    bool clearInstagram = false,
    bool clearWebsite = false,
    bool clearLegalRepresentative = false,
    bool clearPaymentInfo = false,
  }) {
    return CompanyProfile(
      tradeName: tradeName ?? this.tradeName,
      legalName: clearLegalName ? null : (legalName ?? this.legalName),
      cnpjDigits: clearCnpjDigits ? null : (cnpjDigits ?? this.cnpjDigits),
      stateRegistration: clearStateRegistration
          ? null
          : (stateRegistration ?? this.stateRegistration),
      logoReference:
          clearLogoReference ? null : (logoReference ?? this.logoReference),
      phoneDigits: clearPhoneDigits ? null : (phoneDigits ?? this.phoneDigits),
      whatsAppDigits:
          clearWhatsAppDigits ? null : (whatsAppDigits ?? this.whatsAppDigits),
      email: clearEmail ? null : (email ?? this.email),
      instagram: clearInstagram ? null : (instagram ?? this.instagram),
      website: clearWebsite ? null : (website ?? this.website),
      address: address ?? this.address,
      legalRepresentative: clearLegalRepresentative
          ? null
          : (legalRepresentative ?? this.legalRepresentative),
      paymentInfo:
          clearPaymentInfo ? null : (paymentInfo ?? this.paymentInfo),
      quoteDefaults: quoteDefaults ?? this.quoteDefaults,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
