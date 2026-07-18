import 'assistant_context.dart';
import 'assistant_input_origin.dart';

/// Immutable intake payload for the Assistente EventPRO.
class AssistantRequest {
  const AssistantRequest({
    required this.id,
    required this.rawText,
    required this.locale,
    required this.timezone,
    required this.timestamp,
    required this.origin,
    this.context,
  });

  final String id;
  final String rawText;
  final String locale;
  final String timezone;
  final DateTime timestamp;
  final AssistantInputOrigin origin;
  final AssistantContext? context;

  AssistantRequest copyWith({
    String? id,
    String? rawText,
    String? locale,
    String? timezone,
    DateTime? timestamp,
    AssistantInputOrigin? origin,
    AssistantContext? context,
    bool clearContext = false,
  }) {
    return AssistantRequest(
      id: id ?? this.id,
      rawText: rawText ?? this.rawText,
      locale: locale ?? this.locale,
      timezone: timezone ?? this.timezone,
      timestamp: timestamp ?? this.timestamp,
      origin: origin ?? this.origin,
      context: clearContext ? null : (context ?? this.context),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantRequest &&
            other.id == id &&
            other.rawText == rawText &&
            other.locale == locale &&
            other.timezone == timezone &&
            other.timestamp == timestamp &&
            other.origin == origin &&
            other.context == context;
  }

  @override
  int get hashCode => Object.hash(
        id,
        rawText,
        locale,
        timezone,
        timestamp,
        origin,
        context,
      );
}
