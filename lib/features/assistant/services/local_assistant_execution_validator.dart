import '../domain/assistant_execution_validator.dart';
import '../models/assistant_execution_mode.dart';
import '../models/assistant_execution_request.dart';
import 'assistant_capabilities.dart';

/// Deterministic validator for the controlled execution pipeline.
class LocalAssistantExecutionValidator implements AssistantExecutionValidator {
  const LocalAssistantExecutionValidator({
    required this.capabilities,
  });

  final AssistantCapabilities capabilities;

  @override
  AssistantExecutionValidationResult validate(AssistantExecutionRequest request) {
    final issues = <String>[];
    final context = request.context;
    final plan = request.plan;
    final policy = context.policy;

    if (!policy.allows(context.mode)) {
      issues.add('Modo ${context.mode.name} não permitido pela policy');
    }

    if (context.mode == AssistantExecutionMode.production) {
      if (!policy.allowRestrictedQuoteDraftProduction) {
        issues.add('Modo production é reservado e bloqueado fora da exceção AI-006');
      } else if (!capabilities.canExecuteCreateQuote) {
        issues.add(
          'Production restrita exige canExecuteCreateQuote=true',
        );
      } else if (capabilities.canExecuteCreateEvent) {
        issues.add(
          'Production restrita não permite canExecuteCreateEvent',
        );
      }
    }

    if (capabilities.anyWriteExecutionEnabled &&
        context.mode != AssistantExecutionMode.production) {
      issues.add(
        'Escrita habilitada nas capabilities — dryRun/simulation exigem writes off',
      );
    }

    if (context.integrationMode != capabilities.integrationMode) {
      issues.add('integrationMode do contexto diverge das capabilities');
    }

    final ids = <String>{};
    final orders = <int>{};
    for (final step in plan.steps) {
      if (!ids.add(step.id)) {
        issues.add('ID de passo duplicado: ${step.id}');
      }
      if (!orders.add(step.order)) {
        issues.add('Ordem de passo duplicada: ${step.order}');
      }
      for (final dep in step.dependencyStepIds) {
        if (dep == step.id) {
          issues.add('Passo ${step.id} depende de si próprio');
        }
        if (!plan.steps.any((s) => s.id == dep)) {
          issues.add('Dependência inexistente $dep em ${step.id}');
        }
      }
    }

    if (issues.isNotEmpty) {
      return AssistantExecutionValidationResult.invalid(issues);
    }
    return AssistantExecutionValidationResult.ok();
  }
}
