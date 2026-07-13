import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/utils/quote_date_formatter.dart';
import 'package:eventpro/features/quotes/utils/quote_form_defaults.dart';
import 'package:eventpro/features/settings/models/company_profile.dart';
import 'package:eventpro/features/settings/models/company_quote_defaults.dart';

import '../quotes_test_helpers.dart';

void main() {
  group('QuoteFormDefaults', () {
    final fixedClock = DateTime(2026, 7, 13, 15, 47, 33);

    test('sem perfil usa fallback de 7 dias na data local', () {
      final defaults = QuoteFormDefaults.fromCompanyProfile(
        null,
        clock: fixedClock,
      );

      expect(
        defaults.validUntil,
        QuoteDateFormatter.addDays(
          QuoteDateFormatter.dateOnly(fixedClock),
          7,
        ),
      );
      expect(defaults.validUntil.hour, 0);
      expect(defaults.validUntil.minute, 0);
      expect(defaults.publicNotes, isEmpty);
    });

    test('com perfil usa defaultValidityDays', () {
      final profile = CompanyProfile(
        tradeName: 'DJ Marcelo PP',
        quoteDefaults: const CompanyQuoteDefaults(defaultValidityDays: 14),
        createdAt: fixedClock,
        updatedAt: fixedClock,
      );

      final defaults = QuoteFormDefaults.fromCompanyProfile(
        profile,
        clock: fixedClock,
      );

      expect(
        defaults.validUntil,
        QuoteDateFormatter.addDays(
          QuoteDateFormatter.dateOnly(fixedClock),
          14,
        ),
      );
    });

    test('com perfil aplica defaultPublicNotes', () {
      final profile = CompanyProfile(
        tradeName: 'DJ Marcelo PP',
        quoteDefaults: const CompanyQuoteDefaults(
          defaultPublicNotes: '  Prazo de entrega conforme combinado. ',
        ),
        createdAt: fixedClock,
        updatedAt: fixedClock,
      );

      final defaults = QuoteFormDefaults.fromCompanyProfile(
        profile,
        clock: fixedClock,
      );

      expect(defaults.publicNotes, 'Prazo de entrega conforme combinado.');
    });

    test('relógio fixo produz validade determinística', () {
      final defaults = QuoteFormDefaults.fromCompanyProfile(
        sampleConfiguredCompanyProfile(timestamp: fixedClock).copyWith(
          quoteDefaults: const CompanyQuoteDefaults(defaultValidityDays: 21),
        ),
        clock: fixedClock,
      );

      expect(defaults.validUntil, DateTime(2026, 8, 3));
    });
  });
}
