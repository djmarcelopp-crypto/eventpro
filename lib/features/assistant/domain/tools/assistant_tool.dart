import 'assistant_tool_types.dart';

/// Stable tool identifier.
class AssistantToolId {
  const AssistantToolId(this.value);

  final String value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssistantToolId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;

  Map<String, Object?> toDeterministicMap() => {'value': value};
}

/// Opaque reference to a tool or tool result entity.
class AssistantToolReference {
  const AssistantToolReference({
    required this.key,
    this.value,
    this.kind,
  });

  final String key;
  final String? value;
  final String? kind;

  Map<String, Object?> toDeterministicMap() => {
        'key': key,
        'value': value,
        'kind': kind,
      };
}

/// Declared parameter for a tool.
class AssistantToolParameter {
  const AssistantToolParameter({
    required this.name,
    required this.type,
    this.required = false,
    this.description,
    this.defaultValue,
  });

  final String name;
  final String type;
  final bool required;
  final String? description;
  final String? defaultValue;

  Map<String, Object?> toDeterministicMap() => {
        'name': name,
        'type': type,
        'required': required,
        'description': description,
        'defaultValue': defaultValue,
      };
}

/// Tool metadata (immutable).
class AssistantToolMetadata {
  const AssistantToolMetadata({
    this.label,
    this.description,
    this.version = '1',
    this.tags = const [],
    this.priority = 0,
  });

  final String? label;
  final String? description;
  final String version;
  final List<String> tags;
  final int priority;

  Map<String, Object?> toDeterministicMap() => {
        'label': label,
        'description': description,
        'version': version,
        'tags': tags,
        'priority': priority,
      };
}

/// Security / policy declaration for a tool.
class AssistantToolPolicy {
  const AssistantToolPolicy({
    this.permissions = const {AssistantToolPermission.read},
    this.scope = AssistantToolScope.session,
    this.risk = AssistantToolRisk.low,
    this.requiresConfirmation = false,
  });

  final Set<AssistantToolPermission> permissions;
  final AssistantToolScope scope;
  final AssistantToolRisk risk;
  final bool requiresConfirmation;

  Map<String, Object?> toDeterministicMap() => {
        'permissions': permissions.map((p) => p.name).toList()..sort(),
        'scope': scope.name,
        'risk': risk.name,
        'requiresConfirmation': requiresConfirmation,
      };
}

/// Immutable tool descriptor — no execution logic.
class AssistantTool {
  const AssistantTool({
    required this.id,
    required this.category,
    required this.capabilities,
    this.parameters = const [],
    this.metadata = const AssistantToolMetadata(),
    this.policy = const AssistantToolPolicy(),
  });

  final AssistantToolId id;
  final AssistantToolCategory category;
  final Set<AssistantToolCapability> capabilities;
  final List<AssistantToolParameter> parameters;
  final AssistantToolMetadata metadata;
  final AssistantToolPolicy policy;

  Map<String, Object?> toDeterministicMap() => {
        'id': id.toDeterministicMap(),
        'category': category.name,
        'capabilities': capabilities.map((c) => c.name).toList()..sort(),
        'parameters': parameters.map((p) => p.toDeterministicMap()).toList(),
        'metadata': metadata.toDeterministicMap(),
        'policy': policy.toDeterministicMap(),
      };
}

/// Structured tool error.
class AssistantToolError {
  const AssistantToolError({
    required this.code,
    required this.message,
    this.retryable = false,
    this.details = const [],
  });

  final AssistantToolErrorCode code;
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

/// Tool execution result payload (facts only — no side effects implied).
class AssistantToolResult {
  const AssistantToolResult({
    required this.toolId,
    required this.status,
    this.message,
    this.data = const {},
    this.references = const [],
    this.error,
    this.confidence = 1.0,
  });

  final AssistantToolId toolId;
  final AssistantToolExecutionStatus status;
  final String? message;
  final Map<String, String> data;
  final List<AssistantToolReference> references;
  final AssistantToolError? error;
  final double confidence;

  bool get isSuccess =>
      status == AssistantToolExecutionStatus.succeeded && error == null;

  Map<String, Object?> toDeterministicMap() => {
        'toolId': toolId.value,
        'status': status.name,
        'message': message,
        'data': data,
        'references': references.map((r) => r.toDeterministicMap()).toList(),
        'error': error?.toDeterministicMap(),
        'confidence': confidence,
      };
}
