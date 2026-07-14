import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_eligibility.dart';

import '../quotes_test_helpers.dart';

void main() {
  group('QuotePdfEligibility', () {
    test('permite orçamento com companySnapshot', () {
      final quote = sampleQuoteDraft(
        companySnapshot: sampleCompanySnapshot(),
      );

      expect(
        QuotePdfEligibility.evaluate(quote),
        isA<QuotePdfEligibilityAllowed>(),
      );
    });

    test('bloqueia orçamento legado sem companySnapshot', () {
      final quote = sampleQuoteDraft(companySnapshot: null);

      final result = QuotePdfEligibility.evaluate(quote);

      expect(result, isA<QuotePdfEligibilityBlocked>());
      expect(
        (result as QuotePdfEligibilityBlocked).message,
        QuotePdfEligibility.missingCompanySnapshotMessage,
      );
    });
  });
}
