import 'assistant_model_provider.dart';
import 'assistant_model_provider_port.dart';
import 'assistant_model_role.dart';

/// Registered binding of descriptor + port.
class AssistantProviderRegistration {
  const AssistantProviderRegistration({
    required this.provider,
    required this.port,
  });

  final AssistantModelProvider provider;
  final AssistantModelProviderPort port;

  Map<String, Object?> toDeterministicMap() => {
        'provider': provider.toDeterministicMap(),
        'portType': port.runtimeType.toString(),
      };
}

/// Registry for model providers (AI-025 CP-3).
///
/// No concrete vendor providers. Callers register ports explicitly.
abstract class AssistantProviderRegistry {
  void register(AssistantProviderRegistration registration);

  void unregister(String providerId);

  void setDefault(String providerId);

  String? get defaultProviderId;

  AssistantProviderRegistration? find(String providerId);

  AssistantModelProviderPort? findPort(String providerId);

  AssistantModelProvider? findProvider(String providerId);

  List<AssistantProviderRegistration> list();

  List<AssistantModelProvider> listProviders();
}

/// Criteria for deterministic provider selection (AI-025 CP-5).
class AssistantProviderSelectionCriteria {
  const AssistantProviderSelectionCriteria({
    this.name,
    this.providerId,
    this.requiredCapabilities = const {},
    this.allowFallback = true,
  });

  final String? name;
  final String? providerId;
  final Set<AssistantModelCapability> requiredCapabilities;
  final bool allowFallback;

  Map<String, Object?> toDeterministicMap() => {
        'name': name,
        'providerId': providerId,
        'requiredCapabilities':
            requiredCapabilities.map((c) => c.name).toList()..sort(),
        'allowFallback': allowFallback,
      };
}

/// Result of a selection attempt.
class AssistantProviderSelection {
  const AssistantProviderSelection({
    required this.registration,
    required this.reason,
    this.fallbackUsed = false,
  });

  final AssistantProviderRegistration registration;
  final String reason;
  final bool fallbackUsed;

  AssistantModelProvider get provider => registration.provider;
  AssistantModelProviderPort get port => registration.port;

  Map<String, Object?> toDeterministicMap() => {
        'providerId': provider.id,
        'reason': reason,
        'fallbackUsed': fallbackUsed,
      };
}

/// Selects a provider by id / name / capability / priority / fallback.
abstract class AssistantProviderSelector {
  AssistantProviderSelection? select({
    required AssistantProviderRegistry registry,
    AssistantProviderSelectionCriteria criteria =
        const AssistantProviderSelectionCriteria(),
  });
}
