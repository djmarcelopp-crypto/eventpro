/// Result of validating a Team domain entity, shared between
/// [TeamRoleValidator] and [TeamMemberValidator].
class TeamValidationResult {
  const TeamValidationResult({required this.errors});

  final List<String> errors;

  bool get isValid => errors.isEmpty;
}
