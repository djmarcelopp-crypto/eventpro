import '../models/team_member.dart';
import '../models/team_member_status.dart';
import 'team_validation_result.dart';

abstract class TeamMemberValidator {
  static const nameRequiredError = 'Informe o nome do membro da equipe';
  static const roleRequiredError = 'Selecione uma função';
  static const dailyRateNonNegativeError =
      'Informe uma diária maior ou igual a zero';
  static const statusRequiredError = 'Selecione um status';

  static TeamValidationResult validateFields({
    String? name,
    String? roleId,
    int? dailyRate,
    TeamMemberStatus? status,
  }) {
    final errors = <String>[];

    if (name == null || name.trim().isEmpty) {
      errors.add(nameRequiredError);
    }

    if (roleId == null || roleId.trim().isEmpty) {
      errors.add(roleRequiredError);
    }

    if (dailyRate == null || dailyRate < 0) {
      errors.add(dailyRateNonNegativeError);
    }

    if (status == null) {
      errors.add(statusRequiredError);
    }

    return TeamValidationResult(errors: List.unmodifiable(errors));
  }

  static TeamValidationResult validate(TeamMember member) {
    return validateFields(
      name: member.name,
      roleId: member.roleId,
      dailyRate: member.dailyRate,
      status: member.status,
    );
  }
}
