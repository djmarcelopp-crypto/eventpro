import 'package:eventpro/features/team/models/team_role.dart';
import 'package:eventpro/features/team/utils/team_role_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TeamRoleValidator', () {
    test('accepts a valid role draft', () {
      final result = TeamRoleValidator.validateFields(name: 'DJ');

      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('rejects missing name', () {
      expect(
        TeamRoleValidator.validateFields(name: '  ').errors,
        contains(TeamRoleValidator.nameRequiredError),
      );
      expect(
        TeamRoleValidator.validateFields(name: null).errors,
        contains(TeamRoleValidator.nameRequiredError),
      );
    });

    test('validate delegates to fields of the entity', () {
      final result = TeamRoleValidator.validate(
        const TeamRole(id: 'role-1', name: ''),
      );

      expect(result.isValid, isFalse);
      expect(result.errors, contains(TeamRoleValidator.nameRequiredError));
    });
  });
}
