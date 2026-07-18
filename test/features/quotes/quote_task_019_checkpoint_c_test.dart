import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/app/router/app_router.dart';
import 'package:eventpro/core/widgets/app_text_field.dart';
import 'package:eventpro/core/widgets/primary_button.dart';
import 'package:eventpro/features/quotes/models/quote_company_capture_status.dart';
import 'package:eventpro/features/quotes/providers/quote_company_logo_storage_provider.dart';
import 'package:eventpro/features/quotes/providers/quotes_provider.dart';
import 'package:eventpro/features/quotes/utils/quote_date_formatter.dart';
import 'package:eventpro/features/settings/models/company_profile.dart';
import 'package:eventpro/features/settings/models/company_quote_defaults.dart';
import 'package:eventpro/features/settings/providers/company_profile_provider.dart';
import 'package:eventpro/main.dart';

import 'fakes/fake_quote_company_logo_storage_service.dart';
import 'quote_e2e_helpers.dart';
import 'quotes_test_helpers.dart';

void main() {
  group('TASK-019 Checkpoint C — defaults e banner', () {
    late FakeQuoteCompanyLogoStorageService fakeLogoStorage;

    setUp(() {
      fakeLogoStorage = FakeQuoteCompanyLogoStorageService();
    });

    tearDown(() {
      AppRouter.router.go(AppRoutes.dashboard);
    });

    Future<ProviderContainer> pumpNewQuoteFromList(
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

      AppRouter.router.go(AppRoutes.quotes);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('quotes_new_quote_button')));
      await tester.pumpAndSettle();

      return container;
    }

    String readFieldText(WidgetTester tester, String key) {
      return tester.widget<AppTextField>(find.byKey(Key(key))).controller!.text;
    }

    Future<void> fillMinimumQuoteForm(WidgetTester tester) async {
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
    }

    Future<void> scrollAndTapCompanySave(WidgetTester tester) async {
      final saveButton = find.byKey(const Key('company_profile_save_button'));
      final scrollable = find.ancestor(
        of: saveButton,
        matching: find.byType(Scrollable),
      );
      await tester.scrollUntilVisible(saveButton, 1200, scrollable: scrollable);
      await tester.pumpAndSettle();
      await tester.tap(saveButton);
      await tester.pump();
      await tester.pumpAndSettle();
    }

    testWidgets('fallback de 7 dias com relógio fixo', (tester) async {
      await pumpNewQuoteFromList(tester);

      final expected = QuoteDateFormatter.format(
        QuoteDateFormatter.addDays(
          QuoteDateFormatter.dateOnly(quoteE2eFixedNow),
          7,
        ),
      );

      expect(readFieldText(tester, 'quote_valid_until_field'), expected);
      expect(readFieldText(tester, 'quote_notes_field'), isEmpty);
    });

    testWidgets('defaults personalizados e notas públicas padrão', (
      tester,
    ) async {
      await pumpNewQuoteFromList(
        tester,
        profile: sampleConfiguredCompanyProfile(timestamp: quoteE2eFixedNow)
            .copyWith(
              quoteDefaults: const CompanyQuoteDefaults(
                defaultValidityDays: 14,
                defaultPublicNotes: 'Validade sujeita a disponibilidade.',
              ),
            ),
      );

      final expectedValidity = QuoteDateFormatter.format(
        QuoteDateFormatter.addDays(
          QuoteDateFormatter.dateOnly(quoteE2eFixedNow),
          14,
        ),
      );

      expect(
        readFieldText(tester, 'quote_valid_until_field'),
        expectedValidity,
      );
      expect(
        readFieldText(tester, 'quote_notes_field'),
        'Validade sujeita a disponibilidade.',
      );
    });

    testWidgets('defaults não marcam dirty', (tester) async {
      await pumpNewQuoteFromList(
        tester,
        profile: sampleConfiguredCompanyProfile(timestamp: quoteE2eFixedNow),
      );

      await tester.tap(find.byTooltip('Voltar'));
      await tester.pumpAndSettle();

      expect(find.text('Descartar alterações?'), findsNothing);
      expect(find.text('Orçamentos'), findsOneWidget);
    });

    testWidgets('edição ignora defaults atuais do perfil', (tester) async {
      final savedValidity = DateTime(2026, 9, 1);
      final savedNotes = 'Notas salvas no orçamento';

      await tester.pumpWidget(
        ProviderScope(
          overrides: quoteE2eOverrides(),
          child: const EventProApp(),
        ),
      );

      final container = quoteTestContainer(tester);
      await seedQuoteDependencies(container);
      await container
          .read(companyProfileProvider.notifier)
          .save(
            sampleConfiguredCompanyProfile(
              timestamp: quoteE2eFixedNow,
            ).copyWith(
              quoteDefaults: const CompanyQuoteDefaults(
                defaultValidityDays: 30,
                defaultPublicNotes: 'Defaults atuais do perfil',
              ),
            ),
          );

      await seedQuote(
        container,
        buildRichQuoteAddDraft(id: 'quote-edit-defaults').copyWith(
          validUntil: savedValidity,
          notes: savedNotes,
          approvedAt: null,
        ),
      );

      AppRouter.router.go(AppRoutes.quotesEdit('quote-edit-defaults'));
      await tester.pumpAndSettle();

      expect(
        readFieldText(tester, 'quote_valid_until_field'),
        QuoteDateFormatter.format(savedValidity),
      );
      expect(readFieldText(tester, 'quote_notes_field'), savedNotes);
      expect(
        find.byKey(const Key('quote_company_profile_banner')),
        findsNothing,
      );
    });

    testWidgets('perfil ausente exibe banner no novo orçamento', (
      tester,
    ) async {
      await pumpNewQuoteFromList(tester);

      expect(
        find.byKey(const Key('quote_company_profile_banner')),
        findsOneWidget,
      );
      expect(
        find.text(
          'Configure os dados da empresa para emitir documentos profissionais.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('perfil incompleto exibe pendências no banner', (tester) async {
      await pumpNewQuoteFromList(
        tester,
        profile: sampleIncompleteCompanyProfile(timestamp: quoteE2eFixedNow),
      );

      expect(find.text('Dados profissionais incompletos:'), findsOneWidget);
      expect(find.textContaining('Razão social'), findsOneWidget);
    });

    testWidgets('perfil configurado não exibe banner', (tester) async {
      await pumpNewQuoteFromList(
        tester,
        profile: sampleConfiguredCompanyProfile(timestamp: quoteE2eFixedNow),
      );

      expect(
        find.byKey(const Key('quote_company_profile_banner')),
        findsNothing,
      );
    });

    testWidgets('botão abre Settings e preserva formulário ao voltar', (
      tester,
    ) async {
      final container = await pumpNewQuoteFromList(tester);

      await fillMinimumQuoteForm(tester);

      await tester.enterText(
        find.byKey(const Key('quote_event_name_field')),
        'Casamento Teste',
      );
      await tester.enterText(
        find.byKey(const Key('quote_discount_field')),
        '10,00',
      );
      await tester.enterText(
        find.byKey(const Key('quote_freight_field')),
        '5,00',
      );
      await tester.enterText(
        find.byKey(const Key('quote_notes_field')),
        'Nota digitada pelo usuário',
      );
      await tester.pumpAndSettle();

      final validityBefore = readFieldText(tester, 'quote_valid_until_field');

      await tester.tap(find.byKey(const Key('quote_configure_company_button')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('company_profile_scroll')), findsOneWidget);

      await tester.tap(find.byTooltip('Voltar'));
      await tester.pumpAndSettle();

      expect(find.text('Novo orçamento'), findsOneWidget);
      expect(
        readFieldText(tester, 'quote_event_name_field'),
        'Casamento Teste',
      );
      expect(readFieldText(tester, 'quote_discount_field'), '10,00');
      expect(readFieldText(tester, 'quote_freight_field'), '5,00');
      expect(
        readFieldText(tester, 'quote_notes_field'),
        'Nota digitada pelo usuário',
      );
      expect(readFieldText(tester, 'quote_valid_until_field'), validityBefore);
      expect(container.read(quotesProvider), isEmpty);
    });

    testWidgets('defaults não são reaplicados após voltar de Settings', (
      tester,
    ) async {
      final container = await pumpNewQuoteFromList(
        tester,
        profile: sampleIncompleteCompanyProfile(timestamp: quoteE2eFixedNow),
      );

      final validityBefore = readFieldText(tester, 'quote_valid_until_field');

      await tester.tap(find.byKey(const Key('quote_configure_company_button')));
      await tester.pumpAndSettle();

      await container
          .read(companyProfileProvider.notifier)
          .save(
            sampleConfiguredCompanyProfile(
              timestamp: quoteE2eFixedNow,
            ).copyWith(
              quoteDefaults: const CompanyQuoteDefaults(
                defaultValidityDays: 30,
              ),
            ),
          );

      await tester.tap(find.byTooltip('Voltar'));
      await tester.pumpAndSettle();

      expect(readFieldText(tester, 'quote_valid_until_field'), validityBefore);
    });

    Future<void> invokeQuoteSave(WidgetTester tester) async {
      final saveButton = find.byKey(const Key('quote_save_button'));
      final formScrollable = find.ancestor(
        of: saveButton,
        matching: find.byType(Scrollable),
      );
      await tester.scrollUntilVisible(
        saveButton,
        800,
        scrollable: formScrollable,
      );
      await tester.pumpAndSettle();

      final button = tester.widget<PrimaryButton>(saveButton);
      expect(button.onPressed, isNotNull);
      button.onPressed!.call();
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();
    }

    testWidgets(
      'salvar após configurar empresa cria snapshot com perfil novo',
      (tester) async {
        tester.view.physicalSize = const Size(800, 3000);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final container = await pumpNewQuoteFromList(tester);
        await fillMinimumQuoteForm(tester);

        await tester.tap(
          find.byKey(const Key('quote_configure_company_button')),
        );
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('company_trade_name_field')),
          'DJ Marcelo PP',
        );
        await tester.enterText(
          find.byKey(const Key('company_phone_field')),
          '(67) 99999-0000',
        );
        await scrollAndTapCompanySave(tester);
        await tester.pumpAndSettle();

        if (find
            .byKey(const Key('company_profile_scroll'))
            .evaluate()
            .isNotEmpty) {
          await tester.tap(find.byTooltip('Voltar'));
          await tester.pumpAndSettle();
        }

        for (var i = 0; i < 8; i++) {
          await tester.pump(const Duration(milliseconds: 250));
        }
        await tester.pumpAndSettle();

        expect(find.text('Novo orçamento'), findsOneWidget);
        expect(find.byKey(const Key('quote_form_scroll')), findsOneWidget);
        expect(
          container.read(companyProfileProvider)?.tradeName,
          'DJ Marcelo PP',
        );

        await invokeQuoteSave(tester);

        expect(container.read(quotesProvider), hasLength(1));
        final quote = container.read(quotesProvider).single;
        expect(quote.companySnapshot, isNotNull);
        expect(
          quote.companySnapshot!.identification.tradeName,
          'DJ Marcelo PP',
        );
        expect(
          quote.companySnapshot!.captureStatus,
          QuoteCompanyCaptureStatus.incomplete,
        );
      },
    );
  });
}
