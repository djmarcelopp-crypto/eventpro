import 'assistant_read_metadata.dart';
import 'assistant_read_record.dart';

/// Outcome of a structured read — empty, single, or multiple records.
class AssistantReadResult {
  const AssistantReadResult({
    required this.queryId,
    required this.module,
    required this.records,
    required this.metadata,
    this.valid = true,
    this.failureMessage,
  });

  final String queryId;
  final String module;
  final List<AssistantReadRecord> records;
  final AssistantReadMetadata metadata;
  final bool valid;
  final String? failureMessage;

  bool get isEmpty => records.isEmpty;
  bool get isSingle => records.length == 1;
  bool get isMultiple => records.length > 1;
  AssistantReadRecord? get singleOrNull => isSingle ? records.first : null;

  Map<String, Object?> toDeterministicMap() => {
        'queryId': queryId,
        'module': module,
        'valid': valid,
        'failureMessage': failureMessage,
        'records': records.map((r) => r.toDeterministicMap()).toList(),
        'metadata': metadata.toDeterministicMap(),
      };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantReadResult &&
            other.queryId == queryId &&
            other.module == module &&
            _recordsEqual(other.records, records) &&
            other.metadata == metadata &&
            other.valid == valid &&
            other.failureMessage == failureMessage;
  }

  @override
  int get hashCode => Object.hash(
        queryId,
        module,
        Object.hashAll(records),
        metadata,
        valid,
        failureMessage,
      );

  static bool _recordsEqual(
    List<AssistantReadRecord> a,
    List<AssistantReadRecord> b,
  ) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
