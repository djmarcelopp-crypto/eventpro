/// Opaque identity shared across assistant workflows without ERP models.
abstract class AssistantBusinessReference {
  const AssistantBusinessReference({
    required this.id,
    this.label,
  });

  /// Stable opaque id (never an ERP row object).
  final String id;
  final String? label;

  String get kind;

  Map<String, Object?> toDeterministicMap() => {
        'kind': kind,
        'id': id,
        'label': label,
      };
}

/// Client identity reference.
class ClientReference extends AssistantBusinessReference {
  const ClientReference({required super.id, super.label});

  @override
  String get kind => 'client';
}

/// Quote identity reference.
class QuoteReference extends AssistantBusinessReference {
  const QuoteReference({required super.id, super.label});

  @override
  String get kind => 'quote';
}

/// Event identity reference.
class EventReference extends AssistantBusinessReference {
  const EventReference({required super.id, super.label});

  @override
  String get kind => 'event';
}

/// Contract identity reference.
class ContractReference extends AssistantBusinessReference {
  const ContractReference({required super.id, super.label});

  @override
  String get kind => 'contract';
}
