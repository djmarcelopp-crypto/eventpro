import 'assistant_audio_types.dart';

/// Stable speaker identifier.
class AssistantSpeakerId {
  const AssistantSpeakerId(this.value);

  final String value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssistantSpeakerId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;

  Map<String, Object?> toDeterministicMap() => {'value': value};
}

class AssistantSpeaker {
  const AssistantSpeaker({
    required this.id,
    this.label,
    this.confidence = AssistantAudioConfidence.unknown,
  });

  final AssistantSpeakerId id;
  final String? label;
  final AssistantAudioConfidence confidence;

  Map<String, Object?> toDeterministicMap() => {
        'id': id.toDeterministicMap(),
        'label': label,
        'confidence': confidence.name,
      };
}

class AssistantTranscriptLanguage {
  const AssistantTranscriptLanguage({
    required this.code,
    this.confidence = AssistantAudioConfidence.unknown,
  });

  final String code;
  final AssistantAudioConfidence confidence;

  Map<String, Object?> toDeterministicMap() => {
        'code': code,
        'confidence': confidence.name,
      };
}

class AssistantTranscriptWord {
  const AssistantTranscriptWord({
    required this.text,
    this.startMs,
    this.endMs,
    this.confidence,
  });

  final String text;
  final int? startMs;
  final int? endMs;
  final double? confidence;

  Map<String, Object?> toDeterministicMap() => {
        'text': text,
        'startMs': startMs,
        'endMs': endMs,
        'confidence': confidence,
      };
}

class AssistantTranscriptSegment {
  const AssistantTranscriptSegment({
    required this.text,
    required this.startMs,
    required this.endMs,
    this.speakerId,
    this.confidence = AssistantAudioConfidence.unknown,
    this.words = const [],
  });

  final String text;
  final int startMs;
  final int endMs;
  final AssistantSpeakerId? speakerId;
  final AssistantAudioConfidence confidence;
  final List<AssistantTranscriptWord> words;

  Map<String, Object?> toDeterministicMap() => {
        'text': text,
        'startMs': startMs,
        'endMs': endMs,
        'speakerId': speakerId?.value,
        'confidence': confidence.name,
        'words': words.map((w) => w.toDeterministicMap()).toList(),
      };
}

class AssistantTranscriptMetadata {
  const AssistantTranscriptMetadata({
    this.correlationId,
    this.language,
    this.engineId,
    this.wordCount = 0,
    this.segmentCount = 0,
  });

  final String? correlationId;
  final String? language;
  final String? engineId;
  final int wordCount;
  final int segmentCount;

  Map<String, Object?> toDeterministicMap() => {
        'correlationId': correlationId,
        'language': language,
        'engineId': engineId,
        'wordCount': wordCount,
        'segmentCount': segmentCount,
      };
}

class AssistantTranscriptionRequest {
  const AssistantTranscriptionRequest({
    required this.referenceUri,
    this.fileName,
    this.mimeType,
    this.languageHint,
    this.correlationId,
  });

  final String referenceUri;
  final String? fileName;
  final String? mimeType;
  final String? languageHint;
  final String? correlationId;

  Map<String, Object?> toDeterministicMap() => {
        'referenceUri': referenceUri,
        'fileName': fileName,
        'mimeType': mimeType,
        'languageHint': languageHint,
        'correlationId': correlationId,
      };
}

class AssistantTranscriptionResult {
  const AssistantTranscriptionResult({
    required this.fullText,
    this.segments = const [],
    this.speakers = const [],
    this.language,
    this.confidence = AssistantAudioConfidence.unknown,
    this.metadata = const AssistantTranscriptMetadata(),
  });

  final String fullText;
  final List<AssistantTranscriptSegment> segments;
  final List<AssistantSpeaker> speakers;
  final AssistantTranscriptLanguage? language;
  final AssistantAudioConfidence confidence;
  final AssistantTranscriptMetadata metadata;

  static const empty = AssistantTranscriptionResult(fullText: '');

  Map<String, Object?> toDeterministicMap() => {
        'fullText': fullText,
        'segments': segments.map((s) => s.toDeterministicMap()).toList(),
        'speakers': speakers.map((s) => s.toDeterministicMap()).toList(),
        'language': language?.toDeterministicMap(),
        'confidence': confidence.name,
        'metadata': metadata.toDeterministicMap(),
      };
}
