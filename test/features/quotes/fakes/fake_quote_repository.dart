import 'package:eventpro/features/quotes/data/repositories/quote_repository.dart';
import 'package:eventpro/features/quotes/models/quote.dart';

class FakeQuoteRepository implements QuoteRepository {
  FakeQuoteRepository({List<Quote>? initialQuotes})
    : _quotes = List<Quote>.from(initialQuotes ?? const []);

  final List<Quote> _quotes;
  final Map<int, int> _lastSequenceByYear = {};
  var shouldFailOnNextOperation = false;

  @override
  Future<List<Quote>> listAll() async {
    _failIfRequested();
    return List<Quote>.unmodifiable(_quotes);
  }

  @override
  Future<Quote?> findById(String id) async {
    _failIfRequested();
    for (final quote in _quotes) {
      if (quote.id == id) {
        return quote;
      }
    }
    return null;
  }

  @override
  Future<Quote> insert(Quote quote) async {
    _failIfRequested();
    final year = quote.createdAt.year;
    final nextSequence = (_lastSequenceByYear[year] ?? 0) + 1;
    final number = 'ORC-$year-${nextSequence.toString().padLeft(4, '0')}';
    _lastSequenceByYear[year] = nextSequence;

    final persisted = quote.copyWith(number: number);
    _quotes.add(persisted);
    return persisted;
  }

  @override
  Future<void> update(Quote quote) async {
    _failIfRequested();
    final index = _quotes.indexWhere((current) => current.id == quote.id);
    if (index == -1) {
      throw StateError('Quote not found for update: ${quote.id}');
    }
    _quotes[index] = quote;
  }

  void _failIfRequested() {
    if (!shouldFailOnNextOperation) {
      return;
    }
    shouldFailOnNextOperation = false;
    throw StateError('Simulated repository failure');
  }
}
