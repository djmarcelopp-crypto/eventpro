import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/app/router/app_router.dart';
import 'package:eventpro/features/settings/models/company_address.dart';
import 'package:eventpro/features/settings/models/company_profile.dart';
import 'package:eventpro/features/settings/models/legal_representative.dart';
import 'package:eventpro/features/settings/providers/company_profile_provider.dart';
import 'package:eventpro/core/widgets/app_text_field.dart';
import 'package:eventpro/main.dart';

import '../catalog/fakes/catalog_repository_test_overrides.dart';
import '../clients/fakes/client_repository_test_overrides.dart';
import '../quotes/fakes/quote_repository_test_overrides.dart';
import 'fakes/company_profile_repository_test_overrides.dart';

void main() {
  group('Settings Checkpoint B', () {
    Future<void> pumpApp(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ...clientRepositoryOverrides(),
            ...companyProfileRepositoryOverrides(),
            ...catalogRepositoryOverrides(),
            ...quoteRepositoryOverrides(),
          ],
          child: const EventProApp(),
        ),
      );
      await tester.pumpAndSettle();
    }

    Future<void> tapCompanyProfileSave(WidgetTester tester) async {
      final saveButton = find.byKey(const Key('company_profile_save_button'));
      final scrollable = find.ancestor(
        of: saveButton,
        matching: find.byType(Scrollable),
      );
      await tester.scrollUntilVisible(saveButton, 1200, scrollable: scrollable);
      await tester.pumpAndSettle();
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();
      await tester.tap(saveButton);
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();
    }

    testWidgets('Dashboard navega para Configurações', (tester) async {
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
      expect(find.text('Dados da empresa'), findsOneWidget);
    });

    testWidgets('estado não configurado exibe badge correto', (tester) async {
      await pumpApp(tester);
      AppRouter.router.go(AppRoutes.settings);
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('settings_status_badge_notConfigured')),
        findsOneWidget,
      );
      expect(find.text('Dados da empresa não configurados'), findsOneWidget);
    });

    testWidgets('Configurações abre formulário da empresa', (tester) async {
      await pumpApp(tester);
      AppRouter.router.go(AppRoutes.settings);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('settings_company_profile_card')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('company_profile_scroll')), findsOneWidget);
      expect(find.text('Identificação'), findsOneWidget);
      expect(find.text('Padrões de orçamento'), findsOneWidget);
      expect(
        find.byKey(const Key('company_default_validity_days_field')),
        findsOneWidget,
      );

      final validityField = tester.widget<AppTextField>(
        find.byKey(const Key('company_default_validity_days_field')),
      );
      expect(validityField.controller?.text, '7');
    });

    testWidgets('validade padrão inválida impede salvamento', (tester) async {
      await pumpApp(tester);
      AppRouter.router.go(AppRoutes.settingsCompany);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('company_trade_name_field')),
        'DJ Marcelo PP',
      );
      await tester.enterText(
        find.byKey(const Key('company_phone_field')),
        '67999998888',
      );
      await tester.enterText(
        find.byKey(const Key('company_default_validity_days_field')),
        '0',
      );

      await tapCompanyProfileSave(tester);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('company_profile_scroll')), findsOneWidget);
      expect(
        find.text('A validade padrão deve ser maior que zero'),
        findsOneWidget,
      );
    });

    testWidgets('condições de pagamento podem ser salvas sem PIX', (
      tester,
    ) async {
      await pumpApp(tester);
      AppRouter.router.go(AppRoutes.settingsCompany);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('company_trade_name_field')),
        'DJ Marcelo PP',
      );
      await tester.enterText(
        find.byKey(const Key('company_phone_field')),
        '67999998888',
      );

      final paymentField = find.byKey(const Key('company_payment_terms_field'));
      final scrollable = find.ancestor(
        of: paymentField,
        matching: find.byType(Scrollable),
      );
      await tester.scrollUntilVisible(
        paymentField,
        1200,
        scrollable: scrollable,
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(paymentField);
      await tester.pumpAndSettle();
      await tester.enterText(
        paymentField,
        '50% na reserva e 50% no dia do evento',
      );

      await tapCompanyProfileSave(tester);
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('settings_scroll')), findsOneWidget);
      expect(find.text('Dados da empresa salvos com sucesso'), findsOneWidget);
      expect(find.text('Informe o tipo e a chave PIX'), findsNothing);
    });

    testWidgets(
      'salvar perfil mínimo retorna com feedback e status incompleto',
      (tester) async {
        await pumpApp(tester);
        AppRouter.router.go(AppRoutes.settingsCompany);
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('company_trade_name_field')),
          'DJ Marcelo PP',
        );
        await tester.enterText(
          find.byKey(const Key('company_phone_field')),
          '67999998888',
        );

        await tapCompanyProfileSave(tester);
        await tester.pump();
        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('settings_scroll')), findsOneWidget);
        expect(
          find.text('Dados da empresa salvos com sucesso'),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('settings_status_badge_incomplete')),
          findsOneWidget,
        );
        expect(find.textContaining('Falta configurar:'), findsOneWidget);
      },
    );

    testWidgets('perfil completo exibe status configurado', (tester) async {
      await pumpApp(tester);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(EventProApp)),
      );
      await container
          .read(companyProfileProvider.notifier)
          .save(
            CompanyProfile(
              tradeName: 'DJ Marcelo PP',
              legalName: 'Marcelo PP Festas LTDA',
              cnpjDigits: '11222333000181',
              phoneDigits: '67999998888',
              address: const CompanyAddress(
                postalCode: '79002010',
                street: 'Rua Example',
                number: '100',
                city: 'Campo Grande',
                state: 'MS',
              ),
              legalRepresentative: const LegalRepresentative(
                fullName: 'Marcelo PP',
                cpfDigits: '52998224725',
              ),
              createdAt: DateTime(2026, 7, 13),
              updatedAt: DateTime(2026, 7, 13),
            ),
          );

      AppRouter.router.go(AppRoutes.settings);
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('settings_status_badge_configured')),
        findsOneWidget,
      );
      expect(find.text('DJ Marcelo PP'), findsWidgets);
    });
  });
}
