import '../data/repositories/quote_repository.dart';
import '../models/quote.dart';
import '../models/quote_status.dart';

/// Read-only quote queries for the assistant adapter.
///
/// Uses [QuoteRepository] only — never DAO. List operations reuse [listAll]
/// with mandatory pagination and an explicit hard scan cap.
class QuoteQueryService {
  QuoteQueryService(
    this._repository, {
    this.maxScan = defaultMaxScan,
  });

  static const int defaultMaxScan = 500;

  final QuoteRepository _repository;
  final int maxScan;

  Future<Quote?> findById(String id) => _repository.findById(id);

  /// Filtered, sorted, paginated quote page.
  ///
  /// When [id] is set, uses [findById] and ignores list scan.
  Future<QuoteQueryPage> query({
    String? id,
    String? number,
    bool numberContains = false,
    QuoteStatus? status,
    Set<QuoteStatus>? statuses,
    String? clientDisplayNameContains,
    required int offset,
    required int limit,
    String sortField = 'createdAt',
    bool ascending = false,
  }) async {
    final safeOffset = offset < 0 ? 0 : offset;
    final safeLimit = limit < 1 ? 1 : limit;
    final statusSet = {
      ?status,
      ...?statuses,
    };

    if (id != null && id.trim().isNotEmpty) {
      final quote = await _repository.findById(id.trim());
      final matched = quote == null
          ? const <Quote>[]
          : _matches(
              quote,
              number: number,
              numberContains: numberContains,
              statusSet: statusSet,
              clientDisplayNameContains: clientDisplayNameContains,
            )
              ? [quote]
              : const <Quote>[];
      return QuoteQueryPage(
        items: matched,
        totalMatched: matched.length,
        scannedCount: matched.length,
        scanCapped: false,
      );
    }

    final all = await _repository.listAll();
    final scanCapped = all.length > maxScan;
    final scan = scanCapped ? all.take(maxScan).toList(growable: false) : all;

    final matched = scan
        .where(
          (q) => _matches(
            q,
            number: number,
            numberContains: numberContains,
            statusSet: statusSet,
            clientDisplayNameContains: clientDisplayNameContains,
          ),
        )
        .toList(growable: false);
    _sortInPlace(matched, sortField: sortField, ascending: ascending);

    final page =
        matched.skip(safeOffset).take(safeLimit).toList(growable: false);
    return QuoteQueryPage(
      items: page,
      totalMatched: matched.length,
      scannedCount: scan.length,
      scanCapped: scanCapped,
    );
  }

  static bool _matches(
    Quote quote, {
    String? number,
    bool numberContains = false,
    required Set<QuoteStatus> statusSet,
    String? clientDisplayNameContains,
  }) {
    if (number != null && number.trim().isNotEmpty) {
      final needle = number.trim().toLowerCase();
      final hay = quote.number.toLowerCase();
      if (numberContains) {
        if (!hay.contains(needle)) return false;
      } else if (hay != needle) {
        return false;
      }
    }
    if (statusSet.isNotEmpty && !statusSet.contains(quote.status)) {
      return false;
    }
    if (clientDisplayNameContains != null &&
        clientDisplayNameContains.trim().isNotEmpty) {
      final needle = clientDisplayNameContains.trim().toLowerCase();
      if (!quote.clientSnapshot.displayName.toLowerCase().contains(needle)) {
        return false;
      }
    }
    return true;
  }

  static void _sortInPlace(
    List<Quote> quotes, {
    required String sortField,
    required bool ascending,
  }) {
    int cmp(Quote a, Quote b) {
      switch (sortField) {
        case 'number':
          return a.number.compareTo(b.number);
        case 'status':
          return a.status.name.compareTo(b.status.name);
        case 'updatedAt':
          return a.updatedAt.compareTo(b.updatedAt);
        case 'createdAt':
        default:
          return a.createdAt.compareTo(b.createdAt);
      }
    }

    quotes.sort((a, b) => ascending ? cmp(a, b) : cmp(b, a));
  }
}

class QuoteQueryPage {
  const QuoteQueryPage({
    required this.items,
    required this.totalMatched,
    required this.scannedCount,
    required this.scanCapped,
  });

  final List<Quote> items;
  final int totalMatched;
  final int scannedCount;
  final bool scanCapped;
}
