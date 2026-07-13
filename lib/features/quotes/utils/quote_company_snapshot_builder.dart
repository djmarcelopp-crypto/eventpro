import 'package:eventpro/core/validation/brazilian_cnpj_validator.dart';
import 'package:eventpro/core/validation/brazilian_cpf_validator.dart';
import 'package:eventpro/core/validation/email_sanitizer.dart';

import '../../settings/models/company_address.dart';
import '../../settings/models/company_payment_info.dart';
import '../../settings/models/company_profile.dart';
import '../../settings/models/company_profile_status.dart';
import '../../settings/models/legal_representative.dart';
import '../../settings/models/pix_key_type.dart';
import '../../settings/utils/company_profile_completeness.dart';
import '../models/quote_company_capture_status.dart';
import '../models/quote_company_snapshot.dart';
import '../models/quote_pix_key_type.dart';

abstract class QuoteCompanySnapshotBuilder {
  static QuoteCompanySnapshot? fromProfile({
    required CompanyProfile? profile,
    required DateTime capturedAt,
    String? logoReference,
  }) {
    if (profile == null) {
      return null;
    }

    final legalRepresentative = _buildLegalRepresentative(
      profile.legalRepresentative,
    );
    final payment = _buildPayment(profile.paymentInfo);

    return QuoteCompanySnapshot(
      identification: _buildIdentification(profile),
      contact: _buildContact(profile),
      address: _buildAddress(profile.address),
      legalRepresentative: legalRepresentative,
      payment: payment,
      logoReference: _optionalText(logoReference),
      captureStatus: _mapCaptureStatus(
        CompanyProfileCompleteness.status(profile),
      ),
      capturedAt: capturedAt,
    );
  }

  static QuoteCompanyCaptureStatus _mapCaptureStatus(
    CompanyProfileStatus status,
  ) {
    return switch (status) {
      CompanyProfileStatus.configured => QuoteCompanyCaptureStatus.configured,
      CompanyProfileStatus.notConfigured ||
      CompanyProfileStatus.incomplete =>
        QuoteCompanyCaptureStatus.incomplete,
    };
  }

  static QuoteCompanyIdentification _buildIdentification(
    CompanyProfile profile,
  ) {
    return QuoteCompanyIdentification(
      tradeName: profile.tradeName.trim(),
      legalName: _optionalText(profile.legalName),
      cnpjDigits: _optionalValidCnpj(profile.cnpjDigits),
      stateRegistration: _optionalText(profile.stateRegistration),
    );
  }

  static QuoteCompanyContact _buildContact(CompanyProfile profile) {
    return QuoteCompanyContact(
      phoneDigits: _optionalDigits(profile.phoneDigits),
      whatsAppDigits: _optionalDigits(profile.whatsAppDigits),
      email: _optionalEmail(profile.email),
      instagram: _optionalText(profile.instagram),
      website: _optionalText(profile.website),
    );
  }

  static QuoteCompanyAddress _buildAddress(CompanyAddress address) {
    return QuoteCompanyAddress(
      postalCode: _optionalPostalCode(address.postalCode),
      street: _optionalText(address.street),
      number: _optionalText(address.number),
      complement: _optionalText(address.complement),
      neighborhood: _optionalText(address.neighborhood),
      city: _optionalText(address.city),
      state: _optionalUpperState(address.state),
    );
  }

  static QuoteCompanyLegalRepresentative? _buildLegalRepresentative(
    LegalRepresentative? representative,
  ) {
    if (representative == null || representative.isEmpty) {
      return null;
    }

    final snapshot = QuoteCompanyLegalRepresentative(
      fullName: _optionalText(representative.fullName),
      cpfDigits: _optionalValidCpf(representative.cpfDigits),
      role: _optionalText(representative.role),
    );

    return snapshot.isEmpty ? null : snapshot;
  }

  static QuoteCompanyPayment? _buildPayment(CompanyPaymentInfo? paymentInfo) {
    if (paymentInfo == null || paymentInfo.isEmpty) {
      return null;
    }

    final pixKeyType = paymentInfo.pixKeyType == null
        ? null
        : _mapPixKeyType(paymentInfo.pixKeyType!);

    final snapshot = QuoteCompanyPayment(
      pixKeyType: pixKeyType,
      pixKey: _normalizePixKey(
        pixKeyType: pixKeyType,
        rawKey: paymentInfo.pixKey,
      ),
      beneficiaryName: _optionalText(paymentInfo.beneficiaryName),
      paymentTerms: _optionalText(paymentInfo.paymentTerms),
    );

    return snapshot.isEmpty ? null : snapshot;
  }

  static QuotePixKeyType _mapPixKeyType(PixKeyType type) {
    return switch (type) {
      PixKeyType.cpf => QuotePixKeyType.cpf,
      PixKeyType.cnpj => QuotePixKeyType.cnpj,
      PixKeyType.email => QuotePixKeyType.email,
      PixKeyType.phone => QuotePixKeyType.phone,
      PixKeyType.random => QuotePixKeyType.random,
    };
  }

  static String? _normalizePixKey({
    required QuotePixKeyType? pixKeyType,
    required String? rawKey,
  }) {
    final trimmed = rawKey?.trim();
    if (trimmed == null || trimmed.isEmpty || pixKeyType == null) {
      return null;
    }

    return switch (pixKeyType) {
      QuotePixKeyType.cpf || QuotePixKeyType.cnpj => _optionalDigits(trimmed),
      QuotePixKeyType.phone => _optionalDigits(trimmed),
      QuotePixKeyType.email => EmailSanitizer.sanitize(trimmed)?.toLowerCase(),
      QuotePixKeyType.random => trimmed,
    };
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

  static String? _optionalEmail(String? value) {
    final sanitized = EmailSanitizer.sanitize(value);
    if (sanitized == null || sanitized.isEmpty) {
      return null;
    }
    return sanitized;
  }

  static String? _optionalPostalCode(String? value) {
    final digits = _optionalDigits(value);
    if (digits == null || digits.length != 8) {
      return null;
    }
    return digits;
  }

  static String? _optionalUpperState(String? value) {
    final trimmed = value?.trim().toUpperCase();
    if (trimmed == null || trimmed.length != 2) {
      return null;
    }
    return trimmed;
  }

  static String? _optionalValidCnpj(String? value) {
    final digits = _optionalDigits(value);
    if (digits == null || !BrazilianCnpjValidator.isValid(digits)) {
      return null;
    }
    return digits;
  }

  static String? _optionalValidCpf(String? value) {
    final digits = _optionalDigits(value);
    if (digits == null || !BrazilianCpfValidator.isValid(digits)) {
      return null;
    }
    return digits;
  }
}
