import 'assistant_conversation_context.dart';
import 'assistant_read_filter.dart';
import 'assistant_read_intent.dart';
import 'assistant_read_query.dart';
import 'assistant_read_result.dart';

/// Isolated in-memory conversation session (no globals, no persistence).
class AssistantConversationSession {
  AssistantConversationSession({
    required this.sessionId,
    DateTime Function()? clock,
    AssistantConversationContext? initialContext,
  })  : _clock = clock ?? DateTime.now,
        _context = initialContext ?? AssistantConversationContext.empty;

  final String sessionId;
  final DateTime Function() _clock;
  AssistantConversationContext _context;

  AssistantConversationContext get context => _context;

  void reset() {
    _context = AssistantConversationContext.empty;
  }

  /// Records a successful read turn into the session context.
  void rememberTurn({
    required AssistantReadIntent intent,
    required AssistantReadQuery query,
    required AssistantReadResult result,
    int? focusedIndex,
  }) {
    final records = result.records;

    // Drill-down (esse / segundo / detalhes): keep prior list for ordinals.
    if (focusedIndex != null &&
        records.length == 1 &&
        _context.lastRecords.length > 1 &&
        focusedIndex >= 0 &&
        focusedIndex < _context.lastRecords.length) {
      final detail = records.first;
      _context = _context.copyWith(
        version: _context.version + 1,
        updatedAt: _clock().toUtc(),
        lastIntent: intent,
        lastQuery: query,
        lastQuoteId: detail.id,
        lastQuoteNumber: detail.displayName.isNotEmpty
            ? detail.displayName
            : detail.attributes['number'],
        lastClientName: detail.attributes['clientDisplayName'] ??
            _extractClientFilter(query.filters),
        focusedIndex: focusedIndex,
      );
      return;
    }

    final index = focusedIndex ??
        (records.isEmpty ? null : (records.length == 1 ? 0 : null));
    final focused =
        index != null && index >= 0 && index < records.length
            ? records[index]
            : (records.isNotEmpty ? records.first : null);

    _context = AssistantConversationContext(
      version: _context.version + 1,
      updatedAt: _clock().toUtc(),
      lastIntent: intent,
      lastQuery: query,
      lastResult: result,
      lastFilters: List.unmodifiable(query.filters),
      lastPagination: query.pagination,
      lastQuoteId: focused?.id ?? _context.lastQuoteId,
      lastQuoteNumber: focused?.displayName.isNotEmpty == true
          ? focused!.displayName
          : focused?.attributes['number'] ?? _context.lastQuoteNumber,
      lastClientName: focused?.attributes['clientDisplayName'] ??
          _extractClientFilter(query.filters) ??
          _context.lastClientName,
      focusedIndex: index ?? (records.isNotEmpty ? 0 : null),
    );
  }

  void focusIndex(int index) {
    final records = _context.lastRecords;
    if (index < 0 || index >= records.length) return;
    final focused = records[index];
    _context = _context.copyWith(
      version: _context.version + 1,
      updatedAt: _clock().toUtc(),
      focusedIndex: index,
      lastQuoteId: focused.id,
      lastQuoteNumber: focused.displayName.isNotEmpty
          ? focused.displayName
          : focused.attributes['number'],
      lastClientName: focused.attributes['clientDisplayName'],
    );
  }

  static String? _extractClientFilter(List<AssistantReadFilter> filters) {
    for (final filter in filters) {
      if (filter.field.toLowerCase() == 'clientdisplayname') {
        return filter.value;
      }
    }
    return null;
  }
}
