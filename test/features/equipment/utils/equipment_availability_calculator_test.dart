import 'package:eventpro/features/equipment/models/equipment.dart';
import 'package:eventpro/features/equipment/models/equipment_availability.dart';
import 'package:eventpro/features/equipment/models/equipment_status.dart';
import 'package:eventpro/features/equipment/models/quote_equipment.dart';
import 'package:eventpro/features/equipment/utils/equipment_availability_calculator.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 1, 1);

  Equipment equipment({
    String id = 'eq-1',
    int totalQuantity = 10,
    EquipmentStatus status = EquipmentStatus.available,
  }) {
    return Equipment(
      id: id,
      name: 'Caixa',
      categoryId: 'cat',
      totalQuantity: totalQuantity,
      status: status,
      createdAt: now,
      updatedAt: now,
    );
  }

  Quote quote({
    required String id,
    required DateTime eventDate,
    QuoteStatus status = QuoteStatus.approved,
    String? startTime,
    String? endTime,
  }) {
    return Quote(
      id: id,
      number: 'ORC-$id',
      status: status,
      clientSnapshot: const QuoteClientSnapshot(
        sourceClientId: 'c1',
        type: QuoteClientType.individual,
        displayName: 'Cliente',
        phone: '67999990000',
      ),
      eventSnapshot: QuoteEventSnapshot(
        name: 'Evento $id',
        date: eventDate,
        startTime: startTime,
        endTime: endTime,
      ),
      items: const [],
      subtotalCents: 0,
      discountCents: 0,
      freightCents: 0,
      totalCents: 0,
      statusHistory: [
        QuoteStatusHistoryEntry(
          previousStatus: null,
          newStatus: status,
          changedAt: now,
        ),
      ],
      createdAt: now,
      updatedAt: now,
    );
  }

  QuoteEquipment line({
    required String id,
    required String quoteId,
    required String equipmentId,
    required int quantity,
  }) {
    return QuoteEquipment(
      id: id,
      quoteId: quoteId,
      equipmentId: equipmentId,
      quantity: quantity,
      createdAt: now,
      updatedAt: now,
    );
  }

  group('EquipmentAvailabilityCalculator', () {
    test('equipment is fully available when no quotes consume it', () {
      final result = EquipmentAvailabilityCalculator.calculateForEquipment(
        equipment: equipment(),
        quoteEquipment: const [],
        quotesById: const {},
      );

      expect(result.level, EquipmentAvailabilityLevel.fullyAvailable);
      expect(result.totalQuantity, 10);
      expect(result.reservedQuantity, 0);
      expect(result.availableQuantity, 10);
      expect(result.consumingQuotes, isEmpty);
      expect(result.conflicts, isEmpty);
    });

    test('equipment is partially available when demand is below stock', () {
      final q1 = quote(id: 'q1', eventDate: DateTime(2026, 8, 1));
      final result = EquipmentAvailabilityCalculator.calculateForEquipment(
        equipment: equipment(totalQuantity: 10),
        quoteEquipment: [
          line(id: 'l1', quoteId: 'q1', equipmentId: 'eq-1', quantity: 4),
        ],
        quotesById: {'q1': q1},
      );

      expect(result.level, EquipmentAvailabilityLevel.partiallyAvailable);
      expect(result.reservedQuantity, 4);
      expect(result.availableQuantity, 6);
      expect(result.consumingQuotes, hasLength(1));
      expect(result.conflicts, isEmpty);
    });

    test('equipment is unavailable when peak demand covers stock', () {
      final q1 = quote(id: 'q1', eventDate: DateTime(2026, 8, 1));
      final result = EquipmentAvailabilityCalculator.calculateForEquipment(
        equipment: equipment(totalQuantity: 5),
        quoteEquipment: [
          line(id: 'l1', quoteId: 'q1', equipmentId: 'eq-1', quantity: 5),
        ],
        quotesById: {'q1': q1},
      );

      expect(result.level, EquipmentAvailabilityLevel.unavailable);
      expect(result.reservedQuantity, 5);
      expect(result.availableQuantity, 0);
    });

    test('non-overlapping periods do not stack reserved quantity', () {
      final q1 = quote(id: 'q1', eventDate: DateTime(2026, 8, 1));
      final q2 = quote(id: 'q2', eventDate: DateTime(2026, 8, 2));
      final result = EquipmentAvailabilityCalculator.calculateForEquipment(
        equipment: equipment(totalQuantity: 5),
        quoteEquipment: [
          line(id: 'l1', quoteId: 'q1', equipmentId: 'eq-1', quantity: 5),
          line(id: 'l2', quoteId: 'q2', equipmentId: 'eq-1', quantity: 5),
        ],
        quotesById: {'q1': q1, 'q2': q2},
      );

      expect(result.level, EquipmentAvailabilityLevel.unavailable);
      expect(result.reservedQuantity, 5);
      expect(result.availableQuantity, 0);
      expect(result.consumingQuotes, hasLength(2));
      expect(result.conflicts, isEmpty);
    });

    test('overlapping periods stack and can create conflicts', () {
      final q1 = quote(id: 'q1', eventDate: DateTime(2026, 8, 1));
      final q2 = quote(id: 'q2', eventDate: DateTime(2026, 8, 1));
      final result = EquipmentAvailabilityCalculator.calculateForEquipment(
        equipment: equipment(totalQuantity: 5),
        quoteEquipment: [
          line(id: 'l1', quoteId: 'q1', equipmentId: 'eq-1', quantity: 4),
          line(id: 'l2', quoteId: 'q2', equipmentId: 'eq-1', quantity: 3),
        ],
        quotesById: {'q1': q1, 'q2': q2},
      );

      expect(result.reservedQuantity, 7);
      expect(result.availableQuantity, 0);
      expect(result.level, EquipmentAvailabilityLevel.unavailable);
      expect(result.conflicts, hasLength(2));
      expect(
        result.conflicts.map((c) => c.quoteId).toSet(),
        {'q1', 'q2'},
      );
      final conflictQ2 = result.conflicts.firstWhere((c) => c.quoteId == 'q2');
      expect(conflictQ2.requestedQuantity, 3);
      expect(conflictQ2.availableQuantity, 1); // 5 - 4 from q1
      expect(conflictQ2.equipmentId, 'eq-1');
    });

    test('cancelled and rejected quotes do not consume availability', () {
      final approved = quote(id: 'q1', eventDate: DateTime(2026, 8, 1));
      final cancelled = quote(
        id: 'q2',
        eventDate: DateTime(2026, 8, 1),
        status: QuoteStatus.cancelled,
      );
      final rejected = quote(
        id: 'q3',
        eventDate: DateTime(2026, 8, 1),
        status: QuoteStatus.rejected,
      );
      final result = EquipmentAvailabilityCalculator.calculateForEquipment(
        equipment: equipment(totalQuantity: 5),
        quoteEquipment: [
          line(id: 'l1', quoteId: 'q1', equipmentId: 'eq-1', quantity: 2),
          line(id: 'l2', quoteId: 'q2', equipmentId: 'eq-1', quantity: 5),
          line(id: 'l3', quoteId: 'q3', equipmentId: 'eq-1', quantity: 5),
        ],
        quotesById: {
          'q1': approved,
          'q2': cancelled,
          'q3': rejected,
        },
      );

      expect(result.reservedQuantity, 2);
      expect(result.level, EquipmentAvailabilityLevel.partiallyAvailable);
      expect(result.consumingQuotes.map((c) => c.quoteId), ['q1']);
    });

    test('quotes without event date do not consume availability', () {
      final withoutDate = Quote(
        id: 'q1',
        number: 'ORC-q1',
        status: QuoteStatus.approved,
        clientSnapshot: const QuoteClientSnapshot(
          sourceClientId: 'c1',
          type: QuoteClientType.individual,
          displayName: 'Cliente',
          phone: '67999990000',
        ),
        eventSnapshot: const QuoteEventSnapshot(name: 'Sem data'),
        items: const [],
        subtotalCents: 0,
        discountCents: 0,
        freightCents: 0,
        totalCents: 0,
        statusHistory: [
          QuoteStatusHistoryEntry(
            previousStatus: null,
            newStatus: QuoteStatus.approved,
            changedAt: now,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      );

      final result = EquipmentAvailabilityCalculator.calculateForEquipment(
        equipment: equipment(),
        quoteEquipment: [
          line(id: 'l1', quoteId: 'q1', equipmentId: 'eq-1', quantity: 9),
        ],
        quotesById: {'q1': withoutDate},
      );

      expect(result.level, EquipmentAvailabilityLevel.fullyAvailable);
      expect(result.reservedQuantity, 0);
    });

    test('EquipmentStatus does not affect availability calculation', () {
      final q1 = quote(id: 'q1', eventDate: DateTime(2026, 8, 1));
      final result = EquipmentAvailabilityCalculator.calculateForEquipment(
        equipment: equipment(
          totalQuantity: 10,
          status: EquipmentStatus.maintenance,
        ),
        quoteEquipment: [
          line(id: 'l1', quoteId: 'q1', equipmentId: 'eq-1', quantity: 3),
        ],
        quotesById: {'q1': q1},
      );

      expect(result.reservedQuantity, 3);
      expect(result.availableQuantity, 7);
      expect(result.level, EquipmentAvailabilityLevel.partiallyAvailable);
    });

    test('summary aggregates availability levels', () {
      final items = EquipmentAvailabilityCalculator.calculateAll(
        equipment: [
          equipment(id: 'eq-free', totalQuantity: 2),
          equipment(id: 'eq-partial', totalQuantity: 10),
          equipment(id: 'eq-full', totalQuantity: 3),
        ],
        quoteEquipment: [
          line(
            id: 'l1',
            quoteId: 'q1',
            equipmentId: 'eq-partial',
            quantity: 4,
          ),
          line(id: 'l2', quoteId: 'q1', equipmentId: 'eq-full', quantity: 3),
        ],
        quotes: [quote(id: 'q1', eventDate: DateTime(2026, 8, 1))],
      );

      final summary = EquipmentAvailabilityCalculator.summarize(items);
      expect(summary.fullyAvailableCount, 1);
      expect(summary.partiallyAvailableCount, 1);
      expect(summary.unavailableCount, 1);
      expect(summary.totalEquipmentCount, 3);
    });

    test('touching periods do not overlap', () {
      final q1 = quote(
        id: 'q1',
        eventDate: DateTime(2026, 8, 1),
        startTime: '10:00',
        endTime: '12:00',
      );
      final q2 = quote(
        id: 'q2',
        eventDate: DateTime(2026, 8, 1),
        startTime: '12:00',
        endTime: '14:00',
      );
      final result = EquipmentAvailabilityCalculator.calculateForEquipment(
        equipment: equipment(totalQuantity: 5),
        quoteEquipment: [
          line(id: 'l1', quoteId: 'q1', equipmentId: 'eq-1', quantity: 5),
          line(id: 'l2', quoteId: 'q2', equipmentId: 'eq-1', quantity: 5),
        ],
        quotesById: {'q1': q1, 'q2': q2},
      );

      expect(result.reservedQuantity, 5);
      expect(result.conflicts, isEmpty);
    });
  });
}
