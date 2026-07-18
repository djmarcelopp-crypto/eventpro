import 'assistant_confidence.dart';
import 'assistant_provenance.dart';

/// Partial event draft — never persisted by AI-001.
class AssistantEventDraft {
  const AssistantEventDraft({
    this.eventType,
    this.eventName,
    this.clientName,
    this.date,
    this.startTime,
    this.endTime,
    this.city,
    this.venue,
    this.guestCount,
    this.notes,
    this.confidence = AssistantConfidence.none,
    this.sourceText = '',
    this.fieldProvenance = const {},
  });

  final String? eventType;
  final String? eventName;
  final String? clientName;

  /// Civil date only (time is zeroed when known).
  final DateTime? date;

  /// Normalized `HH:mm` when known.
  final String? startTime;
  final String? endTime;
  final String? city;
  final String? venue;
  final int? guestCount;
  final String? notes;
  final AssistantConfidence confidence;
  final String sourceText;

  /// Provenance per logical field name (`date`, `guestCount`, …).
  final Map<String, AssistantProvenance> fieldProvenance;

  bool get hasEssentialGaps =>
      date == null ||
      startTime == null ||
      (city == null && venue == null);

  AssistantEventDraft copyWith({
    String? eventType,
    String? eventName,
    String? clientName,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? city,
    String? venue,
    int? guestCount,
    String? notes,
    AssistantConfidence? confidence,
    String? sourceText,
    Map<String, AssistantProvenance>? fieldProvenance,
    bool clearEventType = false,
    bool clearEventName = false,
    bool clearClientName = false,
    bool clearDate = false,
    bool clearStartTime = false,
    bool clearEndTime = false,
    bool clearCity = false,
    bool clearVenue = false,
    bool clearGuestCount = false,
    bool clearNotes = false,
  }) {
    return AssistantEventDraft(
      eventType: clearEventType ? null : (eventType ?? this.eventType),
      eventName: clearEventName ? null : (eventName ?? this.eventName),
      clientName: clearClientName ? null : (clientName ?? this.clientName),
      date: clearDate ? null : (date ?? this.date),
      startTime: clearStartTime ? null : (startTime ?? this.startTime),
      endTime: clearEndTime ? null : (endTime ?? this.endTime),
      city: clearCity ? null : (city ?? this.city),
      venue: clearVenue ? null : (venue ?? this.venue),
      guestCount: clearGuestCount ? null : (guestCount ?? this.guestCount),
      notes: clearNotes ? null : (notes ?? this.notes),
      confidence: confidence ?? this.confidence,
      sourceText: sourceText ?? this.sourceText,
      fieldProvenance: fieldProvenance ?? this.fieldProvenance,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantEventDraft &&
            other.eventType == eventType &&
            other.eventName == eventName &&
            other.clientName == clientName &&
            other.date == date &&
            other.startTime == startTime &&
            other.endTime == endTime &&
            other.city == city &&
            other.venue == venue &&
            other.guestCount == guestCount &&
            other.notes == notes &&
            other.confidence == confidence &&
            other.sourceText == sourceText &&
            _mapEquals(other.fieldProvenance, fieldProvenance);
  }

  @override
  int get hashCode => Object.hash(
        eventType,
        eventName,
        clientName,
        date,
        startTime,
        endTime,
        city,
        venue,
        guestCount,
        notes,
        confidence,
        sourceText,
        Object.hashAll(fieldProvenance.entries),
      );

  static bool _mapEquals(
    Map<String, AssistantProvenance> a,
    Map<String, AssistantProvenance> b,
  ) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) return false;
    }
    return true;
  }
}
