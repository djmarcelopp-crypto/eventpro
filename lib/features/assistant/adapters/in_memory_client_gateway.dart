import '../domain/gateway/client_gateway.dart';
import '../models/assistant_module_availability.dart';
import '../models/assistant_module_capability.dart';
import '../models/assistant_module_data_source.dart';
import '../models/assistant_module_error.dart';
import '../models/assistant_module_request.dart';
import '../models/assistant_module_response.dart';
import '../models/assistant_module_result.dart';
import '../utils/assistant_text_normalizer.dart';

/// In-memory client lookup fixture. Never touches SQLite or repositories.
///
/// Always reports [AssistantModuleDataSource.inMemory].
class InMemoryClientGateway implements ClientGateway {
  InMemoryClientGateway({
    List<InMemoryClientRecord> seed = const [],
  }) : _clients = List.unmodifiable(seed);

  final List<InMemoryClientRecord> _clients;

  static const dataSource = AssistantModuleDataSource.inMemory;

  @override
  AssistantModuleResponse searchClient(AssistantModuleRequest request) {
    try {
      if (request.capability != AssistantModuleCapability.searchClient) {
        return AssistantModuleResponse(
          requestId: request.requestId,
          capability: request.capability,
          availability: AssistantModuleAvailability.error,
          dataSource: dataSource,
          error: const AssistantModuleError(
            code: 'unsupported_capability',
            message: 'ClientGateway aceita apenas searchClient',
          ),
        );
      }
      final query = (request.query ?? '').trim();
      if (query.isEmpty) {
        return AssistantModuleResponse(
          requestId: request.requestId,
          capability: AssistantModuleCapability.searchClient,
          availability: AssistantModuleAvailability.available,
          dataSource: dataSource,
          result: AssistantModuleResult(
            id: 'client-empty-${request.id}',
            capability: AssistantModuleCapability.searchClient,
            dataSource: dataSource,
            found: false,
            summary: 'Consulta de cliente sem nome',
          ),
        );
      }

      final normalized = AssistantTextNormalizer.fold(
        AssistantTextNormalizer.normalize(query),
      );
      InMemoryClientRecord? best;
      var bestScore = 0.0;
      for (final client in _clients) {
        final name = AssistantTextNormalizer.fold(
          AssistantTextNormalizer.normalize(client.displayName),
        );
        if (name == normalized) {
          best = client;
          bestScore = 0.98;
          break;
        }
        if (name.contains(normalized) || normalized.contains(name)) {
          const score = 0.75;
          if (score > bestScore) {
            best = client;
            bestScore = score;
          }
        }
      }

      if (best == null) {
        return AssistantModuleResponse(
          requestId: request.requestId,
          capability: AssistantModuleCapability.searchClient,
          availability: AssistantModuleAvailability.available,
          dataSource: dataSource,
          result: AssistantModuleResult(
            id: 'client-miss-${request.id}',
            capability: AssistantModuleCapability.searchClient,
            dataSource: dataSource,
            found: false,
            summary: 'Nenhum cliente correspondente a "$query"',
            metadata: {'query': query},
          ),
        );
      }

      return AssistantModuleResponse(
        requestId: request.requestId,
        capability: AssistantModuleCapability.searchClient,
        availability: AssistantModuleAvailability.available,
        dataSource: dataSource,
        result: AssistantModuleResult(
          id: 'client-hit-${best.identifier}',
          capability: AssistantModuleCapability.searchClient,
          dataSource: dataSource,
          found: true,
          displayName: best.displayName,
          identifier: best.identifier,
          confidence: bestScore,
          summary: 'Cliente encontrado: ${best.displayName}',
          metadata: {
            'query': query,
            'phone': best.phone,
          },
        ),
      );
    } catch (error) {
      return AssistantModuleResponse(
        requestId: request.requestId,
        capability: AssistantModuleCapability.searchClient,
        availability: AssistantModuleAvailability.error,
        dataSource: dataSource,
        error: AssistantModuleError(
          code: 'client_adapter_failure',
          message: 'Falha ao consultar clientes',
          details: error.toString(),
        ),
      );
    }
  }
}

class InMemoryClientRecord {
  const InMemoryClientRecord({
    required this.identifier,
    required this.displayName,
    this.phone,
  });

  final String identifier;
  final String displayName;
  final String? phone;
}
