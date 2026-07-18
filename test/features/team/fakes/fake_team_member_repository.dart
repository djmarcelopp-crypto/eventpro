import 'package:eventpro/features/team/data/repositories/team_member_repository.dart';
import 'package:eventpro/features/team/models/team_member.dart';

class FakeTeamMemberRepository implements TeamMemberRepository {
  FakeTeamMemberRepository({List<TeamMember>? initialMembers})
      : _members = List<TeamMember>.from(initialMembers ?? const []);

  final List<TeamMember> _members;

  /// Makes the next write (insert/update/delete) throw once, then resets.
  var shouldFailOnNextOperation = false;

  @override
  Future<List<TeamMember>> listAll() async {
    return List<TeamMember>.unmodifiable(_members);
  }

  @override
  Future<TeamMember?> findById(String id) async {
    for (final member in _members) {
      if (member.id == id) {
        return member;
      }
    }
    return null;
  }

  @override
  Future<void> insert(TeamMember member) async {
    _failIfRequested();
    _members.add(member);
  }

  @override
  Future<void> update(TeamMember member) async {
    _failIfRequested();
    final index = _members.indexWhere((item) => item.id == member.id);
    if (index == -1) {
      throw StateError('TeamMember not found for update: ${member.id}');
    }
    _members[index] = member;
  }

  @override
  Future<void> delete(String id) async {
    _failIfRequested();
    final lengthBefore = _members.length;
    _members.removeWhere((member) => member.id == id);
    if (_members.length == lengthBefore) {
      throw StateError('TeamMember not found for delete: $id');
    }
  }

  void _failIfRequested() {
    if (!shouldFailOnNextOperation) {
      return;
    }
    shouldFailOnNextOperation = false;
    throw StateError('Simulated repository failure');
  }
}
