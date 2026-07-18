import '../models/assistant_confidence.dart';
import '../models/assistant_entity.dart';
import '../models/assistant_entity_type.dart';
import '../models/assistant_parse_issue.dart';
import '../models/assistant_parse_issue_type.dart';
import '../models/assistant_provenance.dart';
import '../utils/assistant_text_normalizer.dart';

class GuestCountExtraction {
  const GuestCountExtraction({
    required this.entities,
    this.issues = const [],
  });

  final List<AssistantEntity> entities;
  final List<AssistantParseIssue> issues;
}

/// Extracts guest / audience counts from Portuguese phrases.
abstract class GuestCountExtractor {
  static final _rangePattern = RegExp(
    r'(?:entre|de)\s+(\d{1,3}(?:\.\d{3})*|\d+)\s*(?:a|e|até|-)\s*(\d{1,3}(?:\.\d{3})*|\d+)\s*(?:pessoas|convidados|convidado)',
    caseSensitive: false,
  );

  static final _singlePatterns = <RegExp>[
    RegExp(
      r'(?:aproximadamente|cerca de|por volta de|uns|umas)?\s*(\d{1,3}(?:\.\d{3})*|\d+)\s*(?:pessoas|convidados|convidado)',
      caseSensitive: false,
    ),
    RegExp(
      r'p[uú]blico\s+de\s+(\d{1,3}(?:\.\d{3})*|\d+)',
      caseSensitive: false,
    ),
    RegExp(
      r'para\s+(\d{1,3}(?:\.\d{3})*|\d+)\s*(?:pessoas|convidados|convidado)',
      caseSensitive: false,
    ),
  ];

  static GuestCountExtraction extract(String text) {
    final folded = AssistantTextNormalizer.fold(text);
    final range = _rangePattern.firstMatch(folded);
    if (range != null) {
      final low = _parseInt(range.group(1)!);
      final high = _parseInt(range.group(2)!);
      return GuestCountExtraction(
        entities: [
          AssistantEntity(
            type: AssistantEntityType.guestCount,
            rawValue: '${range.group(0)}',
            normalizedValue: '$low-$high',
            provenance: AssistantProvenance.conflicted,
            confidence: AssistantConfidence.fromScore(
              0.55,
              reasons: ['Faixa de público ambígua'],
              evidences: [range.group(0)!],
            ),
          ),
        ],
        issues: [
          AssistantParseIssue(
            type: AssistantParseIssueType.ambiguous,
            message: 'Quantidade informada como faixa ($low a $high).',
            entityType: AssistantEntityType.guestCount,
            details: ['low=$low', 'high=$high'],
          ),
        ],
      );
    }

    final entities = <AssistantEntity>[];
    for (final pattern in _singlePatterns) {
      for (final match in pattern.allMatches(folded)) {
        final value = _parseInt(match.group(1)!);
        entities.add(
          AssistantEntity(
            type: AssistantEntityType.guestCount,
            rawValue: match.group(0)!,
            normalizedValue: '$value',
            provenance: AssistantProvenance.extracted,
            confidence: AssistantConfidence.fromScore(
              0.88,
              evidences: [match.group(0)!],
            ),
            sourceSpan: match.group(0),
          ),
        );
      }
    }

    if (entities.length > 1) {
      final values = entities.map((e) => e.normalizedValue).toSet();
      if (values.length > 1) {
        return GuestCountExtraction(
          entities: entities,
          issues: [
            const AssistantParseIssue(
              type: AssistantParseIssueType.conflicting,
              message: 'Foram encontradas quantidades de público conflitantes.',
              entityType: AssistantEntityType.guestCount,
            ),
          ],
        );
      }
    }

    return GuestCountExtraction(entities: entities);
  }

  static int _parseInt(String raw) {
    return int.parse(raw.replaceAll('.', ''));
  }
}
