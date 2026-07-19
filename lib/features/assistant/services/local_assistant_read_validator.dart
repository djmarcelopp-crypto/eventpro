import '../domain/read/assistant_read_validator.dart';
import '../models/assistant_read_pagination.dart';
import '../models/assistant_read_query.dart';
import '../models/assistant_read_validation_result.dart';

/// Local validation for structured read queries.
class LocalAssistantReadValidator implements AssistantReadValidator {
  const LocalAssistantReadValidator({
    this.supportedModules = const {AssistantReadModules.quote},
  });

  final Set<String> supportedModules;

  @override
  AssistantReadValidationResult validate(AssistantReadQuery query) {
    final errors = <String>[];
    final warnings = <String>[];

    if (query.id.trim().isEmpty) {
      errors.add('id da ReadQuery é obrigatório');
    }
    if (query.requestId.trim().isEmpty) {
      errors.add('requestId da ReadQuery é obrigatório');
    }
    if (query.module.trim().isEmpty) {
      errors.add('module da ReadQuery é obrigatório');
    } else if (!supportedModules.contains(query.module)) {
      errors.add('module ${query.module} não suportado em AI-008');
    }

    if (!query.pagination.isValid) {
      errors.add(
        'paginação inválida (offset>=0, 1<=limit<=${AssistantReadPagination.maxLimit})',
      );
    }

    for (final filter in query.filters) {
      if (!filter.isValid) {
        errors.add('filtro inválido: field/operator/value obrigatórios');
      }
    }

    for (final sort in query.sorting) {
      if (!sort.isValid) {
        errors.add('sort inválido: field obrigatório');
      }
    }

    if (query.filters.isEmpty) {
      warnings.add('consulta sem filtros — adapter aplicará listagem paginada');
    }

    return AssistantReadValidationResult.fromParts(
      errors: errors,
      warnings: warnings,
    );
  }
}
