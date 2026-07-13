import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/widgets/quote_company_profile_banner.dart';

import '../quotes_test_helpers.dart';

void main() {
  group('QuoteCompanyProfileBanner', () {
    testWidgets('perfil ausente exibe orientação', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuoteCompanyProfileBanner(
              profile: null,
              onConfigureCompany: () {},
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('quote_company_profile_banner')), findsOneWidget);
      expect(
        find.text(
          'Configure os dados da empresa para emitir documentos profissionais.',
        ),
        findsOneWidget,
      );
      expect(find.byKey(const Key('quote_configure_company_button')), findsOneWidget);
    });

    testWidgets('perfil incompleto exibe pendências', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuoteCompanyProfileBanner(
              profile: sampleIncompleteCompanyProfile(),
              onConfigureCompany: () {},
            ),
          ),
        ),
      );

      expect(find.text('Dados profissionais incompletos:'), findsOneWidget);
      expect(find.textContaining('Razão social'), findsOneWidget);
      expect(find.textContaining('CNPJ'), findsOneWidget);
    });

    testWidgets('perfil configurado não exibe banner', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuoteCompanyProfileBanner(
              profile: sampleConfiguredCompanyProfile(),
              onConfigureCompany: () {},
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('quote_company_profile_banner')), findsNothing);
    });
  });
}
