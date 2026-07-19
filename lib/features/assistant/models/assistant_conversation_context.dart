import 'assistant_read_filter.dart';
import 'assistant_read_intent.dart';
import 'assistant_read_pagination.dart';
import 'assistant_read_query.dart';
import 'assistant_read_record.dart';
import 'assistant_read_result.dart';

/// In-memory snapshot of the last successful conversational read turn.
///
/// No persistence — lives only inside an [AssistantConversationSession].
class AssistantConversationContext {
  const AssistantConversationContext({
    this.version = 0,
    this.updatedAt,
    this.lastIntent,
    this.lastQuery,
    this.lastResult,
    this.lastFilters = const [],
    this.lastPagination,
    this.lastQuoteId,
    this.lastQuoteNumber,
    this.lastClientName,
    this.focusedIndex,
  });

  static const empty = AssistantConversationContext();

  final int version;
  final DateTime? updatedAt;
  final AssistantReadIntent? lastIntent;
  final AssistantReadQuery? lastQuery;
  final AssistantReadResult? lastResult;
  final List<AssistantReadFilter> lastFilters;
  final AssistantReadPagination? lastPagination;
  final String? lastQuoteId;
  final String? lastQuoteNumber;
  final String? lastClientName;

  /// Index into [lastResult].records for "esse" / "segundo" / etc.
  final int? focusedIndex;

  bool get isEmpty => version == 0 || lastResult == null;

  List<AssistantReadRecord> get lastRecords =>
      lastResult?.records ?? const [];

  AssistantReadRecord? get focusedRecord {
    final records = lastRecords;
    if (records.isEmpty) return null;
    final index = focusedIndex ?? 0;
    if (index < 0 || index >= records.length) return null;
    return records[index];
  }

  AssistantConversationContext copyWith({
    int? version,
    DateTime? updatedAt,
    AssistantReadIntent? lastIntent,
    AssistantReadQuery? lastQuery,
    AssistantReadResult? lastResult,
    List<AssistantReadFilter>? lastFilters,
    AssistantReadPagination? lastPagination,
    String? lastQuoteId,
    String? lastQuoteNumber,
    String? lastClientName,
    int? focusedIndex,
    bool clearFocusedIndex = false,
    bool clearLastClientName = false,
  }) {
    return AssistantConversationContext(
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
      lastIntent: lastIntent ?? this.lastIntent,
      lastQuery: lastQuery ?? this.lastQuery,
      lastResult: lastResult ?? this.lastResult,
      lastFilters: lastFilters ?? this.lastFilters,
      lastPagination: lastPagination ?? this.lastPagination,
      lastQuoteId: lastQuoteId ?? this.lastQuoteId,
      lastQuoteNumber: lastQuoteNumber ?? this.lastQuoteNumber,
      lastClientName: clearLastClientName
          ? null
          : (lastClientName ?? this.lastClientName),
      focusedIndex:
          clearFocusedIndex ? null : (focusedIndex ?? this.focusedIndex),
    );
  }
}
