import '../domain/gateway/team_gateway.dart';
import '../models/assistant_module_availability.dart';
import '../models/assistant_module_capability.dart';
import '../models/assistant_module_data_source.dart';
import '../models/assistant_module_error.dart';
import '../models/assistant_module_request.dart';
import '../models/assistant_module_response.dart';
import '../models/assistant_module_result.dart';
import '../utils/assistant_text_normalizer.dart';

/// Test/fixture team search. Public path closed unless capabilities opt-in.
class InMemoryTeamGateway implements TeamGateway {
  InMemoryTeamGateway({
    List<InMemoryTeamRecord> seed = const [],
  }) : _members = List.unmodifiable(seed);

  final List<InMemoryTeamRecord> _members;

  static const dataSource = AssistantModuleDataSource.inMemory;

  @override
  AssistantModuleResponse searchTeam(AssistantModuleRequest request) {
    try {
      final query = (request.query ?? '').trim();
      final normalized = AssistantTextNormalizer.fold(
        AssistantTextNormalizer.normalize(query),
      );
      final matches = _members.where((member) {
        final name = AssistantTextNormalizer.fold(
          AssistantTextNormalizer.normalize(member.displayName),
        );
        final role = AssistantTextNormalizer.fold(
          AssistantTextNormalizer.normalize(member.role),
        );
        return normalized.isNotEmpty &&
            (name.contains(normalized) || role.contains(normalized));
      }).toList(growable: false);

      return AssistantModuleResponse(
        requestId: request.requestId,
        capability: AssistantModuleCapability.searchTeam,
        availability: AssistantModuleAvailability.available,
        dataSource: dataSource,
        result: AssistantModuleResult(
          id: 'team-${request.id}',
          capability: AssistantModuleCapability.searchTeam,
          dataSource: dataSource,
          found: matches.isNotEmpty,
          displayName: matches.isEmpty ? null : matches.first.displayName,
          identifier: matches.isEmpty ? null : matches.first.identifier,
          confidence: matches.isEmpty ? null : 0.85,
          summary: matches.isEmpty
              ? 'Nenhum membro de equipe simulado correspondente'
              : '${matches.length} membro(s) encontrado(s)',
          metadata: {
            'names':
                matches.map((m) => m.displayName).toList(growable: false),
          },
        ),
      );
    } catch (error) {
      return AssistantModuleResponse(
        requestId: request.requestId,
        capability: AssistantModuleCapability.searchTeam,
        availability: AssistantModuleAvailability.error,
        dataSource: dataSource,
        error: AssistantModuleError(
          code: 'team_adapter_failure',
          message: 'Falha ao consultar equipe',
          details: error.toString(),
        ),
      );
    }
  }
}

class InMemoryTeamRecord {
  const InMemoryTeamRecord({
    required this.identifier,
    required this.displayName,
    required this.role,
  });

  final String identifier;
  final String displayName;
  final String role;
}
