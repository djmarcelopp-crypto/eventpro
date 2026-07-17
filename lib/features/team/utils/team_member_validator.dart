import '../models/team_member.dart';
import '../models/team_member_status.dart';
import 'team_validation_result.dart';

abstract class TeamMemberValidator {
  static const nameRequiredError = 'Informe o nome do membro da equipe';
  static const roleRequiredError = 'Selecione uma função';
  static const dailyRateNonNegativeError =
      'Informe uma diária maior ou igual a zero';
  static const statusRequiredError = 'Selecione um status';
  static const statusInvalidError = 'Status inválido';

  static TeamValidationResult validateFields({
    String? name,
    String? roleId,
    int? dailyRate,
    TeamMemberStatus? status,
    String? statusName,
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
      if (statusName == null || statusName.trim().isEmpty) {
        errors.add(statusRequiredError);
      } else if (!TeamMemberStatus.values
          .any((value) => value.name == statusName)) {
        errors.add(statusInvalidError);
      }
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
