/// Navigation / focus target (module-agnostic, no Flutter).
class AssistantActionTarget {
  const AssistantActionTarget({
    required this.module,
    this.routePath,
    this.screenId,
    this.entityType,
    this.entityId,
    this.label,
  });

  final String module;
  final String? routePath;
  final String? screenId;
  final String? entityType;
  final String? entityId;
  final String? label;

  Map<String, Object?> toDeterministicMap() => {
        'module': module,
        'routePath': routePath,
        'screenId': screenId,
        'entityType': entityType,
        'entityId': entityId,
        'label': label,
      };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantActionTarget &&
            other.module == module &&
            other.routePath == routePath &&
            other.screenId == screenId &&
            other.entityType == entityType &&
            other.entityId == entityId &&
            other.label == label;
  }

  @override
  int get hashCode => Object.hash(
        module,
        routePath,
        screenId,
        entityType,
        entityId,
        label,
      );
}

/// Well-known module identifiers for smart actions.
abstract final class AssistantActionModules {
  static const quotes = 'quotes';
  static const clients = 'clients';
  static const dashboard = 'dashboard';
  static const settings = 'settings';
}
