import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/settings/data/mappers/company_profile_mapper.dart';
import 'package:eventpro/features/settings/models/company_address.dart';
import 'package:eventpro/features/settings/models/company_payment_info.dart';
import 'package:eventpro/features/settings/models/company_profile.dart';
import 'package:eventpro/features/settings/models/company_quote_defaults.dart';
import 'package:eventpro/features/settings/models/legal_representative.dart';
import 'package:eventpro/features/settings/models/pix_key_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final createdAt = DateTime(2024, 5, 10, 9, 15);
  final updatedAt = DateTime(2024, 5, 11, 14, 30);

  CompanyProfile buildSampleProfile({
    CompanyAddress? address,
    LegalRepresentative? legalRepresentative,
    CompanyPaymentInfo? paymentInfo,
    String? logoReference,
    bool clearLogoReference = false,
    bool clearLegalRepresentative = false,
    bool clearPaymentInfo = false,
  }) {
    return CompanyProfile(
      tradeName: 'DJ Marcelo PP',
      legalName: 'Marcelo PP Festas LTDA',
      cnpjDigits: '11222333000181',
      stateRegistration: '123456789',
      logoReference: clearLogoReference
          ? null
          : logoReference ?? 'settings/logo/a.jpg',
      phoneDigits: '6732321234',
      whatsAppDigits: '67981495959',
      email: 'contato@djmarcelo.com',
      instagram: '@djmarcelo',
      website: 'https://djmarcelo.com',
      address:
          address ??
          const CompanyAddress(
            postalCode: '79002010',
            street: 'Rua A',
            number: '100',
            complement: 'Sala 2',
            neighborhood: 'Centro',
            city: 'Campo Grande',
            state: 'MS',
          ),
      legalRepresentative: clearLegalRepresentative
          ? null
          : legalRepresentative ??
                const LegalRepresentative(
                  fullName: 'Marcelo PP',
                  cpfDigits: '52998224725',
                  role: 'Sócio',
                ),
      paymentInfo: clearPaymentInfo
          ? null
          : paymentInfo ??
                const CompanyPaymentInfo(
                  pixKeyType: PixKeyType.cnpj,
                  pixKey: '11222333000181',
                  beneficiaryName: 'Marcelo PP Festas',
                  paymentTerms: '50% na assinatura',
                ),
      quoteDefaults: const CompanyQuoteDefaults(
        defaultValidityDays: 14,
        defaultPublicNotes: 'Proposta válida conforme condições.',
      ),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  group('CompanyProfileMapper', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'company_profile_mapper_',
      );
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    Future<CompanyProfile> persistAndReload(CompanyProfile profile) async {
      await database.companyProfilesDao.upsertRow(
        CompanyProfileMapper.toUpsertCompanion(profile),
      );
      final row = await database.companyProfilesDao.getSingleton();
      expect(row, isNotNull);
      return CompanyProfileMapper.toDomain(row!);
    }

    test('round-trips all populated fields', () async {
      final original = buildSampleProfile();

      final restored = await persistAndReload(original);

      expect(restored.tradeName, original.tradeName);
      expect(restored.legalName, original.legalName);
      expect(restored.cnpjDigits, original.cnpjDigits);
      expect(restored.stateRegistration, original.stateRegistration);
      expect(restored.logoReference, original.logoReference);
      expect(restored.phoneDigits, original.phoneDigits);
      expect(restored.whatsAppDigits, original.whatsAppDigits);
      expect(restored.email, original.email);
      expect(restored.instagram, original.instagram);
      expect(restored.website, original.website);
      expect(restored.address.postalCode, original.address.postalCode);
      expect(restored.address.street, original.address.street);
      expect(restored.address.number, original.address.number);
      expect(restored.address.complement, original.address.complement);
      expect(restored.address.neighborhood, original.address.neighborhood);
      expect(restored.address.city, original.address.city);
      expect(restored.address.state, original.address.state);
      expect(
        restored.legalRepresentative?.fullName,
        original.legalRepresentative?.fullName,
      );
      expect(
        restored.legalRepresentative?.cpfDigits,
        original.legalRepresentative?.cpfDigits,
      );
      expect(
        restored.legalRepresentative?.role,
        original.legalRepresentative?.role,
      );
      expect(
        restored.paymentInfo?.pixKeyType,
        original.paymentInfo?.pixKeyType,
      );
      expect(restored.paymentInfo?.pixKey, original.paymentInfo?.pixKey);
      expect(
        restored.paymentInfo?.beneficiaryName,
        original.paymentInfo?.beneficiaryName,
      );
      expect(
        restored.paymentInfo?.paymentTerms,
        original.paymentInfo?.paymentTerms,
      );
      expect(
        restored.quoteDefaults.defaultValidityDays,
        original.quoteDefaults.defaultValidityDays,
      );
      expect(
        restored.quoteDefaults.defaultPublicNotes,
        original.quoteDefaults.defaultPublicNotes,
      );
      expect(restored.createdAt, original.createdAt);
      expect(restored.updatedAt, original.updatedAt);
    });

    test('round-trips empty optional sub-objects as null', () async {
      final original = buildSampleProfile(
        address: const CompanyAddress(),
        clearLegalRepresentative: true,
        clearPaymentInfo: true,
        clearLogoReference: true,
      );

      final restored = await persistAndReload(original);

      expect(restored.logoReference, isNull);
      expect(restored.legalRepresentative, isNull);
      expect(restored.paymentInfo, isNull);
      expect(restored.address.isEmpty, isTrue);
      expect(restored.quoteDefaults.defaultValidityDays, 14);
    });

    test('persists singleton id as default', () async {
      await persistAndReload(buildSampleProfile());

      final row = await database.companyProfilesDao.getSingleton();
      expect(row?.id, kDefaultCompanyProfileId);
    });

    test('preserves timestamps through UTC conversion', () async {
      final restored = await persistAndReload(buildSampleProfile());

      expect(restored.createdAt, createdAt);
      expect(restored.updatedAt, updatedAt);
    });
  });
}
