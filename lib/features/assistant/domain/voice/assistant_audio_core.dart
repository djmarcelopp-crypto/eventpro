import 'assistant_audio_types.dart';

/// Opaque reference to audio content — never embeds bytes.
class AssistantAudioReference {
  const AssistantAudioReference({
    required this.uri,
    this.fileName,
    this.mimeType,
    this.sizeBytes,
    this.durationMs,
    this.sampleRateHz,
    this.channels,
    this.encoding,
  });

  final String uri;
  final String? fileName;
  final String? mimeType;
  final int? sizeBytes;
  final int? durationMs;
  final int? sampleRateHz;
  final int? channels;
  final String? encoding;

  bool get isValid => uri.trim().isNotEmpty;

  String get label {
    final name = fileName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return uri;
  }

  Map<String, Object?> toDeterministicMap() => {
        'uri': uri,
        'fileName': fileName,
        'mimeType': mimeType,
        'sizeBytes': sizeBytes,
        'durationMs': durationMs,
        'sampleRateHz': sampleRateHz,
        'channels': channels,
        'encoding': encoding,
      };
}

/// Immutable audio input descriptor.
class AssistantAudioInput {
  const AssistantAudioInput({
    required this.type,
    required this.reference,
    this.language,
  });

  final AssistantAudioType type;
  final AssistantAudioReference reference;
  final String? language;

  Map<String, Object?> toDeterministicMap() => {
        'type': type.name,
        'reference': reference.toDeterministicMap(),
        'language': language,
      };
}

/// Request metadata for voice/audio analysis.
class AssistantAudioMetadata {
  const AssistantAudioMetadata({
    this.correlationId,
    this.sessionId,
    this.requestId,
    this.origin,
    this.locale,
    this.language,
    this.timestamp,
    this.tags = const [],
  });

  final String? correlationId;
  final String? sessionId;
  final String? requestId;
  final String? origin;
  final String? locale;
  final String? language;
  final DateTime? timestamp;
  final List<String> tags;

  Map<String, Object?> toDeterministicMap() => {
        'correlationId': correlationId,
        'sessionId': sessionId,
        'requestId': requestId,
        'origin': origin,
        'locale': locale,
        'language': language,
        'timestamp': timestamp?.toUtc().toIso8601String(),
        'tags': tags,
      };
}

/// Structured audio/voice error.
class AssistantAudioError {
  const AssistantAudioError({
    required this.code,
    required this.message,
    this.retryable = false,
    this.details = const [],
  });

  final AssistantAudioErrorCode code;
  final String message;
  final bool retryable;
  final List<String> details;

  Map<String, Object?> toDeterministicMap() => {
        'code': code.name,
        'message': message,
        'retryable': retryable,
        'details': details,
      };
}

/// Privacy metadata attached to audio results.
class AssistantAudioPrivacyMetadata {
  const AssistantAudioPrivacyMetadata({
    this.sensitivity = AssistantAudioSensitivity.unknown,
    this.containsPersonalData = false,
    this.containsFinancialData = false,
    this.redacted = false,
    this.notes,
  });

  final AssistantAudioSensitivity sensitivity;
  final bool containsPersonalData;
  final bool containsFinancialData;
  final bool redacted;
  final String? notes;

  Map<String, Object?> toDeterministicMap() => {
        'sensitivity': sensitivity.name,
        'containsPersonalData': containsPersonalData,
        'containsFinancialData': containsFinancialData,
        'redacted': redacted,
        'notes': notes,
      };
}

/// Retention policy contract (no persistence implementation).
class AssistantAudioRetentionPolicy {
  const AssistantAudioRetentionPolicy({
    this.retainUntil,
    this.maxAge,
    this.purgeOnForget = true,
    this.policyId,
  });

  final DateTime? retainUntil;
  final Duration? maxAge;
  final bool purgeOnForget;
  final String? policyId;

  static const defaults = AssistantAudioRetentionPolicy(
    maxAge: Duration(days: 30),
    purgeOnForget: true,
    policyId: 'audio.default',
  );

  Map<String, Object?> toDeterministicMap() => {
        'retainUntil': retainUntil?.toUtc().toIso8601String(),
        'maxAgeMs': maxAge?.inMilliseconds,
        'purgeOnForget': purgeOnForget,
        'policyId': policyId,
      };
}
