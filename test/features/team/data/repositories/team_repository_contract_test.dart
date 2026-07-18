import 'package:eventpro/features/team/data/repositories/team_member_repository.dart';
import 'package:eventpro/features/team/data/repositories/team_role_repository.dart';
import 'package:eventpro/features/team/models/team_member.dart';
import 'package:eventpro/features/team/models/team_member_status.dart';
import 'package:eventpro/features/team/models/team_role.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory stubs that prove the repository contracts are implementable
/// without Drift / providers / UI.
class _MemoryTeamMemberRepository implements TeamMemberRepository {
  final Map<String, TeamMember> _items = {};

  @override
  Future<void> delete(String id) async {
    _items.remove(id);
  }

  @override
  Future<TeamMember?> findById(String id) async => _items[id];

  @override
  Future<void> insert(TeamMember member) async {
    _items[member.id] = member;
  }

  @override
  Future<List<TeamMember>> listAll() async =>
      List.unmodifiable(_items.values.toList());

  @override
  Future<void> update(TeamMember member) async {
    _items[member.id] = member;
  }
}

class _MemoryTeamRoleRepository implements TeamRoleRepository {
  final Map<String, TeamRole> _items = {};

  @override
  Future<void> delete(String id) async {
    _items.remove(id);
  }

  @override
  Future<TeamRole?> findById(String id) async => _items[id];

  @override
  Future<void> insert(TeamRole role) async {
    _items[role.id] = role;
  }

  @override
  Future<List<TeamRole>> listAll() async =>
      List.unmodifiable(_items.values.toList());

  @override
  Future<void> update(TeamRole role) async {
    _items[role.id] = role;
  }
}

void main() {
  group('Team repository contracts', () {
    final now = DateTime(2026, 7, 1);

    test('TeamRoleRepository can be implemented in memory', () async {
      final repository = _MemoryTeamRoleRepository();
      final role = TeamRole(
        id: 'role-1',
        name: 'DJ',
        createdAt: now,
        updatedAt: now,
      );

      await repository.insert(role);
      expect(await repository.findById('role-1'), role);
      expect(await repository.listAll(), [role]);

      final updated = role.copyWith(name: 'DJ Principal');
      await repository.update(updated);
      expect(await repository.findById('role-1'), updated);

      await repository.delete('role-1');
      expect(await repository.findById('role-1'), isNull);
      expect(await repository.listAll(), isEmpty);
    });

    test('TeamMemberRepository can be implemented in memory', () async {
      final repository = _MemoryTeamMemberRepository();
      final member = TeamMember(
        id: 'member-1',
        name: 'Ana Silva',
        phone: '67999990000',
        roleId: 'role-1',
        dailyRate: 35000,
        status: TeamMemberStatus.active,
        createdAt: now,
        updatedAt: now,
      );

      await repository.insert(member);
      expect(await repository.findById('member-1'), member);
      expect(await repository.listAll(), [member]);

      final updated = member.copyWith(status: TeamMemberStatus.unavailable);
      await repository.update(updated);
      expect(await repository.findById('member-1'), updated);

      await repository.delete('member-1');
      expect(await repository.findById('member-1'), isNull);
      expect(await repository.listAll(), isEmpty);
    });
  });
}
