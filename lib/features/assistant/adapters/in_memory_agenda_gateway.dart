import '../domain/gateway/agenda_gateway.dart';
import '../models/assistant_module_availability.dart';
import '../models/assistant_module_capability.dart';
import '../models/assistant_module_data_source.dart';
import '../models/assistant_module_error.dart';
import '../models/assistant_module_request.dart';
import '../models/assistant_module_response.dart';
import '../models/assistant_module_result.dart';

/// In-memory agenda fixture. Always [AssistantModuleDataSource.inMemory].
class InMemoryAgendaGateway implements AgendaGateway {
  InMemoryAgendaGateway({
    List<InMemoryAgendaSlot> seed = const [],
  }) : _slots = List.unmodifiable(seed);

  final List<InMemoryAgendaSlot> _slots;

  static const dataSource = AssistantModuleDataSource.inMemory;

  @override
  AssistantModuleResponse checkSchedule(AssistantModuleRequest request) {
    return _safe(request, AssistantModuleCapability.checkSchedule, () {
      final date = request.parameters['date'];
      final matches = date == null
          ? _slots
          : _slots.where((s) => s.date == date).toList(growable: false);
      return AssistantModuleResponse(
        requestId: request.requestId,
        capability: AssistantModuleCapability.checkSchedule,
        availability: AssistantModuleAvailability.available,
        dataSource: dataSource,
        result: AssistantModuleResult(
          id: 'schedule-${request.id}',
          capability: AssistantModuleCapability.checkSchedule,
          dataSource: dataSource,
          found: matches.isNotEmpty,
          summary: matches.isEmpty
              ? 'Nenhum compromisso simulado na agenda'
              : '${matches.length} compromisso(s) simulado(s)',
          metadata: {
            'date': date,
            'count': matches.length,
            'titles': matches.map((m) => m.title).toList(growable: false),
          },
        ),
      );
    });
  }

  @override
  AssistantModuleResponse checkAvailability(AssistantModuleRequest request) {
    return _safe(request, AssistantModuleCapability.checkAvailability, () {
      final date = request.parameters['date'];
      if (date == null || date.isEmpty) {
        return AssistantModuleResponse(
          requestId: request.requestId,
          capability: AssistantModuleCapability.checkAvailability,
          availability: AssistantModuleAvailability.available,
          dataSource: dataSource,
          result: AssistantModuleResult(
            id: 'availability-missing-date-${request.id}',
            capability: AssistantModuleCapability.checkAvailability,
            dataSource: dataSource,
            found: false,
            summary: 'Data ausente para consultar disponibilidade',
          ),
        );
      }
      final busy = _slots.where((s) => s.date == date).toList(growable: false);
      final available = busy.isEmpty;
      return AssistantModuleResponse(
        requestId: request.requestId,
        capability: AssistantModuleCapability.checkAvailability,
        availability: AssistantModuleAvailability.available,
        dataSource: dataSource,
        result: AssistantModuleResult(
          id: 'availability-${request.id}',
          capability: AssistantModuleCapability.checkAvailability,
          dataSource: dataSource,
          found: available,
          summary: available
              ? 'Disponível na data $date (simulado)'
              : 'Indisponível na data $date (simulado)',
          metadata: {
            'date': date,
            'available': available,
            'conflicts': busy.map((b) => b.title).toList(growable: false),
          },
        ),
      );
    });
  }

  AssistantModuleResponse _safe(
    AssistantModuleRequest request,
    AssistantModuleCapability capability,
    AssistantModuleResponse Function() body,
  ) {
    try {
      return body();
    } catch (error) {
      return AssistantModuleResponse(
        requestId: request.requestId,
        capability: capability,
        availability: AssistantModuleAvailability.error,
        dataSource: dataSource,
        error: AssistantModuleError(
          code: 'agenda_adapter_failure',
          message: 'Falha ao consultar agenda',
          details: error.toString(),
        ),
      );
    }
  }
}

class InMemoryAgendaSlot {
  const InMemoryAgendaSlot({
    required this.date,
    required this.title,
  });

  /// ISO date `yyyy-MM-dd`.
  final String date;
  final String title;
}
