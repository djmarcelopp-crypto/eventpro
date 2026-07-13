import 'quote_company_capture_status.dart';
import 'quote_pix_key_type.dart';

class QuoteCompanyIdentification {
  const QuoteCompanyIdentification({
    required this.tradeName,
    this.legalName,
    this.cnpjDigits,
    this.stateRegistration,
  });

  final String tradeName;
  final String? legalName;
  final String? cnpjDigits;
  final String? stateRegistration;
}

class QuoteCompanyContact {
  const QuoteCompanyContact({
    this.phoneDigits,
    this.whatsAppDigits,
    this.email,
    this.instagram,
    this.website,
  });

  final String? phoneDigits;
  final String? whatsAppDigits;
  final String? email;
  final String? instagram;
  final String? website;

  bool get isEmpty {
    return phoneDigits == null &&
        whatsAppDigits == null &&
        email == null &&
        instagram == null &&
        website == null;
  }
}

class QuoteCompanyAddress {
  const QuoteCompanyAddress({
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
}

class QuoteCompanyLegalRepresentative {
  const QuoteCompanyLegalRepresentative({
    this.fullName,
    this.cpfDigits,
    this.role,
  });

  final String? fullName;
  final String? cpfDigits;
  final String? role;

  bool get isEmpty {
    return fullName == null && cpfDigits == null && role == null;
  }
}

class QuoteCompanyPayment {
  const QuoteCompanyPayment({
    this.pixKeyType,
    this.pixKey,
    this.beneficiaryName,
    this.paymentTerms,
  });

  final QuotePixKeyType? pixKeyType;
  final String? pixKey;
  final String? beneficiaryName;
  final String? paymentTerms;

  bool get isEmpty {
    return pixKeyType == null &&
        pixKey == null &&
        beneficiaryName == null &&
        paymentTerms == null;
  }
}

class QuoteCompanySnapshot {
  const QuoteCompanySnapshot({
    required this.identification,
    required this.contact,
    required this.address,
    this.legalRepresentative,
    this.payment,
    this.logoReference,
    required this.captureStatus,
    required this.capturedAt,
  });

  final QuoteCompanyIdentification identification;
  final QuoteCompanyContact contact;
  final QuoteCompanyAddress address;
  final QuoteCompanyLegalRepresentative? legalRepresentative;
  final QuoteCompanyPayment? payment;
  final String? logoReference;
  final QuoteCompanyCaptureStatus captureStatus;
  final DateTime capturedAt;
}
