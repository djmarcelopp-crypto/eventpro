import 'assistant_tool.dart';
import 'assistant_tool_request.dart';
import 'assistant_tool_types.dart';

class AssistantToolHealth {
  const AssistantToolHealth({
    required this.status,
    required this.checkedAt,
    this.message,
  });

  final AssistantToolHealthStatus status;
  final DateTime checkedAt;
  final String? message;

  bool get isHealthy => status == AssistantToolHealthStatus.healthy;

  Map<String, Object?> toDeterministicMap() => {
        'status': status.name,
        'checkedAt': checkedAt.toUtc().toIso8601String(),
        'message': message,
      };
}

enum AssistantToolHealthStatus {
  healthy,
  degraded,
  unavailable,
  unknown,
}

/// Port for tool execution (AI-028 CP-3).
///
/// Does **not** implement business logic. Mock executors only return facts.
abstract class AssistantToolPort {
  Future<AssistantToolResponse> execute(AssistantToolRequest request);

  Future<AssistantToolError?> validate(AssistantToolRequest request);

  bool supports(AssistantToolCapability capability);

  AssistantTool? describe(AssistantToolId toolId);

  Future<AssistantToolHealth> health();
}

/// Registry of tool descriptors + ports (AI-028 CP-4).
abstract class AssistantToolRegistry {
  void register(AssistantTool tool, {AssistantToolPort? port});

  void unregister(AssistantToolId toolId);

  AssistantTool? find(AssistantToolId toolId);

  AssistantToolPort? findPort(AssistantToolId toolId);

  List<AssistantTool> findByCapability(AssistantToolCapability capability);

  List<AssistantTool> list();

  List<AssistantTool> defaultTools();
}

/// Selection criteria (AI-028 CP-5).
class AssistantToolSelectionCriteria {
  const AssistantToolSelectionCriteria({
    this.capability,
    this.category,
    this.toolId,
    this.maxRisk,
    this.requiredPermissions = const {},
    this.contextHints = const [],
    this.allowFallback = true,
  });

  final AssistantToolCapability? capability;
  final AssistantToolCategory? category;
  final AssistantToolId? toolId;
  final AssistantToolRisk? maxRisk;
  final Set<AssistantToolPermission> requiredPermissions;
  final List<String> contextHints;
  final bool allowFallback;

  Map<String, Object?> toDeterministicMap() => {
        'capability': capability?.name,
        'category': category?.name,
        'toolId': toolId?.value,
        'maxRisk': maxRisk?.name,
        'requiredPermissions':
            requiredPermissions.map((p) => p.name).toList()..sort(),
        'contextHints': contextHints,
        'allowFallback': allowFallback,
      };
}

class AssistantToolSelection {
  const AssistantToolSelection({
    required this.tool,
    required this.port,
    required this.reason,
    this.fallbackUsed = false,
  });

  final AssistantTool tool;
  final AssistantToolPort port;
  final String reason;
  final bool fallbackUsed;

  Map<String, Object?> toDeterministicMap() => {
        'toolId': tool.id.value,
        'reason': reason,
        'fallbackUsed': fallbackUsed,
      };
}

abstract class AssistantToolRouter {
  AssistantToolSelection? select({
    required AssistantToolRegistry registry,
    AssistantToolSelectionCriteria criteria =
        const AssistantToolSelectionCriteria(),
  });
}
