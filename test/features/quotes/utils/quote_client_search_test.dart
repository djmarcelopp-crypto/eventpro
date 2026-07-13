import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/client_type.dart';
import 'package:eventpro/features/quotes/utils/quote_client_search.dart';
import '../quotes_test_helpers.dart';

void main() {
  final client = sampleClient(
    name: 'Maria Silva',
    tradeName: 'Festas Maria',
    type: ClientType.individual,
  );

  final company = sampleClient(
    id: 'client-2',
    name: 'Empresa LTDA',
    tradeName: 'Marca Festa',
    type: ClientType.company,
    document: '11222333000181',
  );

  group('QuoteClientSearch', () {
    test('busca por nome e nome fantasia', () {
      expect(QuoteClientSearch.matches(client, 'maria'), isTrue);
      expect(QuoteClientSearch.matches(company, 'marca festa'), isTrue);
    });

    test('busca por documento e contato', () {
      expect(QuoteClientSearch.matches(company, '11222333000181'), isTrue);
      expect(QuoteClientSearch.matches(client, '99999'), isTrue);
      expect(QuoteClientSearch.matches(client, 'maria@example.com'), isTrue);
    });
  });
}
