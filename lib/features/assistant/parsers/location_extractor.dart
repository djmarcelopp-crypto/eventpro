import '../models/assistant_confidence.dart';
import '../models/assistant_entity.dart';
import '../models/assistant_entity_type.dart';
import '../models/assistant_provenance.dart';

/// Extracts city / venue phrases using linguistic patterns (not a city catalog).
abstract class LocationExtractor {
  static final _cityPatterns = <RegExp>[
    RegExp(
      r'\b(?:na cidade de|em|no municipio de|no município de)\s+([A-ZÁÉÍÓÚÂÊÔÃÕÇ][\wÁ-ú]+(?:\s+[A-ZÁÉÍÓÚÂÊÔÃÕÇ][\wÁ-ú]+){0,2})',
    ),
    RegExp(
      r'\bem\s+([a-záéíóúâêôãõç]+(?:\s+[a-záéíóúâêôãõç]+){0,2})\b',
      caseSensitive: false,
    ),
  ];

  static final _venuePatterns = <RegExp>[
    RegExp(
      r'\b(?:no|na|nos|nas)\s+(center convention|salao|salão|fazenda|espaco|espaço|hotel|clube|igreja|teatro|arena|estadio|estádio|audit[oó]rio)\s+([\wÁ-ú0-9]+(?:\s+[\wÁ-ú0-9]+){0,4})',
      caseSensitive: false,
    ),
    RegExp(
      r'\b(?:no|na)\s+([A-ZÁÉÍÓÚ][\wÁ-ú0-9]+(?:\s+[A-ZÁÉÍÓÚ][\wÁ-ú0-9]+){0,3})\b',
    ),
  ];

  static const _stopCities = {
    'um',
    'uma',
    'meu',
    'minha',
    'seu',
    'sua',
    'som',
    'iluminacao',
    'iluminação',
    'casamento',
    'aniversario',
    'evento',
    'orcamento',
    'orçamento',
  };

  static List<AssistantEntity> extract(String text) {
    final entities = <AssistantEntity>[];

    for (final pattern in _cityPatterns) {
      for (final match in pattern.allMatches(text)) {
        final city = match.group(1)!.trim();
        if (_stopCities.contains(city.toLowerCase())) continue;
        if (city.length < 3) continue;
        entities.add(
          AssistantEntity(
            type: AssistantEntityType.city,
            rawValue: city,
            normalizedValue: _title(city),
            provenance: AssistantProvenance.extracted,
            confidence: AssistantConfidence.fromScore(
              0.75,
              evidences: [match.group(0)!],
            ),
            sourceSpan: match.group(0),
          ),
        );
      }
    }

    for (final pattern in _venuePatterns) {
      for (final match in pattern.allMatches(text)) {
        final venue = match.groupCount >= 2 && match.group(2) != null
            ? '${match.group(1)} ${match.group(2)}'.trim()
            : match.group(1)!.trim();
        entities.add(
          AssistantEntity(
            type: AssistantEntityType.venue,
            rawValue: venue,
            normalizedValue: _title(venue),
            provenance: AssistantProvenance.extracted,
            confidence: AssistantConfidence.fromScore(
              0.7,
              evidences: [match.group(0)!],
            ),
            sourceSpan: match.group(0),
          ),
        );
      }
    }

    return _dedupe(entities);
  }

  static List<AssistantEntity> _dedupe(List<AssistantEntity> input) {
    final seen = <String>{};
    final out = <AssistantEntity>[];
    for (final entity in input) {
      final key = '${entity.type}:${entity.normalizedValue?.toLowerCase()}';
      if (seen.add(key)) out.add(entity);
    }
    return out;
  }

  static String _title(String value) {
    return value
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map((part) {
          final lower = part.toLowerCase();
          return '${lower[0].toUpperCase()}${lower.substring(1)}';
        })
        .join(' ');
  }
}
