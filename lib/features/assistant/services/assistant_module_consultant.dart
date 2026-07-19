import '../domain/gateway/assistant_gateway.dart';
import '../models/assistant_entity_type.dart';
import '../models/assistant_execution_plan.dart';
import '../models/assistant_execution_status.dart';
import '../models/assistant_execution_step.dart';
import '../models/assistant_integration_mode.dart';
import '../models/assistant_integration_warning.dart';
import '../models/assistant_module_availability.dart';
import '../models/assistant_module_capability.dart';
import '../models/assistant_module_data_source.dart';
import '../models/assistant_module_error.dart';
import '../models/assistant_module_request.dart';
import '../models/assistant_module_response.dart';
import '../models/assistant_response.dart';
import 'assistant_capabilities.dart';

/// Consults registered read gateways safely — never throws to callers.
///
/// Never mutates drafts, capabilities, or write-step readiness.
class AssistantModuleConsultant {
  const AssistantModuleConsultant({
    required this.capabilities,
    this.gateway,
  });

  final AssistantCapabilities capabilities;
  final AssistantGateway? gateway;

  AssistantModuleConsultation consult({
    required AssistantResponse response,
    required AssistantExecutionPlan plan,
  }) {
    final results = <AssistantModuleResponse>[];
    final consulted = <AssistantModuleCapability>[];
    final unavailable = <AssistantModuleCapability>[];
    final warnings = <AssistantIntegrationWarning>[];
    final updatedSteps = <AssistantExecutionStep>[];

    if (capabilities.integrationMode == AssistantIntegrationMode.erp) {
      warnings.add(
        const AssistantIntegrationWarning(
          id: 'integ-erp-not-available',
          message:
              'integrationMode=erp não está disponível nesta sprint (AI-003).',
        ),
      );
    }

    for (final step in plan.steps) {
      final capability = _capabilityForAction(step.intendedAction);
      if (capability == null) {
        // Write / non-read steps are never consulted in AI-003.
        updatedSteps.add(step);
        continue;
      }

      final canPlan = _canPlan(capability);
      final canExecute = _canExecute(capability);
      final registered = gateway?.isRegistered(capability) ?? false;

      if (!canPlan || !canExecute || !registered) {
        unavailable.add(capability);
        final reason = _unavailableReason(
          canPlan: canPlan,
          canExecute: canExecute,
          registered: registered,
          capability: capability,
        );
        warnings.add(
          AssistantIntegrationWarning(
            id: 'integ-${step.id}',
            module: capability.name,
            message: reason,
          ),
        );
        updatedSteps.add(
          step.status == AssistantExecutionStatus.blocked
              ? step
              : step.copyWith(
                  status: AssistantExecutionStatus.unavailable,
                  blockReason: reason,
                ),
        );
        continue;
      }

      if (step.isBlocked) {
        updatedSteps.add(step);
        continue;
      }

      final request = AssistantModuleRequest(
        id: 'mod-${step.id}',
        requestId: response.requestId,
        capability: capability,
        query: _queryFor(capability, response),
        parameters: _parametersFor(capability, response),
      );

      final validationError = _validateRequest(request);
      if (validationError != null) {
        results.add(
          AssistantModuleResponse(
            requestId: response.requestId,
            capability: capability,
            availability: AssistantModuleAvailability.error,
            dataSource: AssistantModuleDataSource.inMemory,
            error: validationError,
          ),
        );
        warnings.add(
          AssistantIntegrationWarning(
            id: 'integ-invalid-${step.id}',
            module: capability.name,
            message: validationError.message,
          ),
        );
        updatedSteps.add(step);
        continue;
      }

      final moduleResponse = _invoke(request);
      results.add(moduleResponse);
      if (moduleResponse.isSuccess ||
          moduleResponse.availability == AssistantModuleAvailability.available) {
        consulted.add(capability);
      }

      if (moduleResponse.availability == AssistantModuleAvailability.error ||
          moduleResponse.error != null) {
        warnings.add(
          AssistantIntegrationWarning(
            id: 'integ-error-${step.id}',
            module: capability.name,
            message: moduleResponse.error?.message ??
                'Falha encapsulada na consulta ao módulo',
          ),
        );
      }

      updatedSteps.add(step);
    }

    final immutableSteps = List<AssistantExecutionStep>.unmodifiable(
      updatedSteps,
    );
    return AssistantModuleConsultation(
      results: List.unmodifiable(results),
      consultedModules: List.unmodifiable(consulted),
      unavailableModules: List.unmodifiable(unavailable),
      warnings: List.unmodifiable(warnings),
      plan: plan.copyWith(
        steps: immutableSteps,
        overallStatus: _overallStatus(immutableSteps),
      ),
    );
  }

  static AssistantExecutionStatus _overallStatus(
    List<AssistantExecutionStep> steps,
  ) {
    if (steps.isEmpty) return AssistantExecutionStatus.unavailable;
    if (steps.any((s) => s.isBlocked)) {
      return AssistantExecutionStatus.blocked;
    }
    if (steps.any((s) => s.isUnavailable)) {
      return AssistantExecutionStatus.unavailable;
    }
    if (steps.any((s) => s.isAwaitingConfirmation)) {
      return AssistantExecutionStatus.awaitingConfirmation;
    }
    if (steps.every((s) => s.isReady)) {
      return AssistantExecutionStatus.ready;
    }
    return AssistantExecutionStatus.unavailable;
  }

  AssistantModuleResponse _invoke(AssistantModuleRequest request) {
    try {
      final g = gateway;
      if (g == null) {
        return AssistantModuleResponse(
          requestId: request.requestId,
          capability: request.capability,
          availability: AssistantModuleAvailability.notRegistered,
          dataSource: AssistantModuleDataSource.inMemory,
          error: const AssistantModuleError(
            code: 'gateway_missing',
            message: 'Nenhum AssistantGateway registrado',
          ),
        );
      }

      return switch (request.capability) {
        AssistantModuleCapability.searchClient =>
          g.clients!.searchClient(request),
        AssistantModuleCapability.checkSchedule =>
          g.agenda!.checkSchedule(request),
        AssistantModuleCapability.checkAvailability =>
          g.agenda!.checkAvailability(request),
        AssistantModuleCapability.lookupQuote =>
          g.quotes!.lookupQuote(request),
        AssistantModuleCapability.searchInventory =>
          g.inventory!.searchInventory(request),
        AssistantModuleCapability.searchTeam => g.team!.searchTeam(request),
      };
    } catch (error) {
      return AssistantModuleResponse(
        requestId: request.requestId,
        capability: request.capability,
        availability: AssistantModuleAvailability.error,
        dataSource: AssistantModuleDataSource.inMemory,
        error: AssistantModuleError(
          code: 'consultation_failure',
          message: 'Falha encapsulada ao consultar módulo',
          details: error.toString(),
        ),
      );
    }
  }

  static AssistantModuleError? _validateRequest(AssistantModuleRequest request) {
    switch (request.capability) {
      case AssistantModuleCapability.searchClient:
        if ((request.query ?? '').trim().isEmpty) {
          return const AssistantModuleError(
            code: 'invalid_request',
            message: 'searchClient exige query com nome do cliente',
          );
        }
      case AssistantModuleCapability.checkAvailability:
        if ((request.parameters['date'] ?? '').trim().isEmpty) {
          return const AssistantModuleError(
            code: 'invalid_request',
            message: 'checkAvailability exige parâmetro date',
          );
        }
      case AssistantModuleCapability.lookupQuote:
      case AssistantModuleCapability.searchInventory:
      case AssistantModuleCapability.searchTeam:
        if ((request.query ?? '').trim().isEmpty) {
          return AssistantModuleError(
            code: 'invalid_request',
            message: '${request.capability.name} exige query',
          );
        }
      case AssistantModuleCapability.checkSchedule:
        break;
    }
    return null;
  }

  static AssistantModuleCapability? _capabilityForAction(String action) {
    return switch (action) {
      'searchClient' => AssistantModuleCapability.searchClient,
      'checkSchedule' => AssistantModuleCapability.checkSchedule,
      'checkAvailability' => AssistantModuleCapability.checkAvailability,
      'lookupQuote' => AssistantModuleCapability.lookupQuote,
      'searchInventory' => AssistantModuleCapability.searchInventory,
      'searchTeam' => AssistantModuleCapability.searchTeam,
      _ => null,
    };
  }

  bool _canPlan(AssistantModuleCapability capability) {
    return switch (capability) {
      AssistantModuleCapability.searchClient =>
        capabilities.canPlanSearchClient,
      AssistantModuleCapability.checkSchedule =>
        capabilities.canPlanCheckSchedule,
      AssistantModuleCapability.checkAvailability =>
        capabilities.canPlanCheckAvailability,
      AssistantModuleCapability.lookupQuote => capabilities.canPlanLookupQuote,
      AssistantModuleCapability.searchInventory =>
        capabilities.canPlanSearchInventory,
      AssistantModuleCapability.searchTeam => capabilities.canPlanSearchTeam,
    };
  }

  bool _canExecute(AssistantModuleCapability capability) {
    return switch (capability) {
      AssistantModuleCapability.searchClient =>
        capabilities.canExecuteClientSearch,
      AssistantModuleCapability.checkSchedule =>
        capabilities.canExecuteScheduleRead,
      AssistantModuleCapability.checkAvailability =>
        capabilities.canExecuteAvailabilityRead,
      AssistantModuleCapability.lookupQuote =>
        capabilities.canExecuteLookupQuote,
      AssistantModuleCapability.searchInventory =>
        capabilities.canExecuteSearchInventory,
      AssistantModuleCapability.searchTeam =>
        capabilities.canExecuteSearchTeam,
    };
  }

  static String? _queryFor(
    AssistantModuleCapability capability,
    AssistantResponse response,
  ) {
    if (capability != AssistantModuleCapability.searchClient) return null;
    final fromDraft = response.eventDraft?.clientName?.trim();
    if (fromDraft != null && fromDraft.isNotEmpty) return fromDraft;
    for (final entity in response.entities) {
      if (entity.type != AssistantEntityType.clientName) continue;
      final value = (entity.normalizedValue ?? entity.rawValue).trim();
      if (value.isNotEmpty) return value;
    }
    return null;
  }

  static Map<String, String> _parametersFor(
    AssistantModuleCapability capability,
    AssistantResponse response,
  ) {
    if (capability == AssistantModuleCapability.checkAvailability ||
        capability == AssistantModuleCapability.checkSchedule) {
      final date = response.eventDraft?.date;
      if (date == null) return const {};
      final iso =
          '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      return {'date': iso};
    }
    return const {};
  }

  static String _unavailableReason({
    required bool canPlan,
    required bool canExecute,
    required bool registered,
    required AssistantModuleCapability capability,
  }) {
    if (!canPlan) {
      return 'Planejamento desabilitado para ${capability.name}';
    }
    if (!canExecute) {
      return 'Executor de leitura desabilitado para ${capability.name} '
          '(não implica ERP real)';
    }
    if (!registered) {
      return 'Gateway não registrado para ${capability.name}';
    }
    return 'Integração indisponível para ${capability.name}';
  }
}

class AssistantModuleConsultation {
  const AssistantModuleConsultation({
    required this.results,
    required this.consultedModules,
    required this.unavailableModules,
    required this.warnings,
    required this.plan,
  });

  final List<AssistantModuleResponse> results;
  final List<AssistantModuleCapability> consultedModules;
  final List<AssistantModuleCapability> unavailableModules;
  final List<AssistantIntegrationWarning> warnings;
  final AssistantExecutionPlan plan;
}
