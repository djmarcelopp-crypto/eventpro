import '../models/team_role.dart';
import 'team_validation_result.dart';

abstract class TeamRoleValidator {
  static const nameRequiredError = 'Informe um nome para a função';

  static TeamValidationResult validateFields({String? name}) {
    final errors = <String>[];

    if (name == null || name.trim().isEmpty) {
      errors.add(nameRequiredError);
    }

    return TeamValidationResult(errors: List.unmodifiable(errors));
  }

  static TeamValidationResult validate(TeamRole role) {
    return validateFields(name: role.name);
  }
}
