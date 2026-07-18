import 'package:drift/drift.dart';
import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/core/database/converters/timestamp_converter.dart';
import 'package:eventpro/features/settings/models/company_address.dart';
import 'package:eventpro/features/settings/models/company_payment_info.dart';
import 'package:eventpro/features/settings/models/company_profile.dart';
import 'package:eventpro/features/settings/models/company_quote_defaults.dart';
import 'package:eventpro/features/settings/models/legal_representative.dart';
import 'package:eventpro/features/settings/models/pix_key_type.dart';

const kDefaultCompanyProfileId = 'default';

abstract class CompanyProfileMapper {
  static CompanyProfile toDomain(CompanyProfileRow row) {
    final legalRepresentative = _toLegalRepresentative(row);
    final paymentInfo = _toPaymentInfo(row);

    return CompanyProfile(
      tradeName: row.tradeName,
      legalName: row.legalName,
      cnpjDigits: row.cnpjDigits,
      stateRegistration: row.stateRegistration,
      logoReference: row.logoReference,
      phoneDigits: row.phoneDigits,
      whatsAppDigits: row.whatsappDigits,
      email: row.email,
      instagram: row.instagram,
      website: row.website,
      address: _toAddress(row),
      legalRepresentative: legalRepresentative,
      paymentInfo: paymentInfo,
      quoteDefaults: CompanyQuoteDefaults(
        defaultValidityDays: row.defaultValidityDays,
        defaultPublicNotes: row.defaultPublicNotes,
      ),
      createdAt: TimestampConverter.fromUtcMillis(row.createdAt),
      updatedAt: TimestampConverter.fromUtcMillis(row.updatedAt),
    );
  }

  static CompanyProfilesCompanion toUpsertCompanion(CompanyProfile profile) {
    final address = profile.address;
    final legalRepresentative = profile.legalRepresentative;
    final paymentInfo = profile.paymentInfo;

    return CompanyProfilesCompanion.insert(
      id: kDefaultCompanyProfileId,
      tradeName: profile.tradeName,
      legalName: Value(profile.legalName),
      cnpjDigits: Value(profile.cnpjDigits),
      stateRegistration: Value(profile.stateRegistration),
      logoReference: Value(profile.logoReference),
      phoneDigits: Value(profile.phoneDigits),
      whatsappDigits: Value(profile.whatsAppDigits),
      email: Value(profile.email),
      instagram: Value(profile.instagram),
      website: Value(profile.website),
      postalCode: Value(address.postalCode),
      street: Value(address.street),
      number: Value(address.number),
      complement: Value(address.complement),
      neighborhood: Value(address.neighborhood),
      city: Value(address.city),
      state: Value(address.state),
      repFullName: Value(legalRepresentative?.fullName),
      repCpfDigits: Value(legalRepresentative?.cpfDigits),
      repRole: Value(legalRepresentative?.role),
      pixKeyType: Value(paymentInfo?.pixKeyType?.name),
      pixKey: Value(paymentInfo?.pixKey),
      beneficiaryName: Value(paymentInfo?.beneficiaryName),
      paymentTerms: Value(paymentInfo?.paymentTerms),
      defaultValidityDays: profile.quoteDefaults.defaultValidityDays,
      defaultPublicNotes: Value(profile.quoteDefaults.defaultPublicNotes),
      createdAt: TimestampConverter.toUtcMillis(profile.createdAt),
      updatedAt: TimestampConverter.toUtcMillis(profile.updatedAt),
    );
  }

  static CompanyAddress _toAddress(CompanyProfileRow row) {
    return CompanyAddress(
      postalCode: row.postalCode,
      street: row.street,
      number: row.number,
      complement: row.complement,
      neighborhood: row.neighborhood,
      city: row.city,
      state: row.state,
    );
  }

  static LegalRepresentative? _toLegalRepresentative(CompanyProfileRow row) {
    final representative = LegalRepresentative(
      fullName: row.repFullName,
      cpfDigits: row.repCpfDigits,
      role: row.repRole,
    );

    return representative.isEmpty ? null : representative;
  }

  static CompanyPaymentInfo? _toPaymentInfo(CompanyProfileRow row) {
    final paymentInfo = CompanyPaymentInfo(
      pixKeyType: _parsePixKeyType(row.pixKeyType),
      pixKey: row.pixKey,
      beneficiaryName: row.beneficiaryName,
      paymentTerms: row.paymentTerms,
    );

    return paymentInfo.isEmpty ? null : paymentInfo;
  }

  static PixKeyType? _parsePixKeyType(String? value) {
    if (value == null) {
      return null;
    }

    return PixKeyType.values.firstWhere((type) => type.name == value);
  }
}
