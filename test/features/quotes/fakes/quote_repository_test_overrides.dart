import 'package:eventpro/features/quotes/data/repositories/quote_repository.dart';
import 'package:eventpro/features/quotes/providers/quote_repository_provider.dart';
import 'package:flutter_riverpod/misc.dart';

import 'fake_quote_repository.dart';

List<Override> quoteRepositoryOverrides({QuoteRepository? repository}) {
  return [
    quoteRepositoryProvider.overrideWithValue(
      repository ?? FakeQuoteRepository(),
    ),
  ];
}
