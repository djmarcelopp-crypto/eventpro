import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';

void main() {
  group('QuoteEventSnapshot', () {
    test('empty possui campos opcionais nulos', () {
      const snapshot = QuoteEventSnapshot.empty;

      expect(snapshot.name, isNull);
      expect(snapshot.type, isNull);
      expect(snapshot.date, isNull);
      expect(snapshot.guestCount, isNull);
    });

    test('aceita dados essenciais do evento', () {
      const snapshot = QuoteEventSnapshot(
        name: 'Casamento Ana e João',
        type: 'Casamento',
        guestCount: 200,
        venueName: 'Espaço Garden',
      );

      expect(snapshot.name, 'Casamento Ana e João');
      expect(snapshot.guestCount, 200);
      expect(snapshot.venueName, 'Espaço Garden');
    });
  });
}
