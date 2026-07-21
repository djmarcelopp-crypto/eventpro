/// Voice profile for speech synthesis contracts (AI-027 CP-4).
class AssistantVoiceCharacteristics {
  const AssistantVoiceCharacteristics({
    this.gender,
    this.ageHint,
    this.style,
    this.pitch,
    this.speakingRate,
  });

  final String? gender;
  final String? ageHint;
  final String? style;
  final double? pitch;
  final double? speakingRate;

  Map<String, Object?> toDeterministicMap() => {
        'gender': gender,
        'ageHint': ageHint,
        'style': style,
        'pitch': pitch,
        'speakingRate': speakingRate,
      };
}

class AssistantVoiceProfile {
  const AssistantVoiceProfile({
    required this.id,
    required this.name,
    this.locale,
    this.characteristics = const AssistantVoiceCharacteristics(),
  });

  final String id;
  final String name;
  final String? locale;
  final AssistantVoiceCharacteristics characteristics;

  Map<String, Object?> toDeterministicMap() => {
        'id': id,
        'name': name,
        'locale': locale,
        'characteristics': characteristics.toDeterministicMap(),
      };
}

class AssistantSpeechMetadata {
  const AssistantSpeechMetadata({
    this.correlationId,
    this.voiceProfileId,
    this.format,
    this.estimatedDurationMs,
  });

  final String? correlationId;
  final String? voiceProfileId;
  final String? format;
  final int? estimatedDurationMs;

  Map<String, Object?> toDeterministicMap() => {
        'correlationId': correlationId,
        'voiceProfileId': voiceProfileId,
        'format': format,
        'estimatedDurationMs': estimatedDurationMs,
      };
}

/// Speech synthesis request — contracts only, no real TTS.
class AssistantSpeechRequest {
  const AssistantSpeechRequest({
    required this.text,
    this.voiceProfileId,
    this.locale,
    this.correlationId,
  });

  final String text;
  final String? voiceProfileId;
  final String? locale;
  final String? correlationId;

  Map<String, Object?> toDeterministicMap() => {
        'text': text,
        'voiceProfileId': voiceProfileId,
        'locale': locale,
        'correlationId': correlationId,
      };
}

/// Speech synthesis result — reference only, never audio bytes.
class AssistantSpeechResult {
  const AssistantSpeechResult({
    required this.audioReferenceUri,
    this.voiceProfileId,
    this.metadata = const AssistantSpeechMetadata(),
    this.success = true,
  });

  final String audioReferenceUri;
  final String? voiceProfileId;
  final AssistantSpeechMetadata metadata;
  final bool success;

  Map<String, Object?> toDeterministicMap() => {
        'audioReferenceUri': audioReferenceUri,
        'voiceProfileId': voiceProfileId,
        'metadata': metadata.toDeterministicMap(),
        'success': success,
      };
}
