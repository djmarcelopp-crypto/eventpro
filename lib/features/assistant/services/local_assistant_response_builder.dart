import '../domain/assistant_response_builder.dart';
import '../models/assistant_action.dart';
import '../models/assistant_action_type.dart';
import '../models/assistant_confidence.dart';
import '../models/assistant_entity.dart';
import '../models/assistant_event_draft.dart';
import '../models/assistant_intent.dart';
import '../models/assistant_intent_type.dart';
import '../models/assistant_parse_issue.dart';
import '../models/assistant_parse_result.dart';
import '../models/assistant_provenance.dart';
import '../models/assistant_question.dart';
import '../models/assistant_quote_draft.dart';
import '../models/assistant_request.dart';
import '../models/assistant_response.dart';
import '../models/assistant_suggestion.dart';
import 'assistant_missing_info_analyzer.dart';

class LocalAssistantResponseBuilder implements AssistantResponseBuilder {
  @override
  AssistantResponse build({
    required AssistantRequest request,
    required AssistantParseResult parseResult,
    required AssistantIntent primaryIntent,
    required List<AssistantIntent> alternativeIntents,
    required AssistantEventDraft eventDraft,
    required AssistantQuoteDraft quoteDraft,
    required List<AssistantEntity> entities,
    required List<AssistantParseIssue> issues,
  }) {
    final questions = AssistantMissingInfoAnalyzer.analyze(
      intent: primaryIntent.type,
      eventDraft: eventDraft,
      quoteDraft: quoteDraft,
      issues: issues,
    );

    final canCreate = questions.isEmpty &&
        (primaryIntent.type == AssistantIntentType.createQuote ||
            primaryIntent.type == AssistantIntentType.createEvent);

    final actions = <AssistantAction>[
      const AssistantAction(
        type: AssistantActionType.reviewDraft,
        available: true,
        label: 'Revisar rascunho',
      ),
      if (primaryIntent.type == AssistantIntentType.createQuote)
        AssistantAction(
          type: AssistantActionType.createQuote,
          available: canCreate,
          label: 'Criar orçamento',
          blockedReason: canCreate
              ? null
              : 'Informações essenciais ausentes ou ambíguas',
        ),
      if (primaryIntent.type == AssistantIntentType.createEvent)
        AssistantAction(
          type: AssistantActionType.createEvent,
          available: canCreate,
          label: 'Criar evento',
          blockedReason: canCreate
              ? null
              : 'Informações essenciais ausentes ou ambíguas',
        ),
      if (questions.isNotEmpty)
        const AssistantAction(
          type: AssistantActionType.askQuestion,
          available: true,
          label: 'Responder perguntas pendentes',
        ),
    ];

    final suggestions = <AssistantSuggestion>[
      for (final alt in alternativeIntents.take(2))
        AssistantSuggestion(
          id: 'alt-${alt.type.name}',
          message: 'Também pode significar ${_label(alt.type)}.',
          provenance: AssistantProvenance.suggested,
        ),
      if (eventDraft.date == null)
        const AssistantSuggestion(
          id: 'need-date',
          message: 'Informe a data para avançar com segurança.',
          provenance: AssistantProvenance.missing,
        ),
    ];

    final overall = AssistantConfidence.fromScore(
      _overallScore(
        primaryIntent: primaryIntent,
        eventDraft: eventDraft,
        questions: questions,
        issues: issues,
      ),
      reasons: [
        'Intenção: ${primaryIntent.type.name}',
        if (questions.isNotEmpty) 'Há perguntas pendentes',
        if (issues.any((i) => i.type.name == 'conflicting'))
          'Há conflitos no texto',
      ],
      evidences: [
        for (final entity in entities.take(6))
          '${entity.type.name}:${entity.rawValue}',
      ],
    );

    return AssistantResponse(
      requestId: request.id,
      rawText: request.rawText,
      primaryIntent: primaryIntent,
      alternativeIntents: alternativeIntents,
      entities: entities,
      eventDraft: eventDraft,
      quoteDraft: quoteDraft,
      questions: questions,
      suggestions: suggestions,
      issues: issues,
      overallConfidence: overall,
      actions: actions,
      friendlyMessage: _friendlyMessage(
        primaryIntent: primaryIntent,
        eventDraft: eventDraft,
        quoteDraft: quoteDraft,
        questions: questions,
      ),
    );
  }

  static double _overallScore({
    required AssistantIntent primaryIntent,
    required AssistantEventDraft eventDraft,
    required List<AssistantQuestion> questions,
    required List<AssistantParseIssue> issues,
  }) {
    var score = primaryIntent.confidence.score;
    score = (score + eventDraft.confidence.score) / 2;
    if (questions.isNotEmpty) score -= 0.12 * questions.length;
    if (issues.any((i) => i.type.name == 'conflicting')) score -= 0.15;
    return score.clamp(0.0, 1.0).toDouble();
  }

  static String _friendlyMessage({
    required AssistantIntent primaryIntent,
    required AssistantEventDraft eventDraft,
    required AssistantQuoteDraft quoteDraft,
    required List<AssistantQuestion> questions,
  }) {
    final parts = <String>[
      'Interpretei o texto como ${_label(primaryIntent.type)}.',
    ];
    if (eventDraft.eventType != null) {
      parts.add('Evento: ${eventDraft.eventType}.');
    }
    if (eventDraft.guestCount != null) {
      parts.add('Público: ${eventDraft.guestCount} pessoas.');
    }
    if (eventDraft.city != null) {
      parts.add('Cidade: ${eventDraft.city}.');
    }
    if (!quoteDraft.isEmpty) {
      final keywords = <String>{
        ...quoteDraft.serviceKeywords,
        ...quoteDraft.equipmentKeywords,
      }.toList(growable: false);
      parts.add('Itens citados: ${keywords.take(5).join(', ')}.');
    }
    if (questions.isNotEmpty) {
      parts.add(
        'Ainda preciso esclarecer: ${questions.map((q) => q.prompt).join(' ')}',
      );
    }
    parts.add('Não criei nenhum registro no sistema — apenas um rascunho.');
    return parts.join(' ');
  }

  static String _label(AssistantIntentType type) {
    return switch (type) {
      AssistantIntentType.createEvent => 'criação de evento',
      AssistantIntentType.createQuote => 'criação de orçamento',
      AssistantIntentType.checkSchedule => 'consulta de agenda',
      AssistantIntentType.checkAvailability => 'consulta de disponibilidade',
      AssistantIntentType.searchClient => 'busca de cliente',
      AssistantIntentType.updateEvent => 'atualização de evento',
      AssistantIntentType.unknown => 'intenção não identificada',
    };
  }
}
