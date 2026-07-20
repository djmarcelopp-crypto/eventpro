/// Stable identifier for a declared business capability.
class AssistantBusinessCapabilityId {
  const AssistantBusinessCapabilityId(this.value);

  final String value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssistantBusinessCapabilityId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;

  Map<String, Object?> toDeterministicMap() => {'value': value};
}

/// Built-in capability ids (AI-018).
abstract final class AssistantBusinessCapabilityIds {
  static const findClient = AssistantBusinessCapabilityId('FindClient');
  static const createQuote = AssistantBusinessCapabilityId('CreateQuote');
  static const openEvent = AssistantBusinessCapabilityId('OpenEvent');
  static const findEvent = AssistantBusinessCapabilityId('FindEvent');
  static const findQuote = AssistantBusinessCapabilityId('FindQuote');
  static const findContract = AssistantBusinessCapabilityId('FindContract');

  static const all = <AssistantBusinessCapabilityId>[
    findClient,
    createQuote,
    openEvent,
    findEvent,
    findQuote,
    findContract,
  ];
}
