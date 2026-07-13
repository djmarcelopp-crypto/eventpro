import 'package:eventpro/core/validation/brazilian_cnpj_validator.dart';
import 'package:eventpro/core/validation/brazilian_cpf_validator.dart';

import '../models/company_address.dart';
import '../models/company_profile.dart';
import '../models/company_profile_status.dart';
import '../models/legal_representative.dart';
import 'company_profile_form_validators.dart';

abstract class CompanyProfileCompleteness {
  static CompanyProfileStatus status(CompanyProfile? profile) {
    if (profile == null) {
      return CompanyProfileStatus.notConfigured;
    }

    if (!CompanyProfileFormValidators.isMinimumValid(profile)) {
      return CompanyProfileStatus.incomplete;
    }

    if (!hasRecommendedProfessionalData(profile)) {
      return CompanyProfileStatus.incomplete;
    }

    return CompanyProfileStatus.configured;
  }

  static bool hasRecommendedProfessionalData(CompanyProfile profile) {
    return _hasLegalName(profile) &&
        _hasValidCnpj(profile) &&
        _hasCompleteMainAddress(profile.address) &&
        _hasCompleteLegalRepresentative(profile.legalRepresentative);
  }

  static List<String> missingRecommendations(CompanyProfile profile) {
    final missing = <String>[];

    if (!_hasLegalName(profile)) {
      missing.add('Razão social');
    }
    if (!_hasValidCnpj(profile)) {
      missing.add('CNPJ');
    }
    if (!_hasCompleteMainAddress(profile.address)) {
      missing.add('Endereço principal');
    }
    if (!_hasCompleteLegalRepresentative(profile.legalRepresentative)) {
      missing.add('Responsável legal');
    }

    return missing;
  }

  static bool _hasLegalName(CompanyProfile profile) {
    return profile.legalName?.trim().isNotEmpty ?? false;
  }

  static bool _hasValidCnpj(CompanyProfile profile) {
    final digits = profile.cnpjDigits;
    if (digits == null || digits.isEmpty) {
      return false;
    }
    return BrazilianCnpjValidator.isValid(digits);
  }

  static bool _hasCompleteMainAddress(CompanyAddress address) {
    final postalCode = address.postalCode;
    final street = address.street;
    final number = address.number;
    final city = address.city;
    final state = address.state;

    if (postalCode == null ||
        postalCode.length != 8 ||
        street == null ||
        street.trim().isEmpty ||
        number == null ||
        number.trim().isEmpty ||
        city == null ||
        city.trim().isEmpty ||
        state == null ||
        state.length != 2) {
      return false;
    }

    return true;
  }

  static bool _hasCompleteLegalRepresentative(
    LegalRepresentative? representative,
  ) {
    if (representative == null || representative.isEmpty) {
      return false;
    }

    final fullName = representative.fullName?.trim();
    final cpfDigits = representative.cpfDigits;

    if (fullName == null || fullName.length < 2) {
      return false;
    }

    if (cpfDigits == null || !BrazilianCpfValidator.isValid(cpfDigits)) {
      return false;
    }

    return true;
  }
}
