import 'assistant_insight_kind.dart';

/// Planned insight request — no I/O, module-agnostic.
class AssistantInsightRequest {
  const AssistantInsightRequest({
    required this.id,
    required this.requestId,
    required this.module,
    required this.kind,
    this.statusToken,
    this.groupBy,
    this.entityField,
    this.referenceTimestamp,
    this.requiredCapabilities = const {},
  });

  final String id;
  final String requestId;
  final String module;
  final AssistantInsightKind kind;

  /// Lexical status token for filtered counts (e.g. `aberto`, `rascunho`).
  final String? statusToken;

  /// Dimension key for distribution / top entity (e.g. `status`, `client`).
  final String? groupBy;

  /// Entity field for TOP_ENTITY (e.g. `clientDisplayName`).
  final String? entityField;

  /// Anchor clock for CREATED_THIS_MONTH (UTC month of this instant).
  final DateTime? referenceTimestamp;

  final Set<String> requiredCapabilities;

  Map<String, Object?> toDeterministicMap() => {
        'id': id,
        'requestId': requestId,
        'module': module,
        'kind': kind.name,
        'statusToken': statusToken,
        'groupBy': groupBy,
        'entityField': entityField,
        'referenceTimestamp': referenceTimestamp?.toUtc().toIso8601String(),
        'requiredCapabilities': requiredCapabilities.toList()..sort(),
      };
}

/// Well-known insight module identifiers (strings only — no ERP imports).
abstract final class AssistantInsightModules {
  static const quote = 'quote';
}

/// Capability keys required by insight requests.
abstract final class AssistantInsightCapabilities {
  static const quoteInsights = 'quoteInsights';
}
