import '../models/assistant_confidence.dart';
import '../models/assistant_entity.dart';
import '../models/assistant_entity_type.dart';
import '../models/assistant_parse_issue.dart';
import '../models/assistant_parse_issue_type.dart';
import '../models/assistant_provenance.dart';
import '../utils/assistant_text_normalizer.dart';

class DateExtraction {
  const DateExtraction({
    required this.entities,
    this.issues = const [],
  });

  final List<AssistantEntity> entities;
  final List<AssistantParseIssue> issues;
}

/// Deterministic Portuguese date extraction with injectable clock.
class DateExtractor {
  DateExtractor({DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;

  static const _monthNames = <String, int>{
    'janeiro': 1,
    'fevereiro': 2,
    'marco': 3,
    'abril': 4,
    'maio': 5,
    'junho': 6,
    'julho': 7,
    'agosto': 8,
    'setembro': 9,
    'outubro': 10,
    'novembro': 11,
    'dezembro': 12,
  };

  static const _weekdays = <String, int>{
    'segunda': DateTime.monday,
    'terca': DateTime.tuesday,
    'quarta': DateTime.wednesday,
    'quinta': DateTime.thursday,
    'sexta': DateTime.friday,
    'sabado': DateTime.saturday,
    'domingo': DateTime.sunday,
  };

  DateExtraction extract(String text) {
    final folded = AssistantTextNormalizer.fold(text);
    final now = _clock();
    final today = DateTime(now.year, now.month, now.day);
    final entities = <AssistantEntity>[];
    final issues = <AssistantParseIssue>[];

    void addDate(
      DateTime date, {
      required String raw,
      required AssistantProvenance provenance,
      required double score,
      List<String> reasons = const [],
    }) {
      entities.add(
        AssistantEntity(
          type: AssistantEntityType.date,
          rawValue: raw,
          normalizedValue: _iso(date),
          provenance: provenance,
          confidence: AssistantConfidence.fromScore(
            score,
            reasons: reasons,
            evidences: [raw],
          ),
          sourceSpan: raw,
        ),
      );
    }

    final numericFull = RegExp(r'\b(\d{1,2})/(\d{1,2})/(\d{4})\b');
    for (final match in numericFull.allMatches(folded)) {
      final day = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      final year = int.parse(match.group(3)!);
      addDate(
        DateTime(year, month, day),
        raw: match.group(0)!,
        provenance: AssistantProvenance.extracted,
        score: 0.95,
      );
    }

    final numericShort = RegExp(r'\b(\d{1,2})/(\d{1,2})\b(?!/\d)');
    for (final match in numericShort.allMatches(folded)) {
      final day = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      var candidate = DateTime(today.year, month, day);
      var yearInferred = false;
      if (candidate.isBefore(today)) {
        candidate = DateTime(today.year + 1, month, day);
        yearInferred = true;
      }
      addDate(
        candidate,
        raw: match.group(0)!,
        provenance: yearInferred
            ? AssistantProvenance.inferred
            : AssistantProvenance.extracted,
        score: yearInferred ? 0.7 : 0.85,
        reasons: yearInferred
            ? const ['Ano ausente; usado o próximo acontecimento válido']
            : const [],
      );
      if (yearInferred) {
        issues.add(
          AssistantParseIssue(
            type: AssistantParseIssueType.inferred,
            message: 'Ano da data ${match.group(0)} foi inferido.',
            entityType: AssistantEntityType.date,
          ),
        );
      }
    }

    final named = RegExp(
      r'(?:dia\s+)?(\d{1,2})\s+de\s+(janeiro|fevereiro|marco|abril|maio|junho|julho|agosto|setembro|outubro|novembro|dezembro)(?:\s+de\s+(\d{4}))?',
    );
    for (final match in named.allMatches(folded)) {
      final day = int.parse(match.group(1)!);
      final month = _monthNames[match.group(2)!]!;
      final yearGroup = match.group(3);
      if (yearGroup != null) {
        addDate(
          DateTime(int.parse(yearGroup), month, day),
          raw: match.group(0)!,
          provenance: AssistantProvenance.extracted,
          score: 0.93,
        );
      } else {
        var candidate = DateTime(today.year, month, day);
        var yearInferred = false;
        if (candidate.isBefore(today)) {
          candidate = DateTime(today.year + 1, month, day);
          yearInferred = true;
        }
        addDate(
          candidate,
          raw: match.group(0)!,
          provenance: yearInferred
              ? AssistantProvenance.inferred
              : AssistantProvenance.extracted,
          score: yearInferred ? 0.68 : 0.82,
          reasons: yearInferred
              ? const ['Ano ausente; usado o próximo acontecimento válido']
              : const [],
        );
        if (yearInferred) {
          issues.add(
            AssistantParseIssue(
              type: AssistantParseIssueType.inferred,
              message: 'Ano da data "${match.group(0)}" foi inferido.',
              entityType: AssistantEntityType.date,
            ),
          );
        }
      }
    }

    if (folded.contains('depois de amanha') ||
        folded.contains('depois de amanhã')) {
      addDate(
        today.add(const Duration(days: 2)),
        raw: 'depois de amanhã',
        provenance: AssistantProvenance.inferred,
        score: 0.8,
        reasons: const ['Data relativa resolvida pelo clock'],
      );
    } else if (RegExp(r'\bamanha\b').hasMatch(folded) ||
        RegExp(r'\bamanhã\b').hasMatch(folded)) {
      addDate(
        today.add(const Duration(days: 1)),
        raw: 'amanhã',
        provenance: AssistantProvenance.inferred,
        score: 0.8,
        reasons: const ['Data relativa resolvida pelo clock'],
      );
    }

    for (final entry in _weekdays.entries) {
      final patterns = [
        RegExp('proxima ${entry.key}'),
        RegExp('neste ${entry.key}'),
        RegExp('\\b${entry.key}\\b'),
      ];
      for (var i = 0; i < patterns.length; i++) {
        if (!patterns[i].hasMatch(folded)) continue;
        final date = _nextWeekday(today, entry.value, forceNext: i == 0);
        final ambiguous = i == 2;
        addDate(
          date,
          raw: entry.key,
          provenance: ambiguous
              ? AssistantProvenance.inferred
              : AssistantProvenance.inferred,
          score: ambiguous ? 0.5 : 0.72,
          reasons: ambiguous
              ? const ['Dia da semana sem qualificador forte']
              : const ['Próximo dia da semana resolvido pelo clock'],
        );
        if (ambiguous) {
          issues.add(
            AssistantParseIssue(
              type: AssistantParseIssueType.ambiguous,
              message:
                  'Referência a "${entry.key}" sem contexto suficiente de semana.',
              entityType: AssistantEntityType.date,
            ),
          );
        }
        break;
      }
    }

    final uniqueValues = entities.map((e) => e.normalizedValue).toSet();
    if (uniqueValues.length > 1) {
      issues.add(
        const AssistantParseIssue(
          type: AssistantParseIssueType.conflicting,
          message: 'Foram encontradas datas diferentes no texto.',
          entityType: AssistantEntityType.date,
        ),
      );
    }

    return DateExtraction(entities: entities, issues: issues);
  }

  static DateTime _nextWeekday(
    DateTime today,
    int weekday, {
    required bool forceNext,
  }) {
    var delta = (weekday - today.weekday) % 7;
    if (delta == 0) {
      delta = forceNext ? 7 : 0;
    }
    return today.add(Duration(days: delta));
  }

  static String _iso(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
