import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';

void main() {
  group('QuoteClientType', () {
    test('labels em português', () {
      expect(QuoteClientType.individual.label, 'Pessoa Física');
      expect(QuoteClientType.company.label, 'Pessoa Jurídica');
    });
  });
}
