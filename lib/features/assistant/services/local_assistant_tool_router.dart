import '../domain/tools/assistant_tool.dart';
import '../domain/tools/assistant_tool_port.dart';

/// Deterministic tool selection (AI-028 CP-5).
class LocalAssistantToolRouter implements AssistantToolRouter {
  const LocalAssistantToolRouter();

  @override
  AssistantToolSelection? select({
    required AssistantToolRegistry registry,
    AssistantToolSelectionCriteria criteria =
        const AssistantToolSelectionCriteria(),
  }) {
    final all = registry.list();
    if (all.isEmpty) return null;

    if (criteria.toolId != null) {
      final tool = registry.find(criteria.toolId!);
      final port = registry.findPort(criteria.toolId!);
      if (tool != null && port != null && _matches(tool, criteria)) {
        return AssistantToolSelection(
          tool: tool,
          port: port,
          reason: 'tool_id',
        );
      }
      if (!criteria.allowFallback) return null;
    }

    var candidates = all.where((t) => _matches(t, criteria)).toList();
    if (candidates.isEmpty && criteria.allowFallback) {
      candidates = all
          .where((t) => _permissionOk(t, criteria) && _riskOk(t, criteria))
          .toList();
    }
    if (candidates.isEmpty) return null;

    candidates.sort((a, b) {
      final byPriority =
          b.metadata.priority.compareTo(a.metadata.priority);
      if (byPriority != 0) return byPriority;
      return a.id.value.compareTo(b.id.value);
    });

    final tool = candidates.first;
    final port = registry.findPort(tool.id);
    if (port == null) return null;

    return AssistantToolSelection(
      tool: tool,
      port: port,
      reason: criteria.capability != null
          ? 'capability_priority'
          : (criteria.category != null ? 'category_priority' : 'priority'),
      fallbackUsed: criteria.toolId != null ||
          (criteria.capability != null &&
              !tool.capabilities.contains(criteria.capability)),
    );
  }

  bool _matches(AssistantTool tool, AssistantToolSelectionCriteria criteria) {
    if (!_permissionOk(tool, criteria) || !_riskOk(tool, criteria)) {
      return false;
    }
    if (criteria.capability != null &&
        !tool.capabilities.contains(criteria.capability)) {
      return false;
    }
    if (criteria.category != null && tool.category != criteria.category) {
      return false;
    }
    if (criteria.contextHints.isNotEmpty) {
      final hay = [
        tool.id.value,
        tool.metadata.label ?? '',
        ...tool.metadata.tags,
        ...tool.capabilities.map((c) => c.name),
      ].join(' ').toLowerCase();
      final hit = criteria.contextHints.any(
        (h) => hay.contains(h.toLowerCase()),
      );
      if (!hit) return false;
    }
    return true;
  }

  bool _permissionOk(
    AssistantTool tool,
    AssistantToolSelectionCriteria criteria,
  ) {
    if (criteria.requiredPermissions.isEmpty) return true;
    return criteria.requiredPermissions
        .every(tool.policy.permissions.contains);
  }

  bool _riskOk(AssistantTool tool, AssistantToolSelectionCriteria criteria) {
    if (criteria.maxRisk == null) return true;
    return tool.policy.risk.index <= criteria.maxRisk!.index;
  }
}
