import 'package:eventpro/features/contracts/models/contract_template.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContractTemplate', () {
    final createdAt = DateTime(2026, 7, 17, 10);
    final updatedAt = DateTime(2026, 7, 17, 10);

    ContractTemplate buildTemplate({
      String id = 'tpl-1',
      String name = 'Padrão',
      String? description = 'Modelo básico',
      bool active = true,
    }) {
      return ContractTemplate(
        id: id,
        name: name,
        description: description,
        active: active,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    }

    test('description defaults to null and active to true', () {
      final template = ContractTemplate(
        id: 'tpl-1',
        name: 'Padrão',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(template.description, isNull);
      expect(template.active, isTrue);
    });

    test('equality compares all fields', () {
      final a = buildTemplate();
      final b = buildTemplate();
      final different = buildTemplate(name: 'Premium');

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(equals(different)));
    });

    test('copyWith preserves original values when no override is given', () {
      final original = buildTemplate();
      final copy = original.copyWith();

      expect(copy, equals(original));
      expect(identical(copy, original), isFalse);
    });

    test('copyWith overrides selected fields and can clear description', () {
      final original = buildTemplate();
      final copy = original.copyWith(
        name: 'Premium',
        active: false,
        clearDescription: true,
      );

      expect(copy.id, original.id);
      expect(copy.name, 'Premium');
      expect(copy.active, isFalse);
      expect(copy.description, isNull);
      expect(copy.createdAt, original.createdAt);
    });
  });
}
