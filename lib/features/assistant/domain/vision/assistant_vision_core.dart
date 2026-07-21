import 'assistant_vision_types.dart';

/// Opaque reference to visual content — never embeds bytes.
class AssistantVisionReference {
  const AssistantVisionReference({
    required this.uri,
    this.fileName,
    this.mimeType,
    this.sizeBytes,
    this.pageCount,
  });

  final String uri;
  final String? fileName;
  final String? mimeType;
  final int? sizeBytes;
  final int? pageCount;

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
        'pageCount': pageCount,
      };
}

/// Immutable vision input descriptor.
class AssistantVisionInput {
  const AssistantVisionInput({
    required this.type,
    required this.reference,
    this.locale,
  });

  final AssistantVisionInputType type;
  final AssistantVisionReference reference;
  final String? locale;

  Map<String, Object?> toDeterministicMap() => {
        'type': type.name,
        'reference': reference.toDeterministicMap(),
        'locale': locale,
      };
}

/// Request metadata for vision analysis.
class AssistantVisionMetadata {
  const AssistantVisionMetadata({
    this.correlationId,
    this.sessionId,
    this.requestId,
    this.origin,
    this.locale,
    this.tags = const [],
  });

  final String? correlationId;
  final String? sessionId;
  final String? requestId;
  final String? origin;
  final String? locale;
  final List<String> tags;

  Map<String, Object?> toDeterministicMap() => {
        'correlationId': correlationId,
        'sessionId': sessionId,
        'requestId': requestId,
        'origin': origin,
        'locale': locale,
        'tags': tags,
      };
}

/// Structured vision error.
class AssistantVisionError {
  const AssistantVisionError({
    required this.code,
    required this.message,
    this.retryable = false,
    this.details = const [],
  });

  final AssistantVisionErrorCode code;
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

/// Privacy metadata attached to vision results.
class AssistantVisionPrivacyMetadata {
  const AssistantVisionPrivacyMetadata({
    this.sensitivity = AssistantVisionSensitivity.unknown,
    this.containsPersonalData = false,
    this.containsFinancialData = false,
    this.redacted = false,
    this.notes,
  });

  final AssistantVisionSensitivity sensitivity;
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
class AssistantVisionRetentionPolicy {
  const AssistantVisionRetentionPolicy({
    this.retainUntil,
    this.maxAge,
    this.purgeOnForget = true,
    this.policyId,
  });

  final DateTime? retainUntil;
  final Duration? maxAge;
  final bool purgeOnForget;
  final String? policyId;

  static const defaults = AssistantVisionRetentionPolicy(
    maxAge: Duration(days: 30),
    purgeOnForget: true,
    policyId: 'vision.default',
  );

  Map<String, Object?> toDeterministicMap() => {
        'retainUntil': retainUntil?.toUtc().toIso8601String(),
        'maxAgeMs': maxAge?.inMilliseconds,
        'purgeOnForget': purgeOnForget,
        'policyId': policyId,
      };
}
