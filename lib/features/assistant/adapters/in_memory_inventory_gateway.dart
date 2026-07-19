import '../domain/gateway/inventory_gateway.dart';
import '../models/assistant_module_availability.dart';
import '../models/assistant_module_capability.dart';
import '../models/assistant_module_data_source.dart';
import '../models/assistant_module_error.dart';
import '../models/assistant_module_request.dart';
import '../models/assistant_module_response.dart';
import '../models/assistant_module_result.dart';
import '../utils/assistant_text_normalizer.dart';

/// Test/fixture inventory search. Public path closed unless capabilities opt-in.
class InMemoryInventoryGateway implements InventoryGateway {
  InMemoryInventoryGateway({
    List<InMemoryInventoryRecord> seed = const [],
  }) : _items = List.unmodifiable(seed);

  final List<InMemoryInventoryRecord> _items;

  static const dataSource = AssistantModuleDataSource.inMemory;

  @override
  AssistantModuleResponse searchInventory(AssistantModuleRequest request) {
    try {
      final query = (request.query ?? '').trim();
      final normalized = AssistantTextNormalizer.fold(
        AssistantTextNormalizer.normalize(query),
      );
      final matches = _items.where((item) {
        final name = AssistantTextNormalizer.fold(
          AssistantTextNormalizer.normalize(item.name),
        );
        return normalized.isNotEmpty && name.contains(normalized);
      }).toList(growable: false);

      return AssistantModuleResponse(
        requestId: request.requestId,
        capability: AssistantModuleCapability.searchInventory,
        availability: AssistantModuleAvailability.available,
        dataSource: dataSource,
        result: AssistantModuleResult(
          id: 'inventory-${request.id}',
          capability: AssistantModuleCapability.searchInventory,
          dataSource: dataSource,
          found: matches.isNotEmpty,
          displayName: matches.isEmpty ? null : matches.first.name,
          identifier: matches.isEmpty ? null : matches.first.identifier,
          confidence: matches.isEmpty ? null : 0.85,
          summary: matches.isEmpty
              ? 'Nenhum item de estoque simulado correspondente'
              : '${matches.length} item(ns) encontrado(s)',
          metadata: {
            'names': matches.map((m) => m.name).toList(growable: false),
          },
        ),
      );
    } catch (error) {
      return AssistantModuleResponse(
        requestId: request.requestId,
        capability: AssistantModuleCapability.searchInventory,
        availability: AssistantModuleAvailability.error,
        dataSource: dataSource,
        error: AssistantModuleError(
          code: 'inventory_adapter_failure',
          message: 'Falha ao consultar estoque',
          details: error.toString(),
        ),
      );
    }
  }
}

class InMemoryInventoryRecord {
  const InMemoryInventoryRecord({
    required this.identifier,
    required this.name,
  });

  final String identifier;
  final String name;
}
