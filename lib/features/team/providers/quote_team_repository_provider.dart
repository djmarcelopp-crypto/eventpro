import 'package:eventpro/core/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/drift_quote_team_repository.dart';
import '../data/repositories/quote_team_repository.dart';

final quoteTeamRepositoryProvider = Provider<QuoteTeamRepository>((ref) {
  return DriftQuoteTeamRepository(ref.watch(appDatabaseProvider));
});
