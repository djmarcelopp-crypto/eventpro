import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/settings/models/company_profile.dart';
import 'package:eventpro/features/settings/models/company_quote_defaults.dart';

void main() {
  group('CompanyProfile', () {
    final fixedNow = DateTime(2026, 7, 13, 10, 0);

    CompanyProfile sampleProfile() {
      return CompanyProfile(
        tradeName: 'DJ Marcelo PP',
        createdAt: fixedNow,
        updatedAt: fixedNow,
      );
    }

    test('copyWith preserva campos e limpa logoReference', () {
      final profile = sampleProfile().copyWith(
        logoReference: 'settings/logo/test.jpg',
      );

      final cleared = profile.copyWith(clearLogoReference: true);

      expect(cleared.logoReference, isNull);
      expect(cleared.tradeName, 'DJ Marcelo PP');
      expect(cleared.createdAt, fixedNow);
    });

    test('quoteDefaults inicia com validade padrão de 7 dias', () {
      const defaults = CompanyQuoteDefaults();
      expect(defaults.defaultValidityDays, 7);
    });
  });
}
