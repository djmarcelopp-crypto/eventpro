import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eventpro/core/database/database_provider.dart';
import 'package:eventpro/features/quotes/data/repositories/drift_quote_repository.dart';
import 'package:eventpro/features/quotes/data/repositories/quote_repository.dart';

final quoteRepositoryProvider = Provider<QuoteRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return DriftQuoteRepository(database);
});
