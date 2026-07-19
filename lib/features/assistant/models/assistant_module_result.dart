import 'assistant_module_capability.dart';
import 'assistant_module_data_source.dart';

/// Structured read-only payload returned by a module adapter.
///
/// Primary fields are typed. [metadata] is optional supplemental context and
/// must not be required by callers for success handling.
class AssistantModuleResult {
  AssistantModuleResult({
    required this.id,
    required this.capability,
    required this.dataSource,
    required this.found,
    required this.summary,
    this.displayName,
    this.identifier,
    this.confidence,
    Map<String, Object?> metadata = const {},
  }) : metadata = Map.unmodifiable(metadata);

  final String id;
  final AssistantModuleCapability capability;
  final AssistantModuleDataSource dataSource;
  final bool found;
  final String summary;
  final String? displayName;
  final String? identifier;
  final double? confidence;

  /// Optional supplemental facts (never the primary contract).
  final Map<String, Object?> metadata;

  bool get isErpData => dataSource == AssistantModuleDataSource.erp;

  bool get isSimulatedData =>
      dataSource == AssistantModuleDataSource.inMemory ||
      dataSource == AssistantModuleDataSource.demo ||
      dataSource == AssistantModuleDataSource.test;

  AssistantModuleResult copyWith({
    String? id,
    AssistantModuleCapability? capability,
    AssistantModuleDataSource? dataSource,
    bool? found,
    String? summary,
    String? displayName,
    String? identifier,
    double? confidence,
    Map<String, Object?>? metadata,
    bool clearDisplayName = false,
    bool clearIdentifier = false,
    bool clearConfidence = false,
  }) {
    return AssistantModuleResult(
      id: id ?? this.id,
      capability: capability ?? this.capability,
      dataSource: dataSource ?? this.dataSource,
      found: found ?? this.found,
      summary: summary ?? this.summary,
      displayName:
          clearDisplayName ? null : (displayName ?? this.displayName),
      identifier: clearIdentifier ? null : (identifier ?? this.identifier),
      confidence: clearConfidence ? null : (confidence ?? this.confidence),
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantModuleResult &&
            other.id == id &&
            other.capability == capability &&
            other.dataSource == dataSource &&
            other.found == found &&
            other.summary == summary &&
            other.displayName == displayName &&
            other.identifier == identifier &&
            other.confidence == confidence &&
            _mapEquals(other.metadata, metadata);
  }

  @override
  int get hashCode => Object.hash(
        id,
        capability,
        dataSource,
        found,
        summary,
        displayName,
        identifier,
        confidence,
        Object.hashAll(metadata.entries),
      );

  static bool _mapEquals(Map<String, Object?> a, Map<String, Object?> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) return false;
    }
    return true;
  }
}
