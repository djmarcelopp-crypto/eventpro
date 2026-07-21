/// Entity kinds discoverable via Gateway Intelligence (AI-022).
enum GatewayEntityKind {
  client,
  event,
  quote,
  contract,
  supplier,
  product,
  resource,
}

extension GatewayEntityKindX on GatewayEntityKind {
  Map<String, Object?> toDeterministicMap() => {'kind': name};
}
