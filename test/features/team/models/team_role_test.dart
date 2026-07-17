import 'package:eventpro/features/team/models/team_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TeamRole', () {
    TeamRole buildRole({
      String id = 'role-1',
      String name = 'DJ',
      String? description = 'Operação de som',
      bool active = true,
    }) {
      return TeamRole(
        id: id,
        name: name,
        description: description,
        active: active,
      );
    }

    test('description defaults to null and active to true', () {
      const role = TeamRole(id: 'role-1', name: 'DJ');

      expect(role.description, isNull);
      expect(role.active, isTrue);
    });

    test('equality compares all fields', () {
      final a = buildRole();
      final b = buildRole();
      final different = buildRole(name: 'Sonoplasta');

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(equals(different)));
    });

    test('copyWith preserves original values when no override is given', () {
      final original = buildRole();
      final copy = original.copyWith();

      expect(copy, equals(original));
      expect(identical(copy, original), isFalse);
    });

    test('copyWith overrides selected fields and can clear description', () {
      final original = buildRole();
      final copy = original.copyWith(
        name: 'Iluminador',
        active: false,
        clearDescription: true,
      );

      expect(copy.id, original.id);
      expect(copy.name, 'Iluminador');
      expect(copy.active, isFalse);
      expect(copy.description, isNull);
    });
  });
}
