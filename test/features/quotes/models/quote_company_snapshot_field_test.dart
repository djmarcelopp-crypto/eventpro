import 'package:flutter_test/flutter_test.dart';

import '../quotes_test_helpers.dart';

void main() {
  group('Quote companySnapshot', () {
    test('orçamento antigo permanece válido com snapshot null', () {
      final quote = sampleQuoteDraft();

      expect(quote.companySnapshot, isNull);
    });

    test('copyWith sem snapshot preserva o existente', () {
      final snapshot = sampleCompanySnapshot();
      final quote = sampleQuoteDraft().copyWith(companySnapshot: snapshot);

      final updated = quote.copyWith(notes: 'Nova nota');

      expect(updated.companySnapshot, snapshot);
      expect(updated.notes, 'Nova nota');
    });
  });
}
