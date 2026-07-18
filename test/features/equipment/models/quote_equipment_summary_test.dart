import 'package:eventpro/features/equipment/models/quote_equipment.dart';
import 'package:eventpro/features/equipment/models/quote_equipment_summary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuoteEquipmentSummary', () {
    final stamp = DateTime(2026, 7, 1);

    test('aggregates lineCount and totalQuantity', () {
      final summary = QuoteEquipmentSummary(
        quoteId: 'quote-1',
        items: [
          QuoteEquipment(
            id: 'a',
            quoteId: 'quote-1',
            equipmentId: 'eq-1',
            quantity: 2,
            createdAt: stamp,
            updatedAt: stamp,
          ),
          QuoteEquipment(
            id: 'b',
            quoteId: 'quote-1',
            equipmentId: 'eq-2',
            quantity: 5,
            createdAt: stamp,
            updatedAt: stamp,
          ),
        ],
      );

      expect(summary.lineCount, 2);
      expect(summary.totalQuantity, 7);
      expect(summary.hasItems, isTrue);
      expect(summary.items, hasLength(2));
    });

    test('empty summary', () {
      final summary = QuoteEquipmentSummary(quoteId: 'q', items: const []);
      expect(summary.lineCount, 0);
      expect(summary.totalQuantity, 0);
      expect(summary.hasItems, isFalse);
    });
  });
}
