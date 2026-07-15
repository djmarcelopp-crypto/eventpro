import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/app/router/app_router.dart';
import 'package:eventpro/features/quotes/models/quote_company_capture_status.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/providers/quote_company_logo_storage_provider.dart';
import 'package:eventpro/features/quotes/providers/quotes_provider.dart';
import 'package:eventpro/features/settings/models/company_profile.dart';
import 'package:eventpro/features/settings/providers/company_profile_provider.dart';
import 'package:eventpro/main.dart';

import 'fakes/fake_quote_company_logo_storage_service.dart';
import 'quote_e2e_helpers.dart';
import 'quotes_test_helpers.dart';

void main() {
  group('TASK-019 Checkpoint B — save com snapshot', () {
    late FakeQuoteCompanyLogoStorageService fakeLogoStorage;

    setUp(() {
      fakeLogoStorage = FakeQuoteCompanyLogoStorageService();
      fakeLogoStorage.seedSettingsLogo(
        'settings/logo/profile_save.png',
        Uint8List.fromList([1, 2, 3, 4]),
      );
    });

    tearDown(() {
      AppRouter.router.go(AppRoutes.dashboard);
    });

    Future<ProviderContainer> pumpNewQuoteForm(
      WidgetTester tester, {
      CompanyProfile? profile,
    }) async {
      useTallViewport(tester);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ...quoteE2eOverrides(),
            quoteCompanyLogoStorageProvider.overrideWithValue(fakeLogoStorage),
          ],
          child: const EventProApp(),
        ),
      );

      final container = quoteTestContainer(tester);
      await seedQuoteDependencies(container);

      if (profile != null) {
        await container.read(companyProfileProvider.notifier).save(profile);
      }

      AppRouter.router.go(AppRoutes.quotesNew);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('quote_select_client_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Maria Silva'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('quote_add_catalog_item_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Caixa de som'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('quote_line_price_line_1')),
        '1.500,00',
      );
      await tester.pumpAndSettle();

      return container;
    }

    testWidgets('criação com perfil configurado congela snapshot', (
      tester,
    ) async {
      final container = await pumpNewQuoteForm(
        tester,
        profile: sampleConfiguredCompanyProfile(
          timestamp: quoteE2eFixedNow,
          logoReference: 'settings/logo/profile_save.png',
        ),
      );

      await tapQuoteSave(tester);

      final quote = container.read(quotesProvider).single;
      expect(quote.companySnapshot, isNotNull);
      expect(
        quote.companySnapshot!.captureStatus,
        QuoteCompanyCaptureStatus.configured,
      );
      expect(quote.companySnapshot!.identification.tradeName, 'DJ Marcelo PP');
      expect(quote.companySnapshot!.capturedAt, quoteE2eFixedNow);
      expect(quote.companySnapshot!.logoReference, isNotNull);
      expect(
        quote.companySnapshot!.logoReference,
        startsWith('quotes/company-assets/'),
      );
      expect(fakeLogoStorage.copyCallCount, 1);
    });

    testWidgets('criação com perfil incompleto congela snapshot parcial', (
      tester,
    ) async {
      final container = await pumpNewQuoteForm(
        tester,
        profile: sampleIncompleteCompanyProfile(timestamp: quoteE2eFixedNow),
      );

      await tapQuoteSave(tester);

      final quote = container.read(quotesProvider).single;
      expect(quote.companySnapshot, isNotNull);
      expect(
        quote.companySnapshot!.captureStatus,
        QuoteCompanyCaptureStatus.incomplete,
      );
      expect(quote.companySnapshot!.logoReference, isNull);
      expect(fakeLogoStorage.copyCallCount, 0);
    });

    testWidgets('criação sem perfil mantém snapshot null', (tester) async {
      final container = await pumpNewQuoteForm(tester);

      await tapQuoteSave(tester);

      final quote = container.read(quotesProvider).single;
      expect(quote.companySnapshot, isNull);
      expect(fakeLogoStorage.copyCallCount, 0);
    });

    testWidgets('edição preserva snapshot existente', (tester) async {
      final snapshot = sampleCompanySnapshot(capturedAt: quoteE2eFixedNow);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ...quoteE2eOverrides(),
            quoteCompanyLogoStorageProvider.overrideWithValue(fakeLogoStorage),
          ],
          child: const EventProApp(),
        ),
      );

      final container = quoteTestContainer(tester);
      await seedQuote(
        container,
        sampleQuoteDraft(
          id: 'quote-edit-snap',
          companySnapshot: snapshot,
        ).copyWith(status: QuoteStatus.draft, approvedAt: null),
      );

      AppRouter.router.go(AppRoutes.quotesEdit('quote-edit-snap'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('quote_notes_field')),
        'Nota editada',
      );
      await tester.pumpAndSettle();

      await tapQuoteSave(tester);

      final quote = container
          .read(quotesProvider.notifier)
          .findById('quote-edit-snap')!;
      expect(quote.companySnapshot, snapshot);
      expect(quote.notes, 'Nota editada');
      expect(fakeLogoStorage.copyCallCount, 0);
    });

    testWidgets('duplo clique não duplica orçamento nem logo', (tester) async {
      final container = await pumpNewQuoteForm(
        tester,
        profile: sampleConfiguredCompanyProfile(
          timestamp: quoteE2eFixedNow,
          logoReference: 'settings/logo/profile_save.png',
        ),
      );

      final saveButton = find.byKey(const Key('quote_save_button'));
      await scrollQuoteFormUntilVisible(tester, saveButton);
      await tester.tap(saveButton);
      await tester.pump();
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(container.read(quotesProvider), hasLength(1));
      expect(fakeLogoStorage.copyCallCount, 1);
    });
  });
}
