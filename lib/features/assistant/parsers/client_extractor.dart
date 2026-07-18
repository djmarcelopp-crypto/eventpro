import '../models/assistant_confidence.dart';
import '../models/assistant_entity.dart';
import '../models/assistant_entity_type.dart';
import '../models/assistant_provenance.dart';

/// Extracts client / contractor name patterns.
abstract class ClientExtractor {
  static final _patterns = <RegExp>[
    RegExp(
      r'\bcliente\s+([A-ZÁÉÍÓÚ][\wÁ-ú]+(?:\s+[A-ZÁÉÍÓÚ][\wÁ-ú]+){0,3})',
    ),
    RegExp(
      r'\bpara a empresa\s+([A-ZÁÉÍÓÚ0-9][\wÁ-ú0-9&]+(?:\s+[A-ZÁÉÍÓÚ0-9][\wÁ-ú0-9&]+){0,4})',
      caseSensitive: false,
    ),
    RegExp(
      r'\bevento d[ao]\s+([A-ZÁÉÍÓÚ][\wÁ-ú]+(?:\s+[A-ZÁÉÍÓÚ][\wÁ-ú]+){0,2})',
      caseSensitive: false,
    ),
    RegExp(
      r'\bcontratante\s+([A-ZÁÉÍÓÚ0-9][\wÁ-ú0-9]+(?:\s+[A-ZÁÉÍÓÚ0-9][\wÁ-ú0-9]+){0,3})',
      caseSensitive: false,
    ),
  ];

  static List<AssistantEntity> extract(String text) {
    final entities = <AssistantEntity>[];
    for (final pattern in _patterns) {
      for (final match in pattern.allMatches(text)) {
        final name = match.group(1)!.trim();
        entities.add(
          AssistantEntity(
            type: AssistantEntityType.clientName,
            rawValue: name,
            normalizedValue: name,
            provenance: AssistantProvenance.extracted,
            confidence: AssistantConfidence.fromScore(
              0.8,
              evidences: [match.group(0)!],
            ),
            sourceSpan: match.group(0),
          ),
        );
      }
    }
    return entities;
  }
}
