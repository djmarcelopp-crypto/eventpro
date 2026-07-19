import '../domain/gateway/quote_gateway.dart';
import '../models/assistant_module_availability.dart';
import '../models/assistant_module_capability.dart';
import '../models/assistant_module_data_source.dart';
import '../models/assistant_module_error.dart';
import '../models/assistant_module_request.dart';
import '../models/assistant_module_response.dart';
import '../models/assistant_module_result.dart';
import '../utils/assistant_text_normalizer.dart';

/// Test/fixture quote lookup. Not enabled in the public orchestrator path
/// unless `canPlanLookupQuote` + `canExecuteLookupQuote` are explicitly set.
///
/// Always [AssistantModuleDataSource.inMemory].
class InMemoryQuoteGateway implements QuoteGateway {
  InMemoryQuoteGateway({
    List<InMemoryQuoteRecord> seed = const [],
  }) : _quotes = List.unmodifiable(seed);

  final List<InMemoryQuoteRecord> _quotes;

  static const dataSource = AssistantModuleDataSource.inMemory;

  @override
  AssistantModuleResponse lookupQuote(AssistantModuleRequest request) {
    try {
      final query = (request.query ?? request.parameters['client'] ?? '').trim();
      final normalized = AssistantTextNormalizer.fold(
        AssistantTextNormalizer.normalize(query),
      );
      final matches = _quotes.where((q) {
        final client = AssistantTextNormalizer.fold(
          AssistantTextNormalizer.normalize(q.clientName),
        );
        final id = AssistantTextNormalizer.fold(q.identifier);
        return normalized.isNotEmpty &&
            (client.contains(normalized) ||
                normalized.contains(client) ||
                id == normalized);
      }).toList(growable: false);

      if (matches.isEmpty) {
        return AssistantModuleResponse(
          requestId: request.requestId,
          capability: AssistantModuleCapability.lookupQuote,
          availability: AssistantModuleAvailability.available,
          dataSource: dataSource,
          result: AssistantModuleResult(
            id: 'quote-miss-${request.id}',
            capability: AssistantModuleCapability.lookupQuote,
            dataSource: dataSource,
            found: false,
            summary: 'Nenhum orçamento simulado correspondente',
            metadata: {'query': query},
          ),
        );
      }

      final hit = matches.first;
      return AssistantModuleResponse(
        requestId: request.requestId,
        capability: AssistantModuleCapability.lookupQuote,
        availability: AssistantModuleAvailability.available,
        dataSource: dataSource,
        result: AssistantModuleResult(
          id: 'quote-hit-${hit.identifier}',
          capability: AssistantModuleCapability.lookupQuote,
          dataSource: dataSource,
          found: true,
          displayName: hit.title,
          identifier: hit.identifier,
          confidence: 0.9,
          summary: 'Orçamento encontrado: ${hit.title}',
          metadata: {
            'clientName': hit.clientName,
            'status': hit.status,
          },
        ),
      );
    } catch (error) {
      return AssistantModuleResponse(
        requestId: request.requestId,
        capability: AssistantModuleCapability.lookupQuote,
        availability: AssistantModuleAvailability.error,
        dataSource: dataSource,
        error: AssistantModuleError(
          code: 'quote_adapter_failure',
          message: 'Falha ao consultar orçamentos',
          details: error.toString(),
        ),
      );
    }
  }
}

class InMemoryQuoteRecord {
  const InMemoryQuoteRecord({
    required this.identifier,
    required this.title,
    required this.clientName,
    this.status = 'draft',
  });

  final String identifier;
  final String title;
  final String clientName;
  final String status;
}
