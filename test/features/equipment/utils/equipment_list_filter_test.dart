import 'package:eventpro/features/equipment/models/equipment_status.dart';
import 'package:eventpro/features/equipment/utils/equipment_list_filter.dart';
import 'package:eventpro/features/equipment/models/equipment_filters.dart';
import 'package:flutter_test/flutter_test.dart';

import '../equipment_test_helpers.dart';

void main() {
  group('EquipmentListFilter', () {
    final items = [
      buildTestEquipment(id: '1', name: 'Caixa Ativa'),
      buildTestEquipment(
        id: '2',
        name: 'Microfone',
        status: EquipmentStatus.reserved,
      ),
      buildTestEquipment(id: '3', name: 'Caixa Passiva', categoryId: 'other'),
    ];

    test('filters by name, category and status', () {
      final byName = EquipmentListFilter.apply(
        items,
        const EquipmentFilters(nameQuery: 'caixa'),
      );
      expect(byName.map((e) => e.id), ['1', '3']);

      final byCategory = EquipmentListFilter.apply(
        items,
        const EquipmentFilters(categoryId: 'cat-sound'),
      );
      expect(byCategory.map((e) => e.id), ['1', '2']);

      final byStatus = EquipmentListFilter.apply(
        items,
        const EquipmentFilters(status: EquipmentStatus.reserved),
      );
      expect(byStatus.map((e) => e.id), ['2']);
    });
  });
}
