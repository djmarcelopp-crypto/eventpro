import 'assistant_document_analysis.dart';
import 'assistant_ocr.dart';
import 'assistant_vision_result.dart';
import 'assistant_vision_types.dart';
import 'assistant_visual_analysis.dart';

/// Health snapshot for a vision engine (no network).
class AssistantVisionHealth {
  const AssistantVisionHealth({
    required this.status,
    required this.checkedAt,
    this.message,
  });

  final AssistantVisionHealthStatus status;
  final DateTime checkedAt;
  final String? message;

  bool get isHealthy => status == AssistantVisionHealthStatus.healthy;

  Map<String, Object?> toDeterministicMap() => {
        'status': status.name,
        'checkedAt': checkedAt.toUtc().toIso8601String(),
        'message': message,
      };
}

enum AssistantVisionHealthStatus {
  healthy,
  degraded,
  unavailable,
  unknown,
}

/// Port for Vision Engine (AI-026 CP-6).
///
/// Produces structured facts only. No business decisions / workflows / writes.
abstract class AssistantVisionPort {
  String get engineId;

  Set<AssistantVisionCapability> get capabilities;

  Future<AssistantVisionResult> analyze(AssistantVisionRequest request);

  Future<AssistantOcrResult> extractText(AssistantOcrRequest request);

  Future<AssistantDocumentAnalysisResult> analyzeDocument(
    AssistantDocumentAnalysisRequest request,
  );

  Future<List<AssistantVisualEntity>> detectEntities(
    AssistantVisionRequest request,
  );

  Future<List<AssistantVisualIssue>> detectIssues(
    AssistantVisionRequest request,
  );

  bool supports(AssistantVisionCapability capability);

  Future<AssistantVisionHealth> health();
}

/// Criteria for selecting a vision engine (AI-026 CP-8).
class AssistantVisionSelectionCriteria {
  const AssistantVisionSelectionCriteria({
    this.inputType,
    this.mimeType,
    this.requiredCapabilities = const {},
    this.preferEngineId,
    this.allowFallback = true,
  });

  final AssistantVisionInputType? inputType;
  final String? mimeType;
  final Set<AssistantVisionCapability> requiredCapabilities;
  final String? preferEngineId;
  final bool allowFallback;

  Map<String, Object?> toDeterministicMap() => {
        'inputType': inputType?.name,
        'mimeType': mimeType,
        'requiredCapabilities':
            requiredCapabilities.map((c) => c.name).toList()..sort(),
        'preferEngineId': preferEngineId,
        'allowFallback': allowFallback,
      };
}

/// Registered vision engine binding.
class AssistantVisionEngineRegistration {
  const AssistantVisionEngineRegistration({
    required this.engineId,
    required this.port,
    this.priority = 0,
    this.supportedInputTypes = const {},
    this.supportedMimePrefixes = const [],
  });

  final String engineId;
  final AssistantVisionPort port;
  final int priority;
  final Set<AssistantVisionInputType> supportedInputTypes;
  final List<String> supportedMimePrefixes;

  Map<String, Object?> toDeterministicMap() => {
        'engineId': engineId,
        'priority': priority,
        'supportedInputTypes':
            supportedInputTypes.map((t) => t.name).toList()..sort(),
        'supportedMimePrefixes': supportedMimePrefixes,
      };
}

/// Selection outcome.
class AssistantVisionSelection {
  const AssistantVisionSelection({
    required this.registration,
    required this.reason,
    this.fallbackUsed = false,
  });

  final AssistantVisionEngineRegistration registration;
  final String reason;
  final bool fallbackUsed;

  AssistantVisionPort get port => registration.port;

  Map<String, Object?> toDeterministicMap() => {
        'engineId': registration.engineId,
        'reason': reason,
        'fallbackUsed': fallbackUsed,
      };
}

/// Routes requests to a vision engine without knowing vendors.
abstract class AssistantVisionRouter {
  void register(AssistantVisionEngineRegistration registration);

  void unregister(String engineId);

  List<AssistantVisionEngineRegistration> list();

  AssistantVisionSelection? select(AssistantVisionSelectionCriteria criteria);
}
