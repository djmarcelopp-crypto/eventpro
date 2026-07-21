import 'assistant_document_analysis.dart';
import 'assistant_ocr.dart';
import 'assistant_vision_core.dart';
import 'assistant_vision_types.dart';
import 'assistant_visual_analysis.dart';

/// Vision analysis request (structured facts only).
class AssistantVisionRequest {
  const AssistantVisionRequest({
    required this.input,
    this.requestedCapabilities = const {
      AssistantVisionCapability.ocr,
      AssistantVisionCapability.documentAnalysis,
      AssistantVisionCapability.entityDetection,
      AssistantVisionCapability.issueDetection,
    },
    this.metadata = const AssistantVisionMetadata(),
    this.privacy = const AssistantVisionPrivacyMetadata(),
    this.retention = AssistantVisionRetentionPolicy.defaults,
  });

  final AssistantVisionInput input;
  final Set<AssistantVisionCapability> requestedCapabilities;
  final AssistantVisionMetadata metadata;
  final AssistantVisionPrivacyMetadata privacy;
  final AssistantVisionRetentionPolicy retention;

  Map<String, Object?> toDeterministicMap() => {
        'input': input.toDeterministicMap(),
        'requestedCapabilities':
            requestedCapabilities.map((c) => c.name).toList()..sort(),
        'metadata': metadata.toDeterministicMap(),
        'privacy': privacy.toDeterministicMap(),
        'retention': retention.toDeterministicMap(),
      };
}

/// Business-facing signal only — never an action (AI-026 CP-10).
class AssistantVisionSignal {
  const AssistantVisionSignal({
    required this.code,
    required this.message,
    this.confidence = AssistantVisionConfidence.medium,
  });

  final String code;
  final String message;
  final AssistantVisionConfidence confidence;

  Map<String, Object?> toDeterministicMap() => {
        'code': code,
        'message': message,
        'confidence': confidence.name,
      };
}

/// Aggregated vision analysis result — facts, not decisions.
class AssistantVisionResult {
  const AssistantVisionResult({
    required this.engineId,
    required this.analyzedAt,
    this.confidence = AssistantVisionConfidence.unknown,
    this.ocr = AssistantOcrResult.empty,
    this.document = AssistantDocumentAnalysisResult.unknown,
    this.entities = const [],
    this.relations = const [],
    this.annotations = const [],
    this.issues = const [],
    this.suggestions = const [],
    this.signals = const [],
    this.privacy = const AssistantVisionPrivacyMetadata(),
    this.error,
    this.status = AssistantVisionResultStatus.ok,
  });

  final String engineId;
  final DateTime analyzedAt;
  final AssistantVisionConfidence confidence;
  final AssistantOcrResult ocr;
  final AssistantDocumentAnalysisResult document;
  final List<AssistantVisualEntity> entities;
  final List<AssistantVisualRelation> relations;
  final List<AssistantVisualAnnotation> annotations;
  final List<AssistantVisualIssue> issues;
  final List<AssistantVisualSuggestion> suggestions;
  final List<AssistantVisionSignal> signals;
  final AssistantVisionPrivacyMetadata privacy;
  final AssistantVisionError? error;
  final AssistantVisionResultStatus status;

  bool get isSuccess =>
      status == AssistantVisionResultStatus.ok && error == null;

  Map<String, Object?> toDeterministicMap() => {
        'engineId': engineId,
        'analyzedAt': analyzedAt.toUtc().toIso8601String(),
        'confidence': confidence.name,
        'ocr': ocr.toDeterministicMap(),
        'document': document.toDeterministicMap(),
        'entities': entities.map((e) => e.toDeterministicMap()).toList(),
        'relations': relations.map((r) => r.toDeterministicMap()).toList(),
        'annotations': annotations.map((a) => a.toDeterministicMap()).toList(),
        'issues': issues.map((i) => i.toDeterministicMap()).toList(),
        'suggestions':
            suggestions.map((s) => s.toDeterministicMap()).toList(),
        'signals': signals.map((s) => s.toDeterministicMap()).toList(),
        'privacy': privacy.toDeterministicMap(),
        'error': error?.toDeterministicMap(),
        'status': status.name,
      };
}

enum AssistantVisionResultStatus {
  ok,
  partial,
  failed,
  restricted,
}

/// Observability record (AI-026 CP-12) — contracts only.
class AssistantVisionObservation {
  const AssistantVisionObservation({
    required this.operation,
    required this.engineId,
    required this.timestamp,
    required this.status,
    this.capability,
    this.confidence,
    this.entityCount = 0,
    this.pageCount = 0,
    this.characterCount = 0,
    this.latencyMs,
    this.correlationId,
    this.errorCode,
  });

  final String operation;
  final String engineId;
  final DateTime timestamp;
  final String status;
  final AssistantVisionCapability? capability;
  final AssistantVisionConfidence? confidence;
  final int entityCount;
  final int pageCount;
  final int characterCount;
  final int? latencyMs;
  final String? correlationId;
  final String? errorCode;

  Map<String, Object?> toDeterministicMap() => {
        'operation': operation,
        'engineId': engineId,
        'timestamp': timestamp.toUtc().toIso8601String(),
        'status': status,
        'capability': capability?.name,
        'confidence': confidence?.name,
        'entityCount': entityCount,
        'pageCount': pageCount,
        'characterCount': characterCount,
        'latencyMs': latencyMs,
        'correlationId': correlationId,
        'errorCode': errorCode,
      };
}

abstract class AssistantVisionObserver {
  void record(AssistantVisionObservation observation);
}

class NoopAssistantVisionObserver implements AssistantVisionObserver {
  const NoopAssistantVisionObserver();

  @override
  void record(AssistantVisionObservation observation) {}
}

class CollectingAssistantVisionObserver implements AssistantVisionObserver {
  CollectingAssistantVisionObserver();

  final List<AssistantVisionObservation> records = [];

  @override
  void record(AssistantVisionObservation observation) {
    records.add(observation);
  }
}
