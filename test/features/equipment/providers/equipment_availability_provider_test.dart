import 'package:eventpro/features/equipment/models/equipment.dart';
import 'package:eventpro/features/equipment/models/equipment_availability.dart';
import 'package:eventpro/features/equipment/models/equipment_status.dart';
import 'package:eventpro/features/equipment/models/quote_equipment.dart';
import 'package:eventpro/features/equipment/providers/equipment_availability_provider.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/equipment_repository_test_overrides.dart';
import '../fakes/fake_equipment_category_repository.dart';
import '../fakes/fake_equipment_repository.dart';
import '../fakes/fake_quote_equipment_repository.dart';
import '../../quotes/fakes/fake_quote_repository.dart';

void main() {
  final now = DateTime(2026, 1, 1);

  test('providers expose computed availability and summary', () async {
    final container = ProviderContainer(
      overrides: equipmentRepositoryOverrides(
        equipmentRepository: FakeEquipmentRepository(
          initialEquipment: [
            Equipment(
              id: 'eq-1',
              name: 'Caixa',
              categoryId: 'cat',
              totalQuantity: 8,
              status: EquipmentStatus.available,
              createdAt: now,
              updatedAt: now,
            ),
          ],
        ),
        categoryRepository: FakeEquipmentCategoryRepository(),
        quoteEquipmentRepository: FakeQuoteEquipmentRepository(
          initialItems: [
            QuoteEquipment(
              id: 'qe-1',
              quoteId: 'quote-1',
              equipmentId: 'eq-1',
              quantity: 8,
              createdAt: now,
              updatedAt: now,
            ),
          ],
        ),
        quoteRepository: FakeQuoteRepository(
          initialQuotes: [
            Quote(
              id: 'quote-1',
              number: 'ORC-001',
              status: QuoteStatus.draft,
              clientSnapshot: const QuoteClientSnapshot(
                sourceClientId: 'c1',
                type: QuoteClientType.individual,
                displayName: 'Cliente',
                phone: '67999990000',
              ),
              eventSnapshot: QuoteEventSnapshot(
                name: 'Evento',
                date: DateTime(2026, 10, 1),
              ),
              items: const [],
              subtotalCents: 0,
              discountCents: 0,
              freightCents: 0,
              totalCents: 0,
              statusHistory: [
                QuoteStatusHistoryEntry(
                  previousStatus: null,
                  newStatus: QuoteStatus.draft,
                  changedAt: now,
                ),
              ],
              createdAt: now,
              updatedAt: now,
            ),
          ],
        ),
      ),
    );
    addTearDown(container.dispose);

    final items = await container.read(equipmentAvailabilityProvider.future);
    expect(items, hasLength(1));
    expect(items.single.level, EquipmentAvailabilityLevel.unavailable);

    final summary = await container.read(
      equipmentAvailabilitySummaryProvider.future,
    );
    expect(summary.unavailableCount, 1);
    expect(summary.fullyAvailableCount, 0);
  });
}
