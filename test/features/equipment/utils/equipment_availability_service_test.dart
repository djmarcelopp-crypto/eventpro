import 'package:eventpro/features/equipment/models/equipment.dart';
import 'package:eventpro/features/equipment/models/equipment_availability.dart';
import 'package:eventpro/features/equipment/models/equipment_status.dart';
import 'package:eventpro/features/equipment/models/quote_equipment.dart';
import 'package:eventpro/features/equipment/utils/equipment_availability_service.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_equipment_repository.dart';
import '../fakes/fake_quote_equipment_repository.dart';
import '../../quotes/fakes/fake_quote_repository.dart';

void main() {
  final now = DateTime(2026, 1, 1);

  Equipment buildEquipment() {
    return Equipment(
      id: 'eq-1',
      name: 'Caixa',
      categoryId: 'cat',
      totalQuantity: 10,
      status: EquipmentStatus.available,
      createdAt: now,
      updatedAt: now,
    );
  }

  Quote buildQuote() {
    return Quote(
      id: 'quote-1',
      number: 'ORC-001',
      status: QuoteStatus.sent,
      clientSnapshot: const QuoteClientSnapshot(
        sourceClientId: 'c1',
        type: QuoteClientType.individual,
        displayName: 'Cliente',
        phone: '67999990000',
      ),
      eventSnapshot: QuoteEventSnapshot(
        name: 'Festa',
        date: DateTime(2026, 9, 10),
      ),
      items: const [],
      subtotalCents: 0,
      discountCents: 0,
      freightCents: 0,
      totalCents: 0,
      statusHistory: [
        QuoteStatusHistoryEntry(
          previousStatus: null,
          newStatus: QuoteStatus.sent,
          changedAt: now,
        ),
      ],
      createdAt: now,
      updatedAt: now,
    );
  }

  test('service lists availability from repositories', () async {
    final service = EquipmentAvailabilityService(
      equipmentRepository: FakeEquipmentRepository(
        initialEquipment: [buildEquipment()],
      ),
      quoteEquipmentRepository: FakeQuoteEquipmentRepository(
        initialItems: [
          QuoteEquipment(
            id: 'qe-1',
            quoteId: 'quote-1',
            equipmentId: 'eq-1',
            quantity: 4,
            createdAt: now,
            updatedAt: now,
          ),
        ],
      ),
      quoteRepository: FakeQuoteRepository(initialQuotes: [buildQuote()]),
    );

    final items = await service.listAll();
    expect(items, hasLength(1));
    expect(items.single.level, EquipmentAvailabilityLevel.partiallyAvailable);
    expect(items.single.reservedQuantity, 4);

    final one = await service.forEquipment('eq-1');
    expect(one?.availableQuantity, 6);

    final summary = await service.summary();
    expect(summary.partiallyAvailableCount, 1);
    expect(summary.fullyAvailableCount, 0);
  });

  test('service returns null for unknown equipment', () async {
    final service = EquipmentAvailabilityService(
      equipmentRepository: FakeEquipmentRepository(),
      quoteEquipmentRepository: FakeQuoteEquipmentRepository(),
      quoteRepository: FakeQuoteRepository(),
    );
    expect(await service.forEquipment('missing'), isNull);
  });
}
