import '../models/assistant_confidence.dart';
import '../models/assistant_entity.dart';
import '../models/assistant_entity_type.dart';
import '../models/assistant_parse_issue.dart';
import '../models/assistant_parse_issue_type.dart';
import '../models/assistant_provenance.dart';
import '../utils/assistant_text_normalizer.dart';

class TimeExtraction {
  const TimeExtraction({
    required this.entities,
    this.issues = const [],
  });

  final List<AssistantEntity> entities;
  final List<AssistantParseIssue> issues;
}

/// Extracts start/end times from Portuguese time phrases.
abstract class TimeExtractor {
  static final _rangePattern = RegExp(
    r'das?\s+(\d{1,2})(?:h|:)?(\d{2})?\s*(?:as|às|ate|até|-)\s+'
    r'(meia[- ]noite|meio[- ]dia|\d{1,2})(?:h|:)?(\d{2})?',
    caseSensitive: false,
  );

  static final _singlePattern = RegExp(
    r'(?:comeca|começa|comecar|começar|as|às|termino|término|termina)?\s*'
    r'(meia[- ]noite|meio[- ]dia|\d{1,2})(?:h|:)(\d{2})?(?:\s*horas?)?',
    caseSensitive: false,
  );

  static TimeExtraction extract(String text) {
    final folded = AssistantTextNormalizer.fold(text);
    final entities = <AssistantEntity>[];
    final issues = <AssistantParseIssue>[];

    final range = _rangePattern.firstMatch(folded);
    if (range != null) {
      final start = _toHm(range.group(1)!, range.group(2));
      final end = _specialOrHm(range.group(3)!, range.group(4));
      entities.addAll([
        AssistantEntity(
          type: AssistantEntityType.startTime,
          rawValue: range.group(0)!,
          normalizedValue: start,
          provenance: AssistantProvenance.extracted,
          confidence: AssistantConfidence.fromScore(0.9, evidences: [start]),
        ),
        AssistantEntity(
          type: AssistantEntityType.endTime,
          rawValue: range.group(0)!,
          normalizedValue: end,
          provenance: AssistantProvenance.extracted,
          confidence: AssistantConfidence.fromScore(0.9, evidences: [end]),
        ),
      ]);
      if (_hmToMinutes(start) >= _hmToMinutes(end) && end != '00:00') {
        issues.add(
          const AssistantParseIssue(
            type: AssistantParseIssueType.conflicting,
            message: 'Horário de início é posterior ou igual ao de término.',
            entityType: AssistantEntityType.startTime,
          ),
        );
      }
      return TimeExtraction(entities: entities, issues: issues);
    }

    if (folded.contains('meia-noite') || folded.contains('meia noite')) {
      entities.add(
        AssistantEntity(
          type: AssistantEntityType.endTime,
          rawValue: 'meia-noite',
          normalizedValue: '00:00',
          provenance: AssistantProvenance.extracted,
          confidence: AssistantConfidence.fromScore(0.85),
        ),
      );
    }
    if (folded.contains('meio-dia') || folded.contains('meio dia')) {
      entities.add(
        AssistantEntity(
          type: AssistantEntityType.startTime,
          rawValue: 'meio-dia',
          normalizedValue: '12:00',
          provenance: AssistantProvenance.extracted,
          confidence: AssistantConfidence.fromScore(0.85),
        ),
      );
    }

    for (final match in _singlePattern.allMatches(folded)) {
      final token = match.group(1)!;
      if (token.contains('meia') || token.contains('meio')) continue;
      final hm = _toHm(token, match.group(2));
      final isEnd = match.group(0)!.contains('termin');
      entities.add(
        AssistantEntity(
          type: isEnd
              ? AssistantEntityType.endTime
              : AssistantEntityType.startTime,
          rawValue: match.group(0)!.trim(),
          normalizedValue: hm,
          provenance: AssistantProvenance.extracted,
          confidence: AssistantConfidence.fromScore(0.8, evidences: [hm]),
        ),
      );
    }

    return TimeExtraction(entities: entities, issues: issues);
  }

  static String _specialOrHm(String token, String? minutes) {
    if (token.contains('meia')) return '00:00';
    if (token.contains('meio')) return '12:00';
    return _toHm(token, minutes);
  }

  static String _toHm(String hourRaw, String? minuteRaw) {
    final hour = int.parse(hourRaw).clamp(0, 23);
    final minute = int.parse(minuteRaw ?? '0').clamp(0, 59);
    return '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}';
  }

  static int _hmToMinutes(String hm) {
    final parts = hm.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}
