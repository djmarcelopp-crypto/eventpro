import 'package:eventpro/features/team/models/team_member.dart';

/// Domain contract for persisting [TeamMember] records.
///
/// Storage-agnostic: no Drift (or other) implementation in this checkpoint.
abstract class TeamMemberRepository {
  Future<List<TeamMember>> listAll();

  Future<TeamMember?> findById(String id);

  Future<void> insert(TeamMember member);

  Future<void> update(TeamMember member);

  Future<void> delete(String id);
}
