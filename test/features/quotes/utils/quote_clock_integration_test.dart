import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/providers/quote_clock_provider.dart';
import 'package:eventpro/features/quotes/utils/quote_company_snapshot_builder.dart';
import 'package:eventpro/features/settings/models/company_profile.dart';

import '../fakes/fake_quote_company_logo_storage_service.dart';

void main() {
  group('Integração de relógio — Checkpoint A', () {
    final fixedNow = DateTime(2026, 7, 13, 15, 47, 33, 500, 250);

    CompanyProfile sampleProfile() {
      return CompanyProfile(
        tradeName: 'DJ Marcelo PP',
        phoneDigits: '67999990000',
        createdAt: fixedNow,
        updatedAt: fixedNow,
      );
    }

    test('mesmo now alimenta capturedAt do snapshot', () {
      final now = fixedNow;

      final snapshot = QuoteCompanySnapshotBuilder.fromProfile(
        profile: sampleProfile(),
        capturedAt: now,
      );

      expect(snapshot!.capturedAt, now);
    });

    test('mesmo now alimenta timestamp do nome do logo', () async {
      final now = fixedNow;
      final fakeStorage = FakeQuoteCompanyLogoStorageService();
      fakeStorage.seedSettingsLogo(
        'settings/logo/profile_100.png',
        Uint8List.fromList([1, 2, 3]),
      );

      final copied = await fakeStorage.copyFromSettingsLogo(
        settingsLogoReference: 'settings/logo/profile_100.png',
        quoteId: 'quote-42',
        timestamp: now,
      );

      expect(
        copied,
        'quotes/company-assets/quote-42_${now.microsecondsSinceEpoch}.png',
      );
    });

    test('quoteClockProvider fornece now único para snapshot e logo', () async {
      final container = ProviderContainer(
        overrides: [
          quoteClockProvider.overrideWithValue(() => fixedNow),
        ],
      );
      addTearDown(container.dispose);

      final now = container.read(quoteClockProvider)();
      final fakeStorage = FakeQuoteCompanyLogoStorageService();
      fakeStorage.seedSettingsLogo(
        'settings/logo/profile_200.jpg',
        Uint8List.fromList([9, 8, 7]),
      );

      final snapshot = QuoteCompanySnapshotBuilder.fromProfile(
        profile: sampleProfile(),
        capturedAt: now,
      );

      final logoReference = await fakeStorage.copyFromSettingsLogo(
        settingsLogoReference: 'settings/logo/profile_200.jpg',
        quoteId: 'quote-99',
        timestamp: now,
      );

      expect(now, fixedNow);
      expect(snapshot!.capturedAt, now);
      expect(
        logoReference,
        'quotes/company-assets/quote-99_${now.microsecondsSinceEpoch}.jpg',
      );
    });
  });
}
