import 'package:eventpro/core/formatting/text_input_masks.dart';
import 'package:eventpro/core/validation/email_sanitizer.dart';
import 'package:flutter/material.dart';

import '../models/company_address.dart';
import '../models/company_payment_info.dart';
import '../models/company_profile.dart';
import '../models/company_quote_defaults.dart';
import '../models/legal_representative.dart';
import '../models/pix_key_type.dart';
import 'company_profile_form_validators.dart';

class CompanyProfileFormValues {
  const CompanyProfileFormValues({
    required this.tradeName,
    required this.legalName,
    required this.cnpj,
    required this.stateRegistration,
    required this.phone,
    required this.whatsApp,
    required this.email,
    required this.instagram,
    required this.website,
    required this.postalCode,
    required this.street,
    required this.number,
    required this.complement,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.legalFullName,
    required this.legalCpf,
    required this.legalRole,
    required this.pixKeyType,
    required this.pixKey,
    required this.beneficiaryName,
    required this.paymentTerms,
    required this.defaultValidityDays,
    required this.defaultPublicNotes,
  });

  final String tradeName;
  final String legalName;
  final String cnpj;
  final String stateRegistration;
  final String phone;
  final String whatsApp;
  final String email;
  final String instagram;
  final String website;
  final String postalCode;
  final String street;
  final String number;
  final String complement;
  final String neighborhood;
  final String city;
  final String state;
  final String legalFullName;
  final String legalCpf;
  final String legalRole;
  final PixKeyType? pixKeyType;
  final String pixKey;
  final String beneficiaryName;
  final String paymentTerms;
  final String defaultValidityDays;
  final String defaultPublicNotes;
}

abstract class CompanyProfileFormInitializer {
  static CompanyProfileFormValues fromProfile(CompanyProfile profile) {
    return CompanyProfileFormValues(
      tradeName: profile.tradeName,
      legalName: profile.legalName ?? '',
      cnpj: CompanyProfileFormValidators.formatCnpjForDisplay(
        profile.cnpjDigits,
      ),
      stateRegistration: profile.stateRegistration ?? '',
      phone: BrazilianPhoneInputFormatter.formatFromDigits(
        profile.phoneDigits ?? '',
      ),
      whatsApp: BrazilianWhatsAppInputFormatter.formatFromDigits(
        profile.whatsAppDigits ?? '',
      ),
      email: profile.email ?? '',
      instagram: profile.instagram ?? '',
      website: profile.website ?? '',
      postalCode: CepInputFormatter.formatFromDigits(
        profile.address.postalCode ?? '',
      ),
      street: profile.address.street ?? '',
      number: profile.address.number ?? '',
      complement: profile.address.complement ?? '',
      neighborhood: profile.address.neighborhood ?? '',
      city: profile.address.city ?? '',
      state: profile.address.state ?? '',
      legalFullName: profile.legalRepresentative?.fullName ?? '',
      legalCpf: CompanyProfileFormValidators.formatCpfForDisplay(
        profile.legalRepresentative?.cpfDigits,
      ),
      legalRole: profile.legalRepresentative?.role ?? '',
      pixKeyType: profile.paymentInfo?.pixKeyType,
      pixKey: profile.paymentInfo?.pixKey ?? '',
      beneficiaryName: profile.paymentInfo?.beneficiaryName ?? '',
      paymentTerms: profile.paymentInfo?.paymentTerms ?? '',
      defaultValidityDays: profile.quoteDefaults.defaultValidityDays.toString(),
      defaultPublicNotes: profile.quoteDefaults.defaultPublicNotes ?? '',
    );
  }

  static void applyToControllers({
    required CompanyProfileFormValues values,
    required TextEditingController tradeNameController,
    required TextEditingController legalNameController,
    required TextEditingController cnpjController,
    required TextEditingController stateRegistrationController,
    required TextEditingController phoneController,
    required TextEditingController whatsAppController,
    required TextEditingController emailController,
    required TextEditingController instagramController,
    required TextEditingController websiteController,
    required TextEditingController postalCodeController,
    required TextEditingController streetController,
    required TextEditingController numberController,
    required TextEditingController complementController,
    required TextEditingController neighborhoodController,
    required TextEditingController cityController,
    required TextEditingController stateController,
    required TextEditingController legalFullNameController,
    required TextEditingController legalCpfController,
    required TextEditingController legalRoleController,
    required TextEditingController pixKeyController,
    required TextEditingController beneficiaryNameController,
    required TextEditingController paymentTermsController,
    required TextEditingController defaultValidityDaysController,
    required TextEditingController defaultPublicNotesController,
    required void Function(PixKeyType?) onPixKeyTypeChanged,
  }) {
    tradeNameController.text = values.tradeName;
    legalNameController.text = values.legalName;
    cnpjController.text = values.cnpj;
    stateRegistrationController.text = values.stateRegistration;
    phoneController.text = values.phone;
    whatsAppController.text = values.whatsApp;
    emailController.text = values.email;
    instagramController.text = values.instagram;
    websiteController.text = values.website;
    postalCodeController.text = values.postalCode;
    streetController.text = values.street;
    numberController.text = values.number;
    complementController.text = values.complement;
    neighborhoodController.text = values.neighborhood;
    cityController.text = values.city;
    stateController.text = values.state;
    legalFullNameController.text = values.legalFullName;
    legalCpfController.text = values.legalCpf;
    legalRoleController.text = values.legalRole;
    onPixKeyTypeChanged(values.pixKeyType);
    pixKeyController.text = values.pixKey;
    beneficiaryNameController.text = values.beneficiaryName;
    paymentTermsController.text = values.paymentTerms;
    defaultValidityDaysController.text = values.defaultValidityDays;
    defaultPublicNotesController.text = values.defaultPublicNotes;
  }

  static CompanyProfile buildProfile({
    required CompanyProfile? existing,
    required String tradeName,
    required String legalName,
    required String cnpj,
    required String stateRegistration,
    required String phone,
    required String whatsApp,
    required String email,
    required String instagram,
    required String website,
    required String postalCode,
    required String street,
    required String number,
    required String complement,
    required String neighborhood,
    required String city,
    required String state,
    required String legalFullName,
    required String legalCpf,
    required String legalRole,
    required PixKeyType? pixKeyType,
    required String pixKey,
    required String beneficiaryName,
    required String paymentTerms,
    required int defaultValidityDays,
    required String defaultPublicNotes,
    required DateTime now,
    String? logoReference,
    bool clearLogoReference = false,
  }) {
    final address = CompanyAddress.fromForm(
      postalCode: postalCode,
      street: street,
      number: number,
      complement: complement,
      neighborhood: neighborhood,
      city: city,
      state: state,
    );

    final legalRepresentative = LegalRepresentative.fromForm(
      fullName: legalFullName,
      cpf: legalCpf,
      role: legalRole,
    );

    final paymentInfo = CompanyPaymentInfo.fromForm(
      pixKeyType: pixKeyType,
      pixKey: pixKey,
      beneficiaryName: beneficiaryName,
      paymentTerms: paymentTerms,
    );

    final quoteDefaults = CompanyQuoteDefaults(
      defaultValidityDays: defaultValidityDays,
      defaultPublicNotes: _optionalText(defaultPublicNotes),
    );

    return CompanyProfile(
      tradeName: tradeName.trim(),
      legalName: _optionalText(legalName),
      cnpjDigits: _optionalDigits(cnpj),
      stateRegistration: _optionalText(stateRegistration),
      logoReference: clearLogoReference
          ? null
          : (logoReference ?? existing?.logoReference),
      phoneDigits: _optionalDigits(phone),
      whatsAppDigits: _optionalDigits(whatsApp),
      email: EmailSanitizer.sanitize(email),
      instagram: _optionalText(instagram),
      website: _optionalText(website),
      address: address,
      legalRepresentative: legalRepresentative,
      paymentInfo: paymentInfo,
      quoteDefaults: quoteDefaults,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
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
}
