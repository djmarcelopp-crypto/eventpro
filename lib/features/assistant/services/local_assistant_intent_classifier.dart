import '../domain/assistant_intent_classifier.dart';
import '../models/assistant_confidence.dart';
import '../models/assistant_entity_type.dart';
import '../models/assistant_intent.dart';
import '../models/assistant_intent_type.dart';
import '../models/assistant_parse_result.dart';
import '../models/assistant_request.dart';
import '../utils/assistant_text_normalizer.dart';

/// Deterministic intent classifier with documented precedence.
///
/// Precedence:
/// 1. Explicit query verbs (agenda / disponibilidade / procurar / alterar)
/// 2. Explicit creation verbs (criar evento / agendar)
/// 3. Quote commercial cues (orçamento / cotação / valor)
/// 4. Event description without verbs → createQuote (commercial draft) with
///    createEvent as alternative suggestion
/// 5. unknown
class LocalAssistantIntentClassifier implements AssistantIntentClassifier {
  @override
  List<AssistantIntent> classify({
    required AssistantRequest request,
    required AssistantParseResult parseResult,
  }) {
    final folded = AssistantTextNormalizer.fold(request.rawText);
    final intents = <AssistantIntent>[];

    void add(
      AssistantIntentType type,
      double score, {
      required List<String> evidences,
      List<String> reasons = const [],
    }) {
      intents.add(
        AssistantIntent(
          type: type,
          confidence: AssistantConfidence.fromScore(
            score,
            evidences: evidences,
            reasons: reasons,
          ),
          evidences: evidences,
        ),
      );
    }

    if (_hasAny(folded, const [
      'disponivel',
      'disponibilidade',
      'tem equipamento',
      'ha equipamento',
      'há equipamento',
    ])) {
      add(
        AssistantIntentType.checkAvailability,
        0.9,
        evidences: const ['consulta de disponibilidade'],
      );
    }

    if (_hasAny(folded, const [
      'agenda',
      'como esta minha agenda',
      'como está minha agenda',
      'tenho compromisso',
      'estou livre',
    ])) {
      add(
        AssistantIntentType.checkSchedule,
        0.88,
        evidences: const ['consulta de agenda'],
      );
    }

    if (_hasAny(folded, const [
      'procure o cliente',
      'procurar cliente',
      'busque o cliente',
      'buscar cliente',
      'encontre o cliente',
    ])) {
      add(
        AssistantIntentType.searchClient,
        0.9,
        evidences: const ['busca de cliente'],
      );
    }

    if (_hasAny(folded, const [
      'altere',
      'alterar',
      'mude',
      'mudar',
      'atualize',
      'atualizar',
    ]) &&
        _hasAny(folded, const ['evento', 'horario', 'horário', 'data'])) {
      add(
        AssistantIntentType.updateEvent,
        0.85,
        evidences: const ['alteração de evento'],
      );
    }

    final explicitEvent = _hasAny(folded, const [
      'criar evento',
      'agendar evento',
      'marque um evento',
      'marcar evento',
    ]);
    final quoteCue = _hasAny(folded, const [
      'orcamento',
      'orçamento',
      'cotacao',
      'cotação',
      'valor',
      'proposta comercial',
    ]);

    if (explicitEvent) {
      add(
        AssistantIntentType.createEvent,
        0.86,
        evidences: const ['verbo explícito de criação de evento'],
      );
    }
    if (quoteCue) {
      add(
        AssistantIntentType.createQuote,
        0.87,
        evidences: const ['termo comercial de orçamento/cotação'],
      );
    }

    final hasEventSignal = parseResult.entities.any(
      (e) =>
          e.type == AssistantEntityType.eventType ||
          e.type == AssistantEntityType.guestCount ||
          e.type == AssistantEntityType.equipment ||
          e.type == AssistantEntityType.service,
    );

    if (!explicitEvent && !quoteCue && hasEventSignal) {
      add(
        AssistantIntentType.createQuote,
        0.62,
        evidences: const ['descrição de evento/serviço sem verbo explícito'],
        reasons: const [
          'Intenção implícita: rascunho comercial (createQuote)',
        ],
      );
      add(
        AssistantIntentType.createEvent,
        0.48,
        evidences: const ['alternativa: possível criação de evento'],
        reasons: const ['Sugestão alternativa sem certeza absoluta'],
      );
    }

    if (intents.isEmpty) {
      add(
        AssistantIntentType.unknown,
        0.2,
        evidences: const ['nenhuma intenção reconhecida'],
      );
    }

    intents.sort((a, b) => b.confidence.score.compareTo(a.confidence.score));
    return List.unmodifiable(intents);
  }

  static bool _hasAny(String folded, List<String> needles) {
    for (final needle in needles) {
      if (folded.contains(AssistantTextNormalizer.fold(needle))) return true;
    }
    return false;
  }
}
