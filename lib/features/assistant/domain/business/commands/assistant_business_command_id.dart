/// Stable identifier for a declared business command.
class AssistantBusinessCommandId {
  const AssistantBusinessCommandId(this.value);

  final String value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssistantBusinessCommandId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;

  Map<String, Object?> toDeterministicMap() => {'value': value};
}

/// Built-in command ids (AI-019) — bridge to AI-018 capability ids via metadata.
abstract final class AssistantBusinessCommandIds {
  static const findClient = AssistantBusinessCommandId('FindClientCommand');
  static const createQuote = AssistantBusinessCommandId('CreateQuoteCommand');
  static const openEvent = AssistantBusinessCommandId('OpenEventCommand');
  static const findEvent = AssistantBusinessCommandId('FindEventCommand');
  static const findQuote = AssistantBusinessCommandId('FindQuoteCommand');
  static const findContract = AssistantBusinessCommandId('FindContractCommand');

  static const all = <AssistantBusinessCommandId>[
    findClient,
    createQuote,
    openEvent,
    findEvent,
    findQuote,
    findContract,
  ];
}
