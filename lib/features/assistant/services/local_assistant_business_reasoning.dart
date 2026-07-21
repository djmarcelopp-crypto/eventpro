import '../domain/business/reasoning/assistant_business_reasoning.dart';
import '../domain/business/reasoning/business_reasoning_confidence.dart';
import '../domain/business/reasoning/business_reasoning_decision.dart';
import '../domain/business/reasoning/business_reasoning_issue.dart';
import '../domain/business/reasoning/business_reasoning_metadata.dart';
import '../domain/business/reasoning/business_reasoning_request.dart';
import '../domain/business/reasoning/business_reasoning_result.dart';
import '../domain/business/reasoning/business_reasoning_suggestion.dart';

/// Deterministic Business Reasoning engine (AI-023) — rules only, no LLM/NLP/HTTP.
class LocalAssistantBusinessReasoning implements AssistantBusinessReasoning {
  const LocalAssistantBusinessReasoning();

  @override
  Future<BusinessReasoningResult> evaluate(
    BusinessReasoningRequest request,
  ) async {
    final issues = <BusinessReasoningIssue>[
      ..._missingIssues(request),
      ..._entityIssues(request),
      ..._lifecycleIssues(request),
      ..._dependencyIssues(request),
      ..._conflictIssues(request),
      ..._flowIssues(request),
    ];

    final decision = _decide(request, issues);
    final suggestions = _suggestionsFor(request, issues, decision);
    final meta = BusinessReasoningMetadata(
      correlationId: request.metadata.correlationId ?? request.requestId,
      sessionId: request.metadata.sessionId,
      engineVersion: request.metadata.engineVersion,
      evaluatedAt: DateTime.now().toUtc(),
      tags: request.metadata.tags,
    );
    final result = BusinessReasoningResult(
      requestId: request.requestId,
      request: request,
      decision: decision,
      issues: List.unmodifiable(issues),
      suggestions: List.unmodifiable(suggestions),
      explanations: _buildExplanations(decision, issues),
      metadata: meta,
    );
    return result;
  }

  @override
  Future<BusinessReasoningResult> validate(
    BusinessReasoningRequest request,
  ) async {
    final issues = [
      ..._missingIssues(request),
      ..._lifecycleIssues(request),
    ];
    final decision = _decide(request, issues);
    return BusinessReasoningResult(
      requestId: request.requestId,
      request: request,
      decision: decision,
      issues: issues,
      suggestions: _suggestionsFor(request, issues, decision),
      explanations: _buildExplanations(decision, issues),
      metadata: request.metadata,
    );
  }

  @override
  Future<BusinessReasoningResult> detectConflicts(
    BusinessReasoningRequest request,
  ) async {
    final issues = _conflictIssues(request);
    final decision = issues.isEmpty
        ? BusinessReasoningDecision(
            kind: BusinessReasoningDecisionKind.proceed,
            reason: 'Nenhum conflito entre comandos detectado.',
            confidence: BusinessReasoningConfidence.high,
            appliedRules: const ['rule.conflict.none'],
          )
        : _decide(request, issues);
    return BusinessReasoningResult(
      requestId: request.requestId,
      request: request,
      decision: decision,
      issues: issues,
      suggestions: _suggestionsFor(request, issues, decision),
      explanations: _buildExplanations(decision, issues),
      metadata: request.metadata,
    );
  }

  @override
  Future<BusinessReasoningResult> detectMissingInformation(
    BusinessReasoningRequest request,
  ) async {
    final issues = _missingIssues(request);
    final decision = issues.isEmpty
        ? const BusinessReasoningDecision(
            kind: BusinessReasoningDecisionKind.proceed,
            reason: 'Informações obrigatórias presentes.',
            confidence: BusinessReasoningConfidence.high,
            appliedRules: ['rule.missing.none'],
          )
        : _decide(request, issues);
    return BusinessReasoningResult(
      requestId: request.requestId,
      request: request,
      decision: decision,
      issues: issues,
      suggestions: _suggestionsFor(request, issues, decision),
      explanations: _buildExplanations(decision, issues),
      metadata: request.metadata,
    );
  }

  @override
  Future<List<BusinessReasoningSuggestion>> suggestNextAction(
    BusinessReasoningRequest request,
  ) async {
    final evaluated = await evaluate(request);
    return evaluated.suggestions;
  }

  @override
  Future<List<String>> explainDecision(BusinessReasoningResult result) async {
    return result.explanations.isNotEmpty
        ? result.explanations
        : _buildExplanations(result.decision, result.issues);
  }

  List<BusinessReasoningIssue> _missingIssues(BusinessReasoningRequest r) {
    final out = <BusinessReasoningIssue>[];
    for (final field in r.missingRequiredFields) {
      out.add(
        BusinessReasoningIssue(
          code: BusinessReasoningIssueCode.requiredDataMissing,
          message: 'Dado obrigatório ausente: $field.',
          severity: BusinessReasoningIssueSeverity.warning,
          evidence: ['missingField:$field'],
          ruleId: 'rule.required.$field',
        ),
      );
    }
    final needsClient = r.commandIds.any(
          (c) =>
              c.contains('create_quote') ||
              c.contains('CREATE_QUOTE') ||
              c.contains('open_event'),
        ) ||
        (r.intentLabel?.contains('quote') ?? false) ||
        (r.intentLabel?.contains('orçamento') ?? false);
    if (needsClient &&
        !r.clientFound &&
        (r.clientId == null || r.clientId!.isEmpty) &&
        r.clientCandidateCount == 0) {
      out.add(
        const BusinessReasoningIssue(
          code: BusinessReasoningIssueCode.clientMissing,
          message: 'Cliente obrigatório ausente para a operação.',
          severity: BusinessReasoningIssueSeverity.warning,
          evidence: ['clientRequired'],
          ruleId: 'rule.client.required',
        ),
      );
    }
    if (out.isNotEmpty &&
        !out.any(
          (i) => i.code == BusinessReasoningIssueCode.insufficientInformation,
        )) {
      out.add(
        BusinessReasoningIssue(
          code: BusinessReasoningIssueCode.insufficientInformation,
          message: 'Informação insuficiente para prosseguir com segurança.',
          severity: BusinessReasoningIssueSeverity.warning,
          evidence: out.map((i) => i.code.name).toList(),
          ruleId: 'rule.insufficient',
        ),
      );
    }
    return out;
  }

  List<BusinessReasoningIssue> _entityIssues(BusinessReasoningRequest r) {
    final out = <BusinessReasoningIssue>[];
    if (r.gatewayAmbiguous || r.clientCandidateCount > 1) {
      out.add(
        BusinessReasoningIssue(
          code: BusinessReasoningIssueCode.clientAmbiguous,
          message: 'Múltiplos clientes candidatos — resolução necessária.',
          severity: BusinessReasoningIssueSeverity.warning,
          evidence: [
            'clientCandidateCount:${r.clientCandidateCount}',
            if (r.gatewayAmbiguous) 'gatewayAmbiguous:true',
          ],
          ruleId: 'rule.client.ambiguous',
        ),
      );
    }
    if ((r.clientLabel != null && r.clientLabel!.trim().isNotEmpty) &&
        !r.clientFound &&
        r.clientCandidateCount == 0 &&
        (r.clientId == null || r.clientId!.isEmpty)) {
      out.add(
        BusinessReasoningIssue(
          code: BusinessReasoningIssueCode.clientNotFound,
          message: 'Cliente inexistente para "${r.clientLabel}".',
          severity: BusinessReasoningIssueSeverity.error,
          evidence: ['clientLabel:${r.clientLabel}'],
          ruleId: 'rule.client.not_found',
        ),
      );
    }
    final needsEvent = r.commandIds.any(
      (c) => c.contains('OPEN_EVENT') || c.contains('open_event'),
    );
    if (needsEvent && !r.eventFound && (r.eventId == null || r.eventId!.isEmpty)) {
      out.add(
        const BusinessReasoningIssue(
          code: BusinessReasoningIssueCode.eventNotFound,
          message: 'Evento inexistente ou não informado.',
          severity: BusinessReasoningIssueSeverity.error,
          evidence: ['eventRequired'],
          ruleId: 'rule.event.not_found',
        ),
      );
    }
    return out;
  }

  List<BusinessReasoningIssue> _lifecycleIssues(BusinessReasoningRequest r) {
    final out = <BusinessReasoningIssue>[];
    if (r.quoteStatus == BusinessReasoningQuoteStatus.closed) {
      out.add(
        BusinessReasoningIssue(
          code: BusinessReasoningIssueCode.quoteClosed,
          message: 'Orçamento fechado — operação bloqueada.',
          severity: BusinessReasoningIssueSeverity.blocker,
          evidence: ['quoteId:${r.quoteId ?? "unknown"}', 'status:closed'],
          ruleId: 'rule.quote.closed',
        ),
      );
    }
    if (r.contractStatus == BusinessReasoningContractStatus.cancelled) {
      out.add(
        BusinessReasoningIssue(
          code: BusinessReasoningIssueCode.contractCancelled,
          message: 'Contrato cancelado — operação inválida.',
          severity: BusinessReasoningIssueSeverity.blocker,
          evidence: [
            'contractId:${r.contractId ?? "unknown"}',
            'status:cancelled',
          ],
          ruleId: 'rule.contract.cancelled',
        ),
      );
    }
    return out;
  }

  List<BusinessReasoningIssue> _dependencyIssues(BusinessReasoningRequest r) {
    return [
      for (final dep in r.pendingDependencies)
        BusinessReasoningIssue(
          code: BusinessReasoningIssueCode.pendingDependency,
          message: 'Dependência pendente: $dep.',
          severity: BusinessReasoningIssueSeverity.warning,
          evidence: ['dependency:$dep'],
          ruleId: 'rule.dependency.pending',
        ),
    ];
  }

  List<BusinessReasoningIssue> _conflictIssues(BusinessReasoningRequest r) {
    if (r.conflictingCommandIds.length < 2) return const [];
    return [
      BusinessReasoningIssue(
        code: BusinessReasoningIssueCode.commandConflict,
        message:
            'Conflito entre comandos: ${r.conflictingCommandIds.join(", ")}.',
        severity: BusinessReasoningIssueSeverity.error,
        evidence: r.conflictingCommandIds.map((c) => 'command:$c').toList(),
        ruleId: 'rule.command.conflict',
      ),
    ];
  }

  List<BusinessReasoningIssue> _flowIssues(BusinessReasoningRequest r) {
    final out = <BusinessReasoningIssue>[];
    // Invalid flow: cancel/close without confirmation when flagged.
    final risky = r.commandIds.any(
      (c) =>
          c.toLowerCase().contains('cancel') ||
          c.toLowerCase().contains('close') ||
          c.toLowerCase().contains('delete'),
    );
    if (risky && !r.requiresConfirmation) {
      out.add(
        const BusinessReasoningIssue(
          code: BusinessReasoningIssueCode.invalidFlow,
          message: 'Fluxo inválido: ação destrutiva sem confirmação.',
          severity: BusinessReasoningIssueSeverity.blocker,
          evidence: ['destructiveWithoutConfirmation'],
          ruleId: 'rule.flow.confirm_required',
        ),
      );
    }
    return out;
  }

  BusinessReasoningDecision _decide(
    BusinessReasoningRequest request,
    List<BusinessReasoningIssue> issues,
  ) {
    final rules = issues
        .map((i) => i.ruleId)
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();
    final evidence = issues.expand((i) => i.evidence).toList();

    if (issues.any((i) => i.severity == BusinessReasoningIssueSeverity.blocker)) {
      return BusinessReasoningDecision(
        kind: BusinessReasoningDecisionKind.block,
        reason: 'Bloqueado por regra de negócio.',
        confidence: BusinessReasoningConfidence.certain,
        appliedRules: rules,
        evidence: evidence,
        issues: issues,
      );
    }
    if (issues.any((i) => i.code == BusinessReasoningIssueCode.clientAmbiguous)) {
      return BusinessReasoningDecision(
        kind: BusinessReasoningDecisionKind.resolveAmbiguity,
        reason: 'Ambiguidade de entidade — escolha do usuário necessária.',
        confidence: BusinessReasoningConfidence.high,
        appliedRules: rules,
        evidence: evidence,
        issues: issues,
      );
    }
    if (issues.any((i) => i.code == BusinessReasoningIssueCode.pendingDependency)) {
      return BusinessReasoningDecision(
        kind: BusinessReasoningDecisionKind.satisfyDependency,
        reason: 'Dependências pendentes devem ser resolvidas antes.',
        confidence: BusinessReasoningConfidence.high,
        appliedRules: rules,
        evidence: evidence,
        issues: issues,
      );
    }
    if (issues.any(
      (i) =>
          i.code == BusinessReasoningIssueCode.requiredDataMissing ||
          i.code == BusinessReasoningIssueCode.clientMissing ||
          i.code == BusinessReasoningIssueCode.insufficientInformation,
    )) {
      return BusinessReasoningDecision(
        kind: BusinessReasoningDecisionKind.askUser,
        reason: 'Dados insuficientes — solicitar informação ao usuário.',
        confidence: BusinessReasoningConfidence.high,
        appliedRules: rules,
        evidence: evidence,
        issues: issues,
      );
    }
    if (issues.any((i) => i.severity == BusinessReasoningIssueSeverity.error)) {
      return BusinessReasoningDecision(
        kind: BusinessReasoningDecisionKind.block,
        reason: 'Erro de regra de negócio.',
        confidence: BusinessReasoningConfidence.high,
        appliedRules: rules,
        evidence: evidence,
        issues: issues,
      );
    }
    if (request.requiresConfirmation) {
      return BusinessReasoningDecision(
        kind: BusinessReasoningDecisionKind.confirmRisk,
        reason: 'Confirmação recomendada antes de prosseguir.',
        confidence: BusinessReasoningConfidence.medium,
        appliedRules: [...rules, 'rule.confirm.recommended'],
        evidence: evidence,
        issues: issues,
      );
    }
    return BusinessReasoningDecision(
      kind: BusinessReasoningDecisionKind.proceed,
      reason: 'Regras satisfeitas — pode avançar.',
      confidence: BusinessReasoningConfidence.high,
      appliedRules: rules.isEmpty ? const ['rule.ok'] : rules,
      evidence: evidence,
      issues: issues,
    );
  }

  List<BusinessReasoningSuggestion> _suggestionsFor(
    BusinessReasoningRequest request,
    List<BusinessReasoningIssue> issues,
    BusinessReasoningDecision decision,
  ) {
    final out = <BusinessReasoningSuggestion>[];
    for (final issue in issues) {
      switch (issue.code) {
        case BusinessReasoningIssueCode.clientMissing:
        case BusinessReasoningIssueCode.clientNotFound:
          out.add(
            const BusinessReasoningSuggestion(
              code: 'suggest.select_client',
              message: 'Selecione um cliente.',
              priority: 10,
              relatedIssueCodes: ['clientMissing', 'clientNotFound'],
            ),
          );
        case BusinessReasoningIssueCode.clientAmbiguous:
          out.add(
            const BusinessReasoningSuggestion(
              code: 'suggest.choose_client_candidate',
              message: 'Escolha um dos clientes encontrados.',
              priority: 20,
              relatedIssueCodes: ['clientAmbiguous'],
            ),
          );
        case BusinessReasoningIssueCode.eventMissing:
        case BusinessReasoningIssueCode.eventNotFound:
          out.add(
            const BusinessReasoningSuggestion(
              code: 'suggest.choose_event',
              message: 'Escolha um dos eventos encontrados.',
              priority: 15,
              relatedIssueCodes: ['eventMissing', 'eventNotFound'],
            ),
          );
        case BusinessReasoningIssueCode.quoteClosed:
          out.add(
            const BusinessReasoningSuggestion(
              code: 'suggest.finalize_quote_first',
              message: 'Finalize o orçamento primeiro.',
              priority: 30,
              relatedIssueCodes: ['quoteClosed'],
            ),
          );
        case BusinessReasoningIssueCode.contractCancelled:
          out.add(
            const BusinessReasoningSuggestion(
              code: 'suggest.contract_cancelled',
              message: 'Contrato cancelado — escolha outro contrato ativo.',
              priority: 30,
              relatedIssueCodes: ['contractCancelled'],
            ),
          );
        case BusinessReasoningIssueCode.pendingDependency:
          out.add(
            BusinessReasoningSuggestion(
              code: 'suggest.resolve_dependency',
              message: issue.message,
              priority: 25,
              relatedIssueCodes: const ['pendingDependency'],
            ),
          );
        case BusinessReasoningIssueCode.invalidFlow:
          out.add(
            const BusinessReasoningSuggestion(
              code: 'suggest.confirm_before_cancel',
              message: 'Confirme antes de cancelar.',
              priority: 40,
              relatedIssueCodes: ['invalidFlow'],
            ),
          );
        case BusinessReasoningIssueCode.requiredDataMissing:
          out.add(
            BusinessReasoningSuggestion(
              code: 'suggest.provide_required',
              message: issue.message,
              priority: 12,
              relatedIssueCodes: const ['requiredDataMissing'],
            ),
          );
        case BusinessReasoningIssueCode.commandConflict:
          out.add(
            const BusinessReasoningSuggestion(
              code: 'suggest.resolve_command_conflict',
              message: 'Resolva o conflito entre comandos antes de continuar.',
              priority: 35,
              relatedIssueCodes: ['commandConflict'],
            ),
          );
        case BusinessReasoningIssueCode.insufficientInformation:
          break;
      }
    }
    if (decision.kind == BusinessReasoningDecisionKind.confirmRisk &&
        !out.any((s) => s.code == 'suggest.confirm_before_cancel')) {
      out.add(
        const BusinessReasoningSuggestion(
          code: 'suggest.confirm_before_proceed',
          message: 'Confirme antes de continuar.',
          priority: 5,
        ),
      );
    }
    out.sort((a, b) => b.priority.compareTo(a.priority));
    // Dedupe by code
    final seen = <String>{};
    return [
      for (final s in out)
        if (seen.add(s.code)) s,
    ];
  }

  List<String> _buildExplanations(
    BusinessReasoningDecision decision,
    List<BusinessReasoningIssue> issues,
  ) {
    return [
      'motivo: ${decision.reason}',
      'decisão: ${decision.kind.name}',
      'confiança: ${decision.confidence.name} (${decision.confidence.score})',
      if (decision.appliedRules.isNotEmpty)
        'regras: ${decision.appliedRules.join(", ")}',
      if (decision.evidence.isNotEmpty)
        'evidências: ${decision.evidence.join(", ")}',
      for (final issue in issues)
        'issue:${issue.code.name}:${issue.severity.name}:${issue.message}',
    ];
  }
}
