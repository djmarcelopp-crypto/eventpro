import 'package:eventpro/features/equipment/providers/quote_equipment_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../equipment_test_helpers.dart';
import '../fakes/equipment_repository_test_overrides.dart';
import '../fakes/fake_equipment_category_repository.dart';
import '../fakes/fake_equipment_repository.dart';
import '../fakes/fake_quote_equipment_repository.dart';
import '../../quotes/fakes/fake_quote_repository.dart';

void main() {
  group('QuoteEquipmentNotifier', () {
    late ProviderContainer container;
    final fixedNow = DateTime(2030, 1, 1, 12);
    const quoteId = 'quote-1';

    setUp(() async {
      container = ProviderContainer(
        overrides: equipmentRepositoryOverrides(
          equipmentRepository: FakeEquipmentRepository(
            initialEquipment: [buildTestEquipment()],
          ),
          categoryRepository: FakeEquipmentCategoryRepository(
            initialCategories: [buildTestCategory()],
          ),
          quoteEquipmentRepository: FakeQuoteEquipmentRepository(),
          quoteRepository: FakeQuoteRepository(
            initialQuotes: [buildTestQuote()],
          ),
          clock: () => fixedNow,
        ),
      );
      await container.read(quoteEquipmentProvider(quoteId).future);
    });

    tearDown(() => container.dispose());

    test('add update remove quote equipment and summary', () async {
      final added = await container
          .read(quoteEquipmentProvider(quoteId).notifier)
          .add(equipmentId: 'eq-1', quantity: 2);
      expect(added.isSuccess, isTrue);
      expect(
        container.read(quoteEquipmentProvider(quoteId)).value,
        hasLength(1),
      );
      expect(
        container.read(quoteEquipmentSummaryProvider(quoteId)).value!.lineCount,
        1,
      );
      expect(
        container
            .read(quoteEquipmentSummaryProvider(quoteId))
            .value!
            .totalQuantity,
        2,
      );

      final item = added.item!;
      final updated = await container
          .read(quoteEquipmentProvider(quoteId).notifier)
          .updateQuantity(id: item.id, quantity: 5);
      expect(updated.isSuccess, isTrue);
      expect(
        container.read(quoteEquipmentProvider(quoteId)).value!.first.quantity,
        5,
      );

      final removed = await container
          .read(quoteEquipmentProvider(quoteId).notifier)
          .remove(item.id);
      expect(removed.isDeleted, isTrue);
      expect(container.read(quoteEquipmentProvider(quoteId)).value, isEmpty);
    });

    test('rejects invalid quantity without mutating state', () async {
      final result = await container
          .read(quoteEquipmentProvider(quoteId).notifier)
          .add(equipmentId: 'eq-1', quantity: 0);
      expect(result.isSuccess, isFalse);
      expect(container.read(quoteEquipmentProvider(quoteId)).value, isEmpty);
    });
  });
}
