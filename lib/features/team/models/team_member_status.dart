/// Operational status of a [TeamMember] in the roster.
///
/// Pure Dart — no Flutter dependency. UI colors (if needed later) belong in
/// presentation, not in the domain.
enum TeamMemberStatus {
  active,
  unavailable,
  inactive,
}

extension TeamMemberStatusLabels on TeamMemberStatus {
  String get label => switch (this) {
        TeamMemberStatus.active => 'Ativo',
        TeamMemberStatus.unavailable => 'Indisponível',
        TeamMemberStatus.inactive => 'Inativo',
      };
}
