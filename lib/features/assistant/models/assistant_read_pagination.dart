/// Mandatory pagination for structured reads.
///
/// Adapters/services must never return unbounded result sets.
class AssistantReadPagination {
  const AssistantReadPagination({
    this.offset = 0,
    this.limit = defaultLimit,
  });

  static const int defaultLimit = 10;
  static const int maxLimit = 50;

  final int offset;
  final int limit;

  bool get isValid => offset >= 0 && limit > 0 && limit <= maxLimit;

  AssistantReadPagination clampToMax() {
    final clampedLimit = limit < 1
        ? defaultLimit
        : (limit > maxLimit ? maxLimit : limit);
    final clampedOffset = offset < 0 ? 0 : offset;
    return AssistantReadPagination(offset: clampedOffset, limit: clampedLimit);
  }

  Map<String, Object?> toDeterministicMap() => {
        'offset': offset < 0 ? 0 : offset,
        'limit': limit < 0 ? 0 : limit,
      };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantReadPagination &&
            other.offset == offset &&
            other.limit == limit;
  }

  @override
  int get hashCode => Object.hash(offset, limit);
}
