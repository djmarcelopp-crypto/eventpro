import 'package:eventpro/features/team/data/repositories/team_role_repository.dart';
import 'package:eventpro/features/team/models/team_role.dart';

class FakeTeamRoleRepository implements TeamRoleRepository {
  FakeTeamRoleRepository({List<TeamRole>? initialRoles})
      : _roles = List<TeamRole>.from(initialRoles ?? const []);

  final List<TeamRole> _roles;

  /// Makes the next write (insert/update/delete) throw once, then resets.
  var shouldFailOnNextOperation = false;

  @override
  Future<List<TeamRole>> listAll() async {
    return List<TeamRole>.unmodifiable(_roles);
  }

  @override
  Future<TeamRole?> findById(String id) async {
    for (final role in _roles) {
      if (role.id == id) {
        return role;
      }
    }
    return null;
  }

  @override
  Future<void> insert(TeamRole role) async {
    _failIfRequested();
    _roles.add(role);
  }

  @override
  Future<void> update(TeamRole role) async {
    _failIfRequested();
    final index = _roles.indexWhere((item) => item.id == role.id);
    if (index == -1) {
      throw StateError('TeamRole not found for update: ${role.id}');
    }
    _roles[index] = role;
  }

  @override
  Future<void> delete(String id) async {
    _failIfRequested();
    final lengthBefore = _roles.length;
    _roles.removeWhere((role) => role.id == id);
    if (_roles.length == lengthBefore) {
      throw StateError('TeamRole not found for delete: $id');
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
