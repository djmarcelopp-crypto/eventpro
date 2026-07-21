import '../domain/model_provider/assistant_model_role.dart';
import '../domain/model_provider/assistant_provider_registry.dart';

/// Deterministic provider selection (AI-025 CP-5).
///
/// Order:
/// 1. Exact providerId
/// 2. Exact name (case-insensitive)
/// 3. Highest priority among providers that support all required capabilities
/// 4. Default provider (fallback), if allowed and capable
class LocalAssistantProviderSelector implements AssistantProviderSelector {
  const LocalAssistantProviderSelector();

  @override
  AssistantProviderSelection? select({
    required AssistantProviderRegistry registry,
    AssistantProviderSelectionCriteria criteria =
        const AssistantProviderSelectionCriteria(),
  }) {
    final all = registry.list();
    if (all.isEmpty) return null;

    if (criteria.providerId != null) {
      final hit = registry.find(criteria.providerId!);
      if (hit != null &&
          _supports(hit, criteria.requiredCapabilities)) {
        return AssistantProviderSelection(
          registration: hit,
          reason: 'provider_id',
        );
      }
      if (!criteria.allowFallback) return null;
    }

    if (criteria.name != null) {
      final needle = criteria.name!.toLowerCase();
      final named = all.where(
        (r) => r.provider.name.toLowerCase() == needle,
      );
      final capable = named
          .where((r) => _supports(r, criteria.requiredCapabilities))
          .toList();
      if (capable.isNotEmpty) {
        capable.sort(_byPriorityDesc);
        return AssistantProviderSelection(
          registration: capable.first,
          reason: 'name',
        );
      }
      if (!criteria.allowFallback) return null;
    }

    final capable = all
        .where((r) => _supports(r, criteria.requiredCapabilities))
        .toList();
    if (capable.isNotEmpty) {
      capable.sort(_byPriorityDesc);
      return AssistantProviderSelection(
        registration: capable.first,
        reason: criteria.requiredCapabilities.isEmpty
            ? 'priority'
            : 'capability_priority',
      );
    }

    if (!criteria.allowFallback) return null;

    final defaultId = registry.defaultProviderId;
    if (defaultId == null) return null;
    final fallback = registry.find(defaultId);
    if (fallback == null) return null;
    return AssistantProviderSelection(
      registration: fallback,
      reason: 'default_fallback',
      fallbackUsed: true,
    );
  }

  bool _supports(
    AssistantProviderRegistration registration,
    Set<AssistantModelCapability> required,
  ) {
    if (required.isEmpty) return true;
    return registration.provider.capabilities.supportsAll(required);
  }

  int _byPriorityDesc(
    AssistantProviderRegistration a,
    AssistantProviderRegistration b,
  ) {
    final byPriority = b.provider.priority.compareTo(a.provider.priority);
    if (byPriority != 0) return byPriority;
    return a.provider.id.compareTo(b.provider.id);
  }
}
