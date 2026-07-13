import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/client_type.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import '../quotes_test_helpers.dart';

void main() {
  group('QuoteClientSnapshot', () {
    test('fromClient congela dados essenciais sem internalNotes', () {
      final snapshot = QuoteClientSnapshot.fromClient(
        sampleClient(internalNotes: 'Segredo interno'),
      );

      expect(snapshot.sourceClientId, 'client-1');
      expect(snapshot.type, QuoteClientType.individual);
      expect(snapshot.displayName, 'Maria Silva');
      expect(snapshot.legalName, isNull);
      expect(snapshot.document, '52998224725');
      expect(snapshot.addressSummary, contains('Rua das Flores'));
    });

    test('fromClient PJ usa nome fantasia como displayName', () {
      final snapshot = QuoteClientSnapshot.fromClient(
        sampleClient(
          type: ClientType.company,
          name: 'Empresa LTDA',
          tradeName: 'Festas Top',
        ),
      );

      expect(snapshot.type, QuoteClientType.company);
      expect(snapshot.displayName, 'Festas Top');
      expect(snapshot.legalName, 'Empresa LTDA');
    });
  });
}
