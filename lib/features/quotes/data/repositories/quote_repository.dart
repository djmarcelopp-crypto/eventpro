import 'package:eventpro/features/quotes/models/quote.dart';

abstract class QuoteRepository {
  Future<List<Quote>> listAll();

  Future<Quote?> findById(String id);

  /// Persists a new quote graph and returns the persisted [Quote], with the
  /// definitive `number` assigned atomically by the database.
  Future<Quote> insert(Quote quote);

  Future<void> update(Quote quote);
}
