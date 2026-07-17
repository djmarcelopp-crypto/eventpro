import 'package:eventpro/features/team/models/team_member.dart';
import 'package:eventpro/features/team/models/team_member_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TeamMember', () {
    final createdAt = DateTime(2026, 7, 1, 10);
    final updatedAt = DateTime(2026, 7, 1, 10);

    TeamMember buildMember({
      String id = 'member-1',
      String name = 'Ana Silva',
      String phone = '67999990000',
      String? email = 'ana@example.com',
      String roleId = 'role-dj',
      String observations = 'Prefere turnos noturnos',
      int dailyRate = 35000,
      TeamMemberStatus status = TeamMemberStatus.active,
    }) {
      return TeamMember(
        id: id,
        name: name,
        phone: phone,
        email: email,
        roleId: roleId,
        observations: observations,
        dailyRate: dailyRate,
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    }

    test('observations defaults to empty and email to null', () {
      final member = TeamMember(
        id: 'member-1',
        name: 'Ana Silva',
        phone: '67999990000',
        roleId: 'role-dj',
        dailyRate: 0,
        status: TeamMemberStatus.active,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(member.observations, '');
      expect(member.email, isNull);
    });

    test('status helpers reflect status', () {
      expect(buildMember().isActive, isTrue);
      expect(
        buildMember(status: TeamMemberStatus.unavailable).isUnavailable,
        isTrue,
      );
      expect(
        buildMember(status: TeamMemberStatus.inactive).isInactive,
        isTrue,
      );
    });

    test('equality compares all fields', () {
      final a = buildMember();
      final b = buildMember();
      final different = buildMember(name: 'Outro');

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(equals(different)));
    });

    test('copyWith preserves original values when no override is given', () {
      final original = buildMember();
      final copy = original.copyWith();

      expect(copy, equals(original));
      expect(identical(copy, original), isFalse);
    });

    test('copyWith overrides selected fields and can clear email', () {
      final original = buildMember();
      final copy = original.copyWith(
        name: 'Bruno',
        dailyRate: 40000,
        status: TeamMemberStatus.unavailable,
        clearEmail: true,
      );

      expect(copy.id, original.id);
      expect(copy.name, 'Bruno');
      expect(copy.dailyRate, 40000);
      expect(copy.status, TeamMemberStatus.unavailable);
      expect(copy.email, isNull);
      expect(copy.phone, original.phone);
      expect(copy.roleId, original.roleId);
    });
  });
}
