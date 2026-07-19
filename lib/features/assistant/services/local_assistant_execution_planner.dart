import '../domain/assistant_execution_planner.dart';
import '../models/assistant_confirmation_policy.dart';
import '../models/assistant_entity_type.dart';
import '../models/assistant_execution_decision.dart';
import '../models/assistant_execution_plan.dart';
import '../models/assistant_execution_requirement.dart';
import '../models/assistant_execution_risk.dart';
import '../models/assistant_execution_status.dart';
import '../models/assistant_execution_step.dart';
import '../models/assistant_execution_warning.dart';
import '../models/assistant_intent_type.dart';
import '../models/assistant_module_target.dart';
import '../models/assistant_response.dart';
import 'assistant_capabilities.dart';

/// Deterministic local planner. Describes steps only — never runs modules.
///
/// Uses structured fields from [AssistantResponse] (intent, drafts, entities,
/// questions). Never parses [AssistantResponse.friendlyMessage] or raw text.
class LocalAssistantExecutionPlanner implements AssistantExecutionPlanner {
  LocalAssistantExecutionPlanner({
    AssistantCapabilities? capabilities,
    Set<String> confirmedStepIds = const {},
  })  : _capabilities = capabilities ?? AssistantCapabilities.localDefaults(),
        _confirmedStepIds = Set.unmodifiable(confirmedStepIds);

  final AssistantCapabilities _capabilities;

  /// Simulated user confirmations for audit/tests. Never enables ERP execution
  /// when the matching `canExecute*` flag is false.
  final Set<String> _confirmedStepIds;

  @override
  AssistantExecutionPlan plan(AssistantResponse response) {
    final intent = response.primaryIntent.type;
    final steps = _buildSteps(response);
    final decisions = <AssistantExecutionDecision>[
      const AssistantExecutionDecision(
        id: 'decision-no-execution',
        description: 'Nenhuma etapa será executada nesta sprint',
        rationale:
            'AI-002 produz apenas plano auditável; execução fica para etapas futuras',
      ),
      AssistantExecutionDecision(
        id: 'decision-intent',
        description: 'Plano derivado da intenção ${intent.name}',
        rationale: response.primaryIntent.evidences.join('; '),
      ),
      AssistantExecutionDecision(
        id: 'decision-execution-off',
        description: 'Capacidades de execução desabilitadas por padrão',
        rationale:
            'canExecute*=${_capabilities.anyExecutionEnabled} (defaults: false)',
      ),
    ];

    final warnings = <AssistantExecutionWarning>[
      const AssistantExecutionWarning(
        id: 'warn-no-side-effects',
        message:
            'O assistente entendeu sua solicitação, mas ainda faltam informações '
            'antes que qualquer operação possa ser realizada.',
      ),
      if (!_capabilities.anyExecutionEnabled)
        const AssistantExecutionWarning(
          id: 'warn-no-executor',
          message:
              'Nenhum executor ERP está habilitado — confirmação não dispara ações reais.',
        ),
      ...steps
          .where((s) => s.blockReason != null)
          .map(
            (s) => AssistantExecutionWarning(
              id: 'warn-${s.id}',
              message: s.blockReason!,
              stepId: s.id,
            ),
          ),
    ];

    return AssistantExecutionPlan(
      id: 'plan-${response.requestId}',
      requestId: response.requestId,
      steps: List.unmodifiable(steps),
      overallStatus: _overallStatus(steps),
      decisions: List.unmodifiable(decisions),
      warnings: List.unmodifiable(warnings),
      summary: _summary(intent: intent, steps: steps),
    );
  }

  List<AssistantExecutionStep> _buildSteps(AssistantResponse response) {
    return switch (response.primaryIntent.type) {
      AssistantIntentType.createEvent ||
      AssistantIntentType.createQuote =>
        _buildCreateFlow(response),
      AssistantIntentType.checkAvailability =>
        _buildAvailabilityFlow(response),
      AssistantIntentType.checkSchedule => _buildScheduleFlow(),
      AssistantIntentType.searchClient => _buildSearchClientFlow(response),
      AssistantIntentType.updateEvent => _buildUpdateEventFlow(response),
      AssistantIntentType.unknown => const [],
    };
  }

  List<AssistantExecutionStep> _buildCreateFlow(AssistantResponse response) {
    final dateOk = response.eventDraft?.date != null;
    final timeOk = response.eventDraft?.startTime != null &&
        response.eventDraft?.endTime != null;
    final placeOk = response.eventDraft?.city != null ||
        response.eventDraft?.venue != null;

    final dateReq = AssistantExecutionRequirement(
      id: 'req-date',
      description: 'Data do evento informada',
      satisfied: dateOk,
    );
    final timeReq = AssistantExecutionRequirement(
      id: 'req-time',
      description: 'Horário de início e término informados',
      satisfied: timeOk,
    );
    final placeReq = AssistantExecutionRequirement(
      id: 'req-place',
      description: 'Local ou cidade informados',
      satisfied: placeOk,
    );

    final missing = <String>[
      if (!dateOk) 'data ausente',
      if (!timeOk) 'horário ausente',
      if (!placeOk) 'local ausente',
    ];
    final gapReason =
        missing.isEmpty ? null : _capitalize(missing.join('; '));
    final createPreconditionsMet = dateOk && timeOk && placeOk;

    final eventResolved = _resolve(
      canPlan: _capabilities.canPlanCreateEvent,
      canExecute: _capabilities.canExecuteCreateEvent,
      preconditionsMet: createPreconditionsMet,
      dependenciesSatisfied: true,
      confirmationPolicy: AssistantConfirmationPolicy.requiredBeforeWrite,
      stepId: 'step-create-event',
      planFlag: 'canPlanCreateEvent',
      executeFlag: 'canExecuteCreateEvent',
      gapReason: gapReason,
    );

    final eventStep = AssistantExecutionStep(
      id: 'step-create-event',
      order: 1,
      moduleTarget: AssistantModuleTarget.events,
      intendedAction: 'createEvent',
      description: 'Criar Evento',
      status: eventResolved.status,
      preconditions: [dateReq, timeReq, placeReq],
      risks: const [
        AssistantExecutionRisk(
          id: 'risk-event-write',
          description: 'Criaria um evento no ERP se fosse executado',
          severity: 'high',
        ),
      ],
      confirmationPolicy: AssistantConfirmationPolicy.requiredBeforeWrite,
      blockReason: eventResolved.reason,
    );

    final quoteResolved = _resolve(
      canPlan: _capabilities.canPlanCreateQuote,
      canExecute: _capabilities.canExecuteCreateQuote,
      preconditionsMet: createPreconditionsMet,
      dependenciesSatisfied: _dependencyAllowsProgress(eventResolved.status),
      confirmationPolicy: AssistantConfirmationPolicy.requiredBeforeWrite,
      stepId: 'step-create-quote',
      planFlag: 'canPlanCreateQuote',
      executeFlag: 'canExecuteCreateQuote',
      gapReason: gapReason,
      unmetDependencyReason: 'Dependência Criar Evento não satisfeita',
    );

    final quoteStep = AssistantExecutionStep(
      id: 'step-create-quote',
      order: 2,
      moduleTarget: AssistantModuleTarget.quotes,
      intendedAction: 'createQuote',
      description: 'Criar Orçamento',
      status: quoteResolved.status,
      preconditions: [dateReq, timeReq, placeReq],
      dependencyStepIds: const ['step-create-event'],
      risks: const [
        AssistantExecutionRisk(
          id: 'risk-quote-write',
          description: 'Criaria um orçamento no ERP se fosse executado',
          severity: 'high',
        ),
      ],
      confirmationPolicy: AssistantConfirmationPolicy.requiredBeforeWrite,
      blockReason: quoteResolved.reason,
    );

    final availabilityResolved = _resolve(
      canPlan: _capabilities.canPlanCheckAvailability,
      canExecute: _capabilities.canExecuteAvailabilityRead,
      preconditionsMet: dateOk,
      dependenciesSatisfied: _dependencyAllowsProgress(eventResolved.status),
      confirmationPolicy: AssistantConfirmationPolicy.none,
      stepId: 'step-check-availability',
      planFlag: 'canPlanCheckAvailability',
      executeFlag: 'canExecuteAvailabilityRead',
      gapReason: dateOk ? null : 'Data ausente',
      unmetDependencyReason: 'Dependência Criar Evento não satisfeita',
    );

    final availabilityStep = AssistantExecutionStep(
      id: 'step-check-availability',
      order: 3,
      moduleTarget: AssistantModuleTarget.agenda,
      intendedAction: 'checkAvailability',
      description: 'Consultar Disponibilidade',
      status: availabilityResolved.status,
      preconditions: [dateReq],
      dependencyStepIds: const ['step-create-event'],
      risks: const [
        AssistantExecutionRisk(
          id: 'risk-agenda-read',
          description: 'Consultaria a agenda sem alterar dados',
          severity: 'low',
        ),
      ],
      confirmationPolicy: AssistantConfirmationPolicy.none,
      blockReason: availabilityResolved.reason,
    );

    return [eventStep, quoteStep, availabilityStep];
  }

  List<AssistantExecutionStep> _buildAvailabilityFlow(
    AssistantResponse response,
  ) {
    final dateOk = response.eventDraft?.date != null ||
        response.entities.any((e) => e.type == AssistantEntityType.date);
    final dateReq = AssistantExecutionRequirement(
      id: 'req-date',
      description: 'Data para consulta informada',
      satisfied: dateOk,
    );
    final resolved = _resolve(
      canPlan: _capabilities.canPlanCheckAvailability,
      canExecute: _capabilities.canExecuteAvailabilityRead,
      preconditionsMet: dateOk,
      dependenciesSatisfied: true,
      confirmationPolicy: AssistantConfirmationPolicy.none,
      stepId: 'step-check-availability',
      planFlag: 'canPlanCheckAvailability',
      executeFlag: 'canExecuteAvailabilityRead',
      gapReason: dateOk ? null : 'Data ausente',
    );
    return [
      AssistantExecutionStep(
        id: 'step-check-availability',
        order: 1,
        moduleTarget: AssistantModuleTarget.agenda,
        intendedAction: 'checkAvailability',
        description: 'Consultar Disponibilidade',
        status: resolved.status,
        preconditions: [dateReq],
        risks: const [
          AssistantExecutionRisk(
            id: 'risk-agenda-read',
            description: 'Consulta somente leitura à agenda',
            severity: 'low',
          ),
        ],
        confirmationPolicy: AssistantConfirmationPolicy.none,
        blockReason: resolved.reason,
      ),
    ];
  }

  List<AssistantExecutionStep> _buildScheduleFlow() {
    final resolved = _resolve(
      canPlan: _capabilities.canPlanCheckSchedule,
      canExecute: _capabilities.canExecuteScheduleRead,
      preconditionsMet: true,
      dependenciesSatisfied: true,
      confirmationPolicy: AssistantConfirmationPolicy.none,
      stepId: 'step-check-schedule',
      planFlag: 'canPlanCheckSchedule',
      executeFlag: 'canExecuteScheduleRead',
      gapReason: null,
    );
    return [
      AssistantExecutionStep(
        id: 'step-check-schedule',
        order: 1,
        moduleTarget: AssistantModuleTarget.agenda,
        intendedAction: 'checkSchedule',
        description: 'Consultar Agenda',
        status: resolved.status,
        risks: const [
          AssistantExecutionRisk(
            id: 'risk-schedule-read',
            description: 'Consulta somente leitura à agenda',
            severity: 'low',
          ),
        ],
        confirmationPolicy: AssistantConfirmationPolicy.none,
        blockReason: resolved.reason,
      ),
    ];
  }

  List<AssistantExecutionStep> _buildSearchClientFlow(
    AssistantResponse response,
  ) {
    final hasClient = (response.eventDraft?.clientName?.isNotEmpty ?? false) ||
        response.entities
            .any((e) => e.type == AssistantEntityType.clientName);
    final req = AssistantExecutionRequirement(
      id: 'req-client',
      description: 'Nome do cliente informado',
      satisfied: hasClient,
    );
    final resolved = _resolve(
      canPlan: _capabilities.canPlanSearchClient,
      canExecute: _capabilities.canExecuteClientSearch,
      preconditionsMet: hasClient,
      dependenciesSatisfied: true,
      confirmationPolicy: AssistantConfirmationPolicy.none,
      stepId: 'step-search-client',
      planFlag: 'canPlanSearchClient',
      executeFlag: 'canExecuteClientSearch',
      gapReason: hasClient ? null : 'Nome do cliente ausente',
    );
    return [
      AssistantExecutionStep(
        id: 'step-search-client',
        order: 1,
        moduleTarget: AssistantModuleTarget.clients,
        intendedAction: 'searchClient',
        description: 'Buscar Cliente',
        status: resolved.status,
        preconditions: [req],
        risks: const [
          AssistantExecutionRisk(
            id: 'risk-client-read',
            description: 'Consulta somente leitura a clientes',
            severity: 'low',
          ),
        ],
        confirmationPolicy: AssistantConfirmationPolicy.none,
        blockReason: resolved.reason,
      ),
    ];
  }

  List<AssistantExecutionStep> _buildUpdateEventFlow(
    AssistantResponse response,
  ) {
    final dateOk = response.eventDraft?.date != null;
    final resolved = _resolve(
      canPlan: _capabilities.canPlanCreateEvent,
      canExecute: _capabilities.canExecuteCreateEvent,
      preconditionsMet: dateOk,
      dependenciesSatisfied: true,
      confirmationPolicy: AssistantConfirmationPolicy.requiredBeforeWrite,
      stepId: 'step-update-event',
      planFlag: 'canPlanCreateEvent',
      executeFlag: 'canExecuteCreateEvent',
      gapReason: dateOk ? null : 'Data ausente',
    );
    return [
      AssistantExecutionStep(
        id: 'step-update-event',
        order: 1,
        moduleTarget: AssistantModuleTarget.events,
        intendedAction: 'updateEvent',
        description: 'Atualizar Evento',
        status: resolved.status,
        preconditions: [
          AssistantExecutionRequirement(
            id: 'req-date',
            description: 'Data do evento informada',
            satisfied: dateOk,
          ),
        ],
        risks: const [
          AssistantExecutionRisk(
            id: 'risk-event-update',
            description: 'Alteraria um evento existente se fosse executado',
            severity: 'high',
          ),
        ],
        confirmationPolicy: AssistantConfirmationPolicy.requiredBeforeWrite,
        blockReason: resolved.reason,
      ),
    ];
  }

  /// Priority: plan off → unavailable; gaps/deps → blocked; execute off →
  /// unavailable; confirmation pending → awaitingConfirmation; else ready.
  _ResolvedStep _resolve({
    required bool canPlan,
    required bool canExecute,
    required bool preconditionsMet,
    required bool dependenciesSatisfied,
    required AssistantConfirmationPolicy confirmationPolicy,
    required String stepId,
    required String planFlag,
    required String executeFlag,
    required String? gapReason,
    String? unmetDependencyReason,
  }) {
    if (!canPlan) {
      return _ResolvedStep(
        status: AssistantExecutionStatus.unavailable,
        reason: 'Planejamento desabilitado: $planFlag=false',
      );
    }
    if (!preconditionsMet) {
      return _ResolvedStep(
        status: AssistantExecutionStatus.blocked,
        reason: gapReason ?? 'Pré-condições não satisfeitas',
      );
    }
    if (!dependenciesSatisfied) {
      return _ResolvedStep(
        status: AssistantExecutionStatus.blocked,
        reason: unmetDependencyReason ?? 'Dependência não satisfeita',
      );
    }
    if (!canExecute) {
      return _ResolvedStep(
        status: AssistantExecutionStatus.unavailable,
        reason: 'Executor indisponível: $executeFlag=false',
      );
    }
    final needsConfirmation =
        confirmationPolicy != AssistantConfirmationPolicy.none;
    final confirmed = _confirmedStepIds.contains(stepId);
    if (needsConfirmation && !confirmed) {
      return const _ResolvedStep(
        status: AssistantExecutionStatus.awaitingConfirmation,
        reason: null,
      );
    }
    return const _ResolvedStep(
      status: AssistantExecutionStatus.ready,
      reason: null,
    );
  }

  static bool _dependencyAllowsProgress(AssistantExecutionStatus status) {
    return status == AssistantExecutionStatus.ready ||
        status == AssistantExecutionStatus.awaitingConfirmation;
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

  static String _summary({
    required AssistantIntentType intent,
    required List<AssistantExecutionStep> steps,
  }) {
    if (steps.isEmpty) {
      return 'Nenhum passo planejado para a intenção ${intent.name}. '
          'Nenhuma ação executável.';
    }
    final blocked = steps.where((s) => s.isBlocked).length;
    final unavailable = steps.where((s) => s.isUnavailable).length;
    return 'Plano com ${steps.length} passo(s); '
        '$blocked bloqueado(s); $unavailable indisponível(is). '
        'Nenhuma operação será executada.';
  }

  static String _capitalize(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}

class _ResolvedStep {
  const _ResolvedStep({required this.status, required this.reason});

  final AssistantExecutionStatus status;
  final String? reason;
}
