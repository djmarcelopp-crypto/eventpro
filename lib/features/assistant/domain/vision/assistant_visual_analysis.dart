import 'assistant_ocr.dart';
import 'assistant_vision_types.dart';

enum AssistantVisualEntityType {
  person,
  document,
  equipment,
  speaker,
  powerDistributor,
  lightingFixture,
  truss,
  stage,
  table,
  chair,
  vehicle,
  qrCode,
  barcode,
  logo,
  unknown,
}

class AssistantVisualAttribute {
  const AssistantVisualAttribute({
    required this.key,
    required this.value,
    this.confidence,
  });

  final String key;
  final String value;
  final double? confidence;

  Map<String, Object?> toDeterministicMap() => {
        'key': key,
        'value': value,
        'confidence': confidence,
      };
}

class AssistantVisualEntity {
  const AssistantVisualEntity({
    required this.id,
    required this.type,
    this.label,
    this.confidence = AssistantVisionConfidence.unknown,
    this.attributes = const [],
    this.boundingBox,
  });

  final String id;
  final AssistantVisualEntityType type;
  final String? label;
  final AssistantVisionConfidence confidence;
  final List<AssistantVisualAttribute> attributes;
  final AssistantBoundingBox? boundingBox;

  Map<String, Object?> toDeterministicMap() => {
        'id': id,
        'type': type.name,
        'label': label,
        'confidence': confidence.name,
        'attributes': attributes.map((a) => a.toDeterministicMap()).toList(),
        'boundingBox': boundingBox?.toDeterministicMap(),
      };
}

class AssistantVisualRelation {
  const AssistantVisualRelation({
    required this.fromEntityId,
    required this.toEntityId,
    required this.kind,
  });

  final String fromEntityId;
  final String toEntityId;
  final String kind;

  Map<String, Object?> toDeterministicMap() => {
        'fromEntityId': fromEntityId,
        'toEntityId': toEntityId,
        'kind': kind,
      };
}

class AssistantVisualAnnotation {
  const AssistantVisualAnnotation({
    required this.code,
    required this.message,
    this.entityId,
    this.confidence,
  });

  final String code;
  final String message;
  final String? entityId;
  final AssistantVisionConfidence? confidence;

  Map<String, Object?> toDeterministicMap() => {
        'code': code,
        'message': message,
        'entityId': entityId,
        'confidence': confidence?.name,
      };
}

class AssistantVisualIssue {
  const AssistantVisualIssue({
    required this.code,
    required this.message,
    this.severity = 'info',
  });

  final String code;
  final String message;
  final String severity;

  Map<String, Object?> toDeterministicMap() => {
        'code': code,
        'message': message,
        'severity': severity,
      };
}

class AssistantVisualSuggestion {
  const AssistantVisualSuggestion({
    required this.code,
    required this.message,
  });

  final String code;
  final String message;

  Map<String, Object?> toDeterministicMap() => {
        'code': code,
        'message': message,
      };
}
