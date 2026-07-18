import '../domain/assistant_parser.dart';
import '../models/assistant_entity.dart';
import '../models/assistant_entity_type.dart';
import '../models/assistant_parse_issue.dart';
import '../models/assistant_parse_issue_type.dart';
import '../models/assistant_parse_result.dart';
import '../models/assistant_request.dart';
import '../utils/assistant_text_normalizer.dart';
import 'client_extractor.dart';
import 'date_extractor.dart';
import 'event_type_extractor.dart';
import 'guest_count_extractor.dart';
import 'keyword_extractor.dart';
import 'location_extractor.dart';
import 'time_extractor.dart';

/// Deterministic local parser composing specialized extractors.
class LocalAssistantParser implements AssistantParser {
  LocalAssistantParser({DateTime Function()? clock})
      : _dateExtractor = DateExtractor(clock: clock);

  final DateExtractor _dateExtractor;

  @override
  AssistantParseResult parse(AssistantRequest request) {
    final normalized = AssistantTextNormalizer.normalize(request.rawText);
    if (normalized.isEmpty) {
      return const AssistantParseResult(
        entities: [],
        issues: [
          AssistantParseIssue(
            type: AssistantParseIssueType.missing,
            message: 'Texto vazio.',
          ),
        ],
      );
    }

    final entities = <AssistantEntity>[
      ...EventTypeExtractor.extract(normalized),
      ...LocationExtractor.extract(normalized),
      ...ClientExtractor.extract(normalized),
      ...KeywordExtractor.extract(normalized),
    ];
    final issues = <AssistantParseIssue>[];

    final dates = _dateExtractor.extract(normalized);
    entities.addAll(dates.entities);
    issues.addAll(dates.issues);

    final times = TimeExtractor.extract(normalized);
    entities.addAll(times.entities);
    issues.addAll(times.issues);

    final guests = GuestCountExtractor.extract(normalized);
    entities.addAll(guests.entities);
    issues.addAll(guests.issues);

    if (!entities.any((e) => e.type == AssistantEntityType.date)) {
      issues.add(
        const AssistantParseIssue(
          type: AssistantParseIssueType.missing,
          message: 'Data do evento não encontrada.',
          entityType: AssistantEntityType.date,
        ),
      );
    }
    if (!entities.any((e) => e.type == AssistantEntityType.startTime)) {
      issues.add(
        const AssistantParseIssue(
          type: AssistantParseIssueType.missing,
          message: 'Horário de início não encontrado.',
          entityType: AssistantEntityType.startTime,
        ),
      );
    }

    return AssistantParseResult(
      entities: List.unmodifiable(entities),
      issues: List.unmodifiable(issues),
      normalizedText: normalized,
    );
  }
}
