import 'package:eventpro/features/team/models/team_member.dart';
import 'package:eventpro/features/team/models/team_member_status.dart';
import 'package:eventpro/features/team/utils/team_member_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TeamMemberValidator', () {
    final now = DateTime(2026, 7, 1);

    test('accepts a valid member draft', () {
      final result = TeamMemberValidator.validateFields(
        name: 'Ana Silva',
        roleId: 'role-dj',
        dailyRate: 0,
        status: TeamMemberStatus.active,
      );

      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('rejects missing name', () {
      final result = TeamMemberValidator.validateFields(
        name: '  ',
        roleId: 'role-dj',
        dailyRate: 1000,
        status: TeamMemberStatus.active,
      );

      expect(result.errors, contains(TeamMemberValidator.nameRequiredError));
    });

    test('rejects missing role', () {
      final result = TeamMemberValidator.validateFields(
        name: 'Ana',
        roleId: null,
        dailyRate: 1000,
        status: TeamMemberStatus.active,
      );

      expect(result.errors, contains(TeamMemberValidator.roleRequiredError));
    });

    test('rejects negative daily rate', () {
      final result = TeamMemberValidator.validateFields(
        name: 'Ana',
        roleId: 'role-dj',
        dailyRate: -1,
        status: TeamMemberStatus.active,
      );

      expect(
        result.errors,
        contains(TeamMemberValidator.dailyRateNonNegativeError),
      );
    });

    test('accepts zero daily rate', () {
      final result = TeamMemberValidator.validateFields(
        name: 'Ana',
        roleId: 'role-dj',
        dailyRate: 0,
        status: TeamMemberStatus.active,
      );

      expect(result.isValid, isTrue);
    });

    test('rejects missing status', () {
      final result = TeamMemberValidator.validateFields(
        name: 'Ana',
        roleId: 'role-dj',
        dailyRate: 1000,
        status: null,
      );

      expect(result.errors, contains(TeamMemberValidator.statusRequiredError));
    });

    test('rejects invalid status name', () {
      final result = TeamMemberValidator.validateFields(
        name: 'Ana',
        roleId: 'role-dj',
        dailyRate: 1000,
        statusName: 'not-a-status',
      );

      expect(result.errors, contains(TeamMemberValidator.statusInvalidError));
    });

    test('accepts a known status name when enum status is omitted', () {
      final result = TeamMemberValidator.validateFields(
        name: 'Ana',
        roleId: 'role-dj',
        dailyRate: 1000,
        statusName: TeamMemberStatus.active.name,
      );

      expect(result.isValid, isTrue);
    });

    test('validate delegates to fields of the entity', () {
      final result = TeamMemberValidator.validate(
        TeamMember(
          id: 'm1',
          name: '',
          phone: '67999990000',
          roleId: '',
          dailyRate: -10,
          status: TeamMemberStatus.active,
          createdAt: now,
          updatedAt: now,
        ),
      );

      expect(result.isValid, isFalse);
      expect(result.errors, contains(TeamMemberValidator.nameRequiredError));
      expect(result.errors, contains(TeamMemberValidator.roleRequiredError));
      expect(
        result.errors,
        contains(TeamMemberValidator.dailyRateNonNegativeError),
      );
    });
  });
}
