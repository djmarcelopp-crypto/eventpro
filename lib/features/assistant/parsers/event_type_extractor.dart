import '../models/assistant_confidence.dart';
import '../models/assistant_entity.dart';
import '../models/assistant_entity_type.dart';
import '../models/assistant_provenance.dart';
import '../utils/assistant_text_normalizer.dart';

/// Recognizes common Brazilian event-type phrases.
abstract class EventTypeExtractor {
  static const _catalog = <String, String>{
    'festa de 15 anos': 'festa de 15 anos',
    'quinze anos': 'festa de 15 anos',
    'debutante': 'debutante',
    'casamento': 'casamento',
    'aniversario': 'aniversário',
    'formatura': 'formatura',
    'congresso': 'congresso',
    'convencao': 'convenção',
    'corporativo': 'corporativo',
    'palestra': 'palestra',
    'show': 'show',
    'festival': 'festival',
    'culto': 'culto',
    'evento gospel': 'evento gospel',
    'feira': 'feira',
    'lancamento': 'lançamento',
    'confraternizacao': 'confraternização',
    'cerimonia': 'cerimônia',
  };

  static List<AssistantEntity> extract(String text) {
    final folded = AssistantTextNormalizer.fold(text);
    final found = <AssistantEntity>[];
    final seen = <String>{};

    final ordered = _catalog.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    for (final key in ordered) {
      if (!folded.contains(key)) continue;
      final label = _catalog[key]!;
      if (!seen.add(label)) continue;
      found.add(
        AssistantEntity(
          type: AssistantEntityType.eventType,
          rawValue: label,
          normalizedValue: label,
          provenance: AssistantProvenance.extracted,
          confidence: AssistantConfidence.fromScore(
            0.9,
            evidences: ['tipo de evento: $label'],
          ),
          sourceSpan: label,
        ),
      );
    }
    return found;
  }
}
