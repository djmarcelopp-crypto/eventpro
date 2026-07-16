import 'package:eventpro/core/lookup/exceptions/cep_lookup_exception.dart';
import 'package:eventpro/core/lookup/exceptions/cnpj_lookup_exception.dart';
import 'package:eventpro/core/lookup/providers/cep_lookup_provider.dart';
import 'package:eventpro/core/lookup/providers/cnpj_lookup_provider.dart';
import 'package:eventpro/core/media/models/app_image_pick_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/app/router/app_router.dart';
import 'package:eventpro/features/settings/data/services/local_company_logo_storage_service.dart';
import 'package:eventpro/features/settings/models/company_profile.dart';
import 'package:eventpro/features/settings/providers/company_logo_services_provider.dart';
import 'package:eventpro/features/settings/providers/company_profile_provider.dart';
import 'package:eventpro/main.dart';

import 'fakes/fake_company_logo_picker_service.dart';
import 'fakes/fake_company_logo_storage_service.dart';
import 'fakes/fake_settings_cep_lookup_service.dart';
import 'fakes/fake_settings_cnpj_lookup_service.dart';
import '../agenda/fakes/agenda_block_repository_test_overrides.dart';
import '../catalog/fakes/catalog_repository_test_overrides.dart';
import '../clients/fakes/client_repository_test_overrides.dart';
import '../quotes/fakes/quote_repository_test_overrides.dart';
import 'fakes/company_profile_repository_test_overrides.dart';

void main() {
  group('Settings Checkpoint C', () {
    late FakeCompanyLogoPickerService fakeLogoPicker;
    late FakeCompanyLogoStorageService fakeLogoStorage;
    late FakeSettingsCnpjLookupService fakeCnpjLookup;
    late FakeSettingsCepLookupService fakeCepLookup;

    setUp(() {
      fakeLogoPicker = FakeCompanyLogoPickerService(
        pickResult: AppImagePickResult(
          bytes: kSettingsTestPngBytes,
          extension: 'png',
        ),
      );
      fakeLogoStorage = FakeCompanyLogoStorageService();
      fakeCnpjLookup = FakeSettingsCnpjLookupService();
      fakeCepLookup = FakeSettingsCepLookupService();
    });

    tearDown(() {
      AppRouter.router.go(AppRoutes.dashboard);
    });

    Future<void> pumpApp(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ...clientRepositoryOverrides(),
            ...companyProfileRepositoryOverrides(),
            ...catalogRepositoryOverrides(),
            ...quoteRepositoryOverrides(),
            ...agendaBlockRepositoryOverrides(),
            companyLogoPickerProvider.overrideWithValue(fakeLogoPicker),
            companyLogoStorageProvider.overrideWithValue(fakeLogoStorage),
            cnpjLookupServiceProvider.overrideWithValue(fakeCnpjLookup),
            cepLookupServiceProvider.overrideWithValue(fakeCepLookup),
          ],
          child: const EventProApp(),
        ),
      );
      AppRouter.router.go(AppRoutes.dashboard);
      await tester.pumpAndSettle();
    }

    Future<void> scrollTo(WidgetTester tester, Finder target) async {
      final scrollable = find.ancestor(
        of: target,
        matching: find.byType(Scrollable),
      );
      await tester.scrollUntilVisible(target, 1200, scrollable: scrollable);
      await tester.pumpAndSettle();
      await tester.ensureVisible(target);
      await tester.pumpAndSettle();
    }

    Future<void> tapCompanyProfileSave(WidgetTester tester) async {
      final saveButton = find.byKey(const Key('company_profile_save_button'));
      await scrollTo(tester, saveButton);
      await tester.tap(saveButton);
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();
    }

    Future<void> enterValidCnpj(WidgetTester tester) async {
      await tester.enterText(
        find.byKey(const Key('company_cnpj_field')),
        '11222333000181',
      );
      await tester.pumpAndSettle();
    }

    Future<void> tapCnpjLookup(WidgetTester tester) async {
      final button = find.byKey(const Key('settings_cnpj_lookup_button'));
      await scrollTo(tester, button);
      await tester.tap(button);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
    }

    Future<void> tapCepLookup(WidgetTester tester) async {
      final button = find.byKey(const Key('settings_cep_lookup_button'));
      await scrollTo(tester, button);
      await tester.tap(button);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
    }

    Future<void> tapLogoButton(WidgetTester tester, Key key) async {
      final button = find.byKey(key);
      await scrollTo(tester, button);
      await tester.tap(button);
      for (var attempt = 0; attempt < 30; attempt++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pumpAndSettle();
    }

    Future<void> fillMinimumProfile(WidgetTester tester) async {
      await tester.enterText(
        find.byKey(const Key('company_trade_name_field')),
        'DJ Marcelo PP',
      );
      await tester.enterText(
        find.byKey(const Key('company_phone_field')),
        '67999998888',
      );
    }

    Future<void> fillCompleteProfile(WidgetTester tester) async {
      await fillMinimumProfile(tester);
      await tester.enterText(
        find.byKey(const Key('company_legal_name_field')),
        'Marcelo PP Festas LTDA',
      );
      await tester.enterText(
        find.byKey(const Key('company_cnpj_field')),
        '11222333000181',
      );
      await tester.enterText(
        find.byKey(const Key('company_postal_code_field')),
        '79002010',
      );
      await tester.enterText(
        find.byKey(const Key('company_street_field')),
        'Rua Example',
      );
      await tester.enterText(
        find.byKey(const Key('company_number_field')),
        '100',
      );
      await tester.enterText(
        find.byKey(const Key('company_city_field')),
        'Campo Grande',
      );
      await tester.enterText(
        find.byKey(const Key('company_state_field')),
        'MS',
      );
      await tester.enterText(
        find.byKey(const Key('company_legal_full_name_field')),
        'Marcelo PP',
      );
      await tester.enterText(
        find.byKey(const Key('company_legal_cpf_field')),
        '52998224725',
      );
    }

    testWidgets('Dashboard → Configurações → Dados da empresa → Dashboard', (
      tester,
    ) async {
      await pumpApp(tester);
      AppRouter.router.go(AppRoutes.dashboard);
      await tester.pumpAndSettle();

      final settingsCard = find.text('Configurações');
      final dashboardScrollable = find.ancestor(
        of: settingsCard,
        matching: find.byType(Scrollable),
      );
      await tester.scrollUntilVisible(
        settingsCard,
        300,
        scrollable: dashboardScrollable,
      );
      await tester.pumpAndSettle();
      await tester.tap(settingsCard);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('settings_scroll')), findsOneWidget);

      await tester.tap(find.byKey(const Key('settings_company_profile_card')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('company_profile_scroll')), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('settings_scroll')), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('criar perfil mínimo exibe status Incompleto', (tester) async {
      await pumpApp(tester);
      AppRouter.router.go(AppRoutes.settingsCompany);
      await tester.pumpAndSettle();

      await fillMinimumProfile(tester);
      await tapCompanyProfileSave(tester);
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('settings_status_badge_incomplete')),
        findsOneWidget,
      );
    });

    testWidgets('completar recomendados exibe status Configurado', (
      tester,
    ) async {
      await pumpApp(tester);
      AppRouter.router.go(AppRoutes.settingsCompany);
      await tester.pumpAndSettle();

      await fillCompleteProfile(tester);
      await tapCompanyProfileSave(tester);
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('settings_status_badge_configured')),
        findsOneWidget,
      );
    });

    testWidgets('editar perfil não duplica registro', (tester) async {
      await pumpApp(tester);
      AppRouter.router.go(AppRoutes.settingsCompany);
      await tester.pumpAndSettle();

      await fillMinimumProfile(tester);
      await tapCompanyProfileSave(tester);
      await tester.pump(const Duration(seconds: 4));

      final container = ProviderScope.containerOf(
        tester.element(find.byType(EventProApp)),
      );
      final firstCreatedAt = container.read(companyProfileProvider)!.createdAt;

      AppRouter.router.go(AppRoutes.settingsCompany);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('company_legal_name_field')),
        'Marcelo PP Festas LTDA',
      );
      await tapCompanyProfileSave(tester);
      await tester.pumpAndSettle();

      final profile = container.read(companyProfileProvider)!;
      expect(profile.legalName, 'Marcelo PP Festas LTDA');
      expect(profile.createdAt, firstCreatedAt);
    });

    testWidgets('logo: selecionar, trocar e remover', (tester) async {
      await pumpApp(tester);
      AppRouter.router.go(AppRoutes.settingsCompany);
      await tester.pumpAndSettle();

      await fillMinimumProfile(tester);
      await tapLogoButton(tester, const Key('company_select_logo_button'));
      expect(fakeLogoStorage.stageCallCount, 1);
      expect(
        find.byKey(const Key('company_replace_logo_button')),
        findsOneWidget,
      );

      fakeLogoPicker.pickCount = 0;
      await tapLogoButton(tester, const Key('company_replace_logo_button'));
      expect(fakeLogoPicker.pickCount, 1);
      expect(fakeLogoStorage.stageCallCount, 2);

      await tapLogoButton(tester, const Key('company_remove_logo_button'));
      expect(fakeLogoStorage.discardLog, isNotEmpty);
      expect(
        find.byKey(const Key('company_select_logo_button')),
        findsOneWidget,
      );

      await tapCompanyProfileSave(tester);
      await tester.pumpAndSettle();

      final profile = ProviderScope.containerOf(
        tester.element(find.byType(EventProApp)),
      ).read(companyProfileProvider)!;
      expect(profile.logoReference, isNull);
    });

    testWidgets('cancelar seletor de logo é silencioso', (tester) async {
      fakeLogoPicker = FakeCompanyLogoPickerService(pickResult: null);

      await pumpApp(tester);
      AppRouter.router.go(AppRoutes.settingsCompany);
      await tester.pumpAndSettle();

      await tapLogoButton(tester, const Key('company_select_logo_button'));

      expect(fakeLogoStorage.stageCallCount, 0);
      expect(find.textContaining('Não foi possível'), findsNothing);
    });

    testWidgets('logo staged descartado ao sair sem salvar', (tester) async {
      await pumpApp(tester);
      AppRouter.router.go(AppRoutes.settingsCompany);
      await tester.pumpAndSettle();

      await tapLogoButton(tester, const Key('company_select_logo_button'));
      final staged = fakeLogoStorage.lastStagedReference;
      expect(staged, isNotNull);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('Descartar alterações?'), findsOneWidget);

      await tester.tap(
        find.byKey(const Key('settings_discard_confirm_button')),
      );
      await tester.pumpAndSettle();

      expect(fakeLogoStorage.discardLog, contains(staged));
      expect(find.byKey(const Key('settings_scroll')), findsOneWidget);
    });

    testWidgets('logo anterior preservado quando edição é descartada', (
      tester,
    ) async {
      const originalReference =
          '${LocalCompanyLogoStorageService.committedPrefix}company_original.png';
      fakeLogoStorage.seedCommitted(originalReference, kSettingsTestPngBytes);

      await pumpApp(tester);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(EventProApp)),
      );
      await container
          .read(companyProfileProvider.notifier)
          .save(
            CompanyProfile(
              tradeName: 'DJ Marcelo PP',
              phoneDigits: '67999998888',
              logoReference: originalReference,
              createdAt: DateTime(2026, 7, 13),
              updatedAt: DateTime(2026, 7, 13),
            ),
          );

      AppRouter.router.go(AppRoutes.settingsCompany);
      await tester.pumpAndSettle();

      await tapLogoButton(tester, const Key('company_replace_logo_button'));

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('settings_discard_confirm_button')),
      );
      await tester.pumpAndSettle();

      final profile = container.read(companyProfileProvider)!;
      expect(profile.logoReference, originalReference);
      expect(fakeLogoStorage.deleteLog, isEmpty);
    });

    testWidgets('CNPJ preenche campos vazios', (tester) async {
      await pumpApp(tester);
      AppRouter.router.go(AppRoutes.settingsCompany);
      await tester.pumpAndSettle();

      await enterValidCnpj(tester);
      await tapCnpjLookup(tester);

      expect(fakeCnpjLookup.lookupCount, 1);
      expect(find.text('Marcelo PP Festas LTDA'), findsOneWidget);
      expect(find.text('DJ Marcelo PP'), findsOneWidget);
    });

    testWidgets('CNPJ exibe diálogo de conflito', (tester) async {
      await pumpApp(tester);
      AppRouter.router.go(AppRoutes.settingsCompany);
      await tester.pumpAndSettle();

      await enterValidCnpj(tester);
      await tester.enterText(
        find.byKey(const Key('company_trade_name_field')),
        'Nome Atual',
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('settings_cnpj_lookup_button')),
        findsOneWidget,
      );
      await tapCnpjLookup(tester);

      expect(find.text('Alguns campos já estão preenchidos'), findsOneWidget);
      await tester.tap(
        find.byKey(const Key('settings_conflict_replace_button')),
      );
      await tester.pumpAndSettle();

      expect(find.text('DJ Marcelo PP'), findsOneWidget);
    });

    testWidgets('CNPJ erro da API não bloqueia cadastro manual', (
      tester,
    ) async {
      fakeCnpjLookup = FakeSettingsCnpjLookupService(
        exception: const CnpjLookupException(CnpjLookupFailure.notFound),
      );

      await pumpApp(tester);
      AppRouter.router.go(AppRoutes.settingsCompany);
      await tester.pumpAndSettle();

      await enterValidCnpj(tester);
      await tapCnpjLookup(tester);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('company_profile_scroll')), findsOneWidget);
      expect(find.textContaining('Empresa não encontrada'), findsOneWidget);

      await tester.pump(const Duration(seconds: 4));

      await fillMinimumProfile(tester);
      await tapCompanyProfileSave(tester);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('settings_scroll')), findsOneWidget);
    });

    testWidgets('CEP preenche endereço preservando número e complemento', (
      tester,
    ) async {
      await pumpApp(tester);
      AppRouter.router.go(AppRoutes.settingsCompany);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('company_postal_code_field')),
        '79002010',
      );
      await tester.enterText(
        find.byKey(const Key('company_number_field')),
        '42',
      );
      await tester.enterText(
        find.byKey(const Key('company_complement_field')),
        'Sala 3',
      );
      await tester.pumpAndSettle();

      await tapCepLookup(tester);
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 4));

      expect(fakeCepLookup.lookupCount, 1);
      expect(find.text('Rua Exemplo'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
      expect(find.text('Sala 3'), findsOneWidget);
    });

    testWidgets('CEP exibe diálogo de conflito', (tester) async {
      await pumpApp(tester);
      AppRouter.router.go(AppRoutes.settingsCompany);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('company_postal_code_field')),
        '79002010',
      );
      await tester.enterText(
        find.byKey(const Key('company_street_field')),
        'Rua Antiga',
      );
      await tester.pumpAndSettle();

      await tapCepLookup(tester);

      expect(find.text('Alguns campos já estão preenchidos'), findsOneWidget);
      await tester.tap(
        find.byKey(const Key('settings_conflict_fill_empty_button')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Rua Antiga'), findsOneWidget);
    });

    testWidgets('CEP erro da API não bloqueia cadastro manual', (tester) async {
      fakeCepLookup = FakeSettingsCepLookupService(
        exception: const CepLookupException(CepLookupFailure.notFound),
      );

      await pumpApp(tester);
      AppRouter.router.go(AppRoutes.settingsCompany);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('company_postal_code_field')),
        '79002010',
      );
      await tester.pumpAndSettle();
      await tapCepLookup(tester);
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 4));

      await fillMinimumProfile(tester);
      await tapCompanyProfileSave(tester);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('settings_scroll')), findsOneWidget);
    });

    testWidgets('dirty form manual exibe diálogo ao sair', (tester) async {
      await pumpApp(tester);
      AppRouter.router.go(AppRoutes.settingsCompany);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('company_trade_name_field')),
        'Alteração manual',
      );

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('Descartar alterações?'), findsOneWidget);
      await tester.tap(find.byKey(const Key('settings_discard_cancel_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('company_profile_scroll')), findsOneWidget);
    });

    testWidgets('dirty form após lookup exibe diálogo ao sair', (tester) async {
      await pumpApp(tester);
      AppRouter.router.go(AppRoutes.settingsCompany);
      await tester.pumpAndSettle();

      await enterValidCnpj(tester);
      await tapCnpjLookup(tester);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text('Descartar alterações?'), findsOneWidget);
    });

    testWidgets('PIX inválido não expõe a chave na mensagem', (tester) async {
      await pumpApp(tester);
      AppRouter.router.go(AppRoutes.settingsCompany);
      await tester.pumpAndSettle();

      await fillMinimumProfile(tester);

      final pixTypeField = find.byKey(const Key('company_pix_key_type_field'));
      await scrollTo(tester, pixTypeField);
      await tester.tap(pixTypeField);
      await tester.pumpAndSettle();
      await tester.tap(find.text('E-mail').last);
      await tester.pumpAndSettle();

      const secretPix = 'invalido';
      final pixKeyField = find.byKey(const Key('company_pix_key_field'));
      await scrollTo(tester, pixKeyField);
      await tester.enterText(pixKeyField, secretPix);

      await tapCompanyProfileSave(tester);
      await tester.pumpAndSettle();

      expect(
        find.text('Chave PIX inválida para o tipo selecionado'),
        findsOneWidget,
      );
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('salvar não exibe diálogo de descarte', (tester) async {
      await pumpApp(tester);
      AppRouter.router.go(AppRoutes.settingsCompany);
      await tester.pumpAndSettle();

      await fillMinimumProfile(tester);
      await tapCompanyProfileSave(tester);
      await tester.pumpAndSettle();

      expect(find.text('Descartar alterações?'), findsNothing);
      expect(find.byKey(const Key('settings_scroll')), findsOneWidget);
    });
  });
}
