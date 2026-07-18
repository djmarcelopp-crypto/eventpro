import 'package:eventpro/features/demo/models/demo_seed_manifest.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DemoSeedManifest', () {
    test('isEmpty is true for default instance', () {
      expect(const DemoSeedManifest().isEmpty, isTrue);
    });

    test('round-trips through JSON', () {
      final now = DateTime(2026, 7, 17, 15, 30);
      final original = DemoSeedManifest(
        clientIds: const ['c1'],
        quoteIds: const ['q1', 'q2'],
        contractIds: const ['ct1'],
        invoiceIds: const ['i1'],
        teamRoleIds: const ['r1'],
        teamMemberIds: const ['m1'],
        equipmentCategoryIds: const ['ec1'],
        equipmentIds: const ['e1'],
        vehicleTypeIds: const ['vt1'],
        vehicleIds: const ['v1'],
        financialCategoryIds: const ['fc1'],
        financialEntryIds: const ['fe1'],
        agendaBlockIds: const ['a1'],
        seededAt: now,
      );

      final restored = DemoSeedManifest.fromJson(original.toJson());

      expect(restored.clientIds, original.clientIds);
      expect(restored.quoteIds, original.quoteIds);
      expect(restored.contractIds, original.contractIds);
      expect(restored.invoiceIds, original.invoiceIds);
      expect(restored.teamMemberIds, original.teamMemberIds);
      expect(restored.equipmentIds, original.equipmentIds);
      expect(restored.vehicleIds, original.vehicleIds);
      expect(restored.financialEntryIds, original.financialEntryIds);
      expect(restored.agendaBlockIds, original.agendaBlockIds);
      expect(restored.seededAt, now);
      expect(restored.isEmpty, isFalse);
    });

    test('partial JSON keeps known IDs and drops blanks', () {
      final restored = DemoSeedManifest.fromJson({
        'clientIds': ['real-looking', '', '  ', 42],
        'quoteIds': null,
        'invoiceIds': 'not-a-list',
      });

      expect(restored.clientIds, ['real-looking', '42']);
      expect(restored.quoteIds, isEmpty);
      expect(restored.invoiceIds, isEmpty);
      expect(restored.isEmpty, isFalse);
    });

    test('invalid seededAt does not throw', () {
      final restored = DemoSeedManifest.fromJson({
        'clientIds': ['c1'],
        'seededAt': 123,
      });
      expect(restored.clientIds, ['c1']);
      expect(restored.seededAt, isNull);
    });
  });
}
