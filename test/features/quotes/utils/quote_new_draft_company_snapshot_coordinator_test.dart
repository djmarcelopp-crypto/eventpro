import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote_company_capture_status.dart';
import 'package:eventpro/features/quotes/utils/quote_company_snapshot_builder.dart';
import 'package:eventpro/features/quotes/utils/quote_new_draft_company_snapshot_coordinator.dart';

import '../fakes/fake_quote_company_logo_storage_service.dart';
import '../quotes_test_helpers.dart';

void main() {
  group('QuoteNewDraftCompanySnapshotCoordinator', () {
    final fixedNow = DateTime(2026, 7, 13, 10, 30);

    test('criação sem perfil retorna snapshot null', () async {
      final fakeLogo = FakeQuoteCompanyLogoStorageService();
      final coordinator = QuoteNewDraftCompanySnapshotCoordinator(
        logoStorage: fakeLogo,
      );

      final result = await coordinator.build(
        profile: null,
        quoteId: 'quote-1',
        timestamp: fixedNow,
      );

      expect(result.snapshot, isNull);
      expect(result.copiedLogoReference, isNull);
      expect(fakeLogo.copyCallCount, 0);
    });

    test('criação com perfil incompleto retorna snapshot parcial', () async {
      final fakeLogo = FakeQuoteCompanyLogoStorageService();
      final coordinator = QuoteNewDraftCompanySnapshotCoordinator(
        logoStorage: fakeLogo,
      );

      final result = await coordinator.build(
        profile: sampleIncompleteCompanyProfile(timestamp: fixedNow),
        quoteId: 'quote-2',
        timestamp: fixedNow,
      );

      expect(result.snapshot, isNotNull);
      expect(
        result.snapshot!.captureStatus,
        QuoteCompanyCaptureStatus.incomplete,
      );
      expect(result.copiedLogoReference, isNull);
    });

    test('criação com perfil configurado e logo copia referência', () async {
      final fakeLogo = FakeQuoteCompanyLogoStorageService();
      fakeLogo.seedSettingsLogo(
        'settings/logo/profile_1.png',
        Uint8List.fromList([1, 2, 3]),
      );
      final coordinator = QuoteNewDraftCompanySnapshotCoordinator(
        logoStorage: fakeLogo,
      );

      final result = await coordinator.build(
        profile: sampleConfiguredCompanyProfile(
          timestamp: fixedNow,
          logoReference: 'settings/logo/profile_1.png',
        ),
        quoteId: 'quote-3',
        timestamp: fixedNow,
      );

      expect(result.snapshot, isNotNull);
      expect(
        result.snapshot!.captureStatus,
        QuoteCompanyCaptureStatus.configured,
      );
      expect(result.copiedLogoReference, isNotNull);
      expect(
        result.copiedLogoReference,
        'quotes/company-assets/quote-3_${fixedNow.microsecondsSinceEpoch}.png',
      );
      expect(result.snapshot!.logoReference, result.copiedLogoReference);
      expect(result.snapshot!.capturedAt, fixedNow);
      expect(fakeLogo.copyCallCount, 1);
    });

    test('logo ausente funciona sem erro', () async {
      final fakeLogo = FakeQuoteCompanyLogoStorageService();
      final coordinator = QuoteNewDraftCompanySnapshotCoordinator(
        logoStorage: fakeLogo,
      );

      final result = await coordinator.build(
        profile: sampleConfiguredCompanyProfile(timestamp: fixedNow),
        quoteId: 'quote-4',
        timestamp: fixedNow,
      );

      expect(result.snapshot, isNotNull);
      expect(result.copiedLogoReference, isNull);
      expect(result.snapshot!.logoReference, isNull);
      expect(fakeLogo.copyCallCount, 0);
    });

    test('rollback remove cópia após falha simulada', () async {
      final fakeLogo = FakeQuoteCompanyLogoStorageService();
      fakeLogo.seedSettingsLogo(
        'settings/logo/profile_5.png',
        Uint8List.fromList([4, 5, 6]),
      );
      final coordinator = QuoteNewDraftCompanySnapshotCoordinator(
        logoStorage: fakeLogo,
      );

      final result = await coordinator.build(
        profile: sampleConfiguredCompanyProfile(
          timestamp: fixedNow,
          logoReference: 'settings/logo/profile_5.png',
        ),
        quoteId: 'quote-5',
        timestamp: fixedNow,
      );

      expect(await fakeLogo.exists(result.copiedLogoReference!), isTrue);

      await coordinator.rollbackCopiedLogo(result.copiedLogoReference);

      expect(fakeLogo.deleteLog, contains(result.copiedLogoReference));
      expect(await fakeLogo.exists(result.copiedLogoReference!), isFalse);
    });

    test('mesmo timestamp alimenta logo e capturedAt', () async {
      final fakeLogo = FakeQuoteCompanyLogoStorageService();
      fakeLogo.seedSettingsLogo(
        'settings/logo/profile_6.png',
        Uint8List.fromList([7, 8, 9]),
      );
      final coordinator = QuoteNewDraftCompanySnapshotCoordinator(
        logoStorage: fakeLogo,
      );
      final profile = sampleConfiguredCompanyProfile(
        timestamp: fixedNow,
        logoReference: 'settings/logo/profile_6.png',
      );

      final result = await coordinator.build(
        profile: profile,
        quoteId: 'quote-6',
        timestamp: fixedNow,
      );

      final directSnapshot = QuoteCompanySnapshotBuilder.fromProfile(
        profile: profile,
        capturedAt: fixedNow,
        logoReference: result.copiedLogoReference,
      );

      expect(result.snapshot!.capturedAt, fixedNow);
      expect(directSnapshot!.capturedAt, fixedNow);
      expect(
        result.copiedLogoReference,
        contains('${fixedNow.microsecondsSinceEpoch}'),
      );
    });
  });
}
