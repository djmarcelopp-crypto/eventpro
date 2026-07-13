import 'package:flutter_test/flutter_test.dart';

import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/utils/quote_form_initializer.dart';
import '../quotes_test_helpers.dart';

void main() {
  group('QuoteFormInitializer', () {
    test('fromQuote pré-preenche campos e linhas existentes', () {
      final quote = sampleQuoteDraft(
        id: 'quote-1',
        status: QuoteStatus.draft,
        items: [
          sampleLineItem(
            catalogItemId: 'item-1',
            name: 'Caixa congelada',
            unit: 'Pacote',
            quantity: 2,
            unitPriceCents: 150_000,
          ),
        ],
      ).copyWith(
        notes: 'Observação pública',
        internalNotes: 'Nota interna',
        validUntil: DateTime(2026, 8, 1),
        eventSnapshot: const QuoteEventSnapshot(
          name: 'Casamento',
          guestCount: 120,
        ),
      );

      final values = QuoteFormInitializer.fromQuote(quote);

      expect(values.selectedClientId, isNotNull);
      expect(values.lines, hasLength(1));
      expect(values.lines.single.isExistingLine, isTrue);
      expect(values.lines.single.name, 'Caixa congelada');
      expect(values.lines.single.unit, 'Pacote');
      expect(values.lines.single.quantityText, '2');
      expect(values.discountText, isEmpty);
      expect(values.notes, 'Observação pública');
      expect(values.internalNotes, 'Nota interna');
      expect(values.validUntil, DateTime(2026, 8, 1));
      expect(values.eventName, 'Casamento');
      expect(values.guestCountText, '120');
    });
  });
}
