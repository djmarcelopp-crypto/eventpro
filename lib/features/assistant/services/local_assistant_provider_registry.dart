import '../domain/model_provider/assistant_model_provider.dart';
import '../domain/model_provider/assistant_model_provider_port.dart';
import '../domain/model_provider/assistant_provider_registry.dart';

/// In-process provider registry (AI-025). No vendor SDKs.
class LocalAssistantProviderRegistry implements AssistantProviderRegistry {
  LocalAssistantProviderRegistry();

  final Map<String, AssistantProviderRegistration> _byId = {};
  String? _defaultProviderId;

  @override
  String? get defaultProviderId => _defaultProviderId;

  @override
  void register(AssistantProviderRegistration registration) {
    _byId[registration.provider.id] = registration;
    _defaultProviderId ??= registration.provider.id;
  }

  @override
  void unregister(String providerId) {
    _byId.remove(providerId);
    if (_defaultProviderId == providerId) {
      _defaultProviderId = _byId.keys.isEmpty ? null : _byId.keys.first;
    }
  }

  @override
  void setDefault(String providerId) {
    if (!_byId.containsKey(providerId)) {
      throw ArgumentError.value(
        providerId,
        'providerId',
        'Provider is not registered',
      );
    }
    _defaultProviderId = providerId;
  }

  @override
  AssistantProviderRegistration? find(String providerId) => _byId[providerId];

  @override
  AssistantModelProviderPort? findPort(String providerId) =>
      _byId[providerId]?.port;

  @override
  AssistantModelProvider? findProvider(String providerId) =>
      _byId[providerId]?.provider;

  @override
  List<AssistantProviderRegistration> list() =>
      List.unmodifiable(_byId.values.toList());

  @override
  List<AssistantModelProvider> listProviders() =>
      List.unmodifiable(_byId.values.map((r) => r.provider).toList());

  void clear() {
    _byId.clear();
    _defaultProviderId = null;
  }
}
