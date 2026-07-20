import 'assistant_input_source.dart';

/// Channel / intake metadata (no heavy payloads).
class AssistantInputMetadata {
  const AssistantInputMetadata({
    required this.source,
    this.locale,
    this.timezone,
    this.channelLabel,
    this.correlationId,
    this.tags = const [],
  });

  final AssistantInputSource source;
  final String? locale;
  final String? timezone;
  final String? channelLabel;

  /// Traceability key linking related turns / attachments.
  final String? correlationId;
  final List<String> tags;

  Map<String, Object?> toDeterministicMap() => {
        'source': source.name,
        'locale': locale,
        'timezone': timezone,
        'channelLabel': channelLabel,
        'correlationId': correlationId,
        'tags': tags,
      };
}
