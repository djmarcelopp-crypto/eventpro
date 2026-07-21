import 'gateway_entity_kind.dart';

/// Opaque entity reference returned by Gateway Intelligence (no ERP models).
class GatewayEntityReference {
  const GatewayEntityReference({
    required this.id,
    required this.kind,
    this.label,
    this.aliases = const [],
  });

  final String id;
  final GatewayEntityKind kind;
  final String? label;
  final List<String> aliases;

  Map<String, Object?> toDeterministicMap() => {
        'id': id,
        'kind': kind.name,
        'label': label,
        'aliases': aliases,
      };
}
