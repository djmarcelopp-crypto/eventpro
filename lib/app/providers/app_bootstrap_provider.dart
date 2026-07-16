import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eventpro/features/catalog/providers/catalog_provider.dart';
import 'package:eventpro/features/catalog/providers/catalog_repository_provider.dart';
import 'package:eventpro/features/clients/providers/client_repository_provider.dart';
import 'package:eventpro/features/clients/providers/clients_provider.dart';
import 'package:eventpro/features/quotes/providers/quote_repository_provider.dart';
import 'package:eventpro/features/quotes/providers/quotes_provider.dart';
import 'package:eventpro/features/settings/providers/company_profile_provider.dart';
import 'package:eventpro/features/settings/providers/company_profile_repository_provider.dart';

class AppBootstrapNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    final clientsFuture = ref.read(clientRepositoryProvider).listAll();
    final companyProfileFuture = ref.read(companyProfileRepositoryProvider).get();
    final catalogFuture = ref.read(catalogRepositoryProvider).listAll();
    final quotesFuture = ref.read(quoteRepositoryProvider).listAll();

    await Future.wait([
      clientsFuture,
      companyProfileFuture,
      catalogFuture,
      quotesFuture,
    ]);

    ref.read(clientsProvider.notifier).hydrate(await clientsFuture);
    ref.read(companyProfileProvider.notifier).hydrate(await companyProfileFuture);
    ref.read(catalogProvider.notifier).hydrate(await catalogFuture);
    ref.read(quotesProvider.notifier).hydrate(await quotesFuture);
  }
}

final appBootstrapProvider = AsyncNotifierProvider<AppBootstrapNotifier, void>(
  AppBootstrapNotifier.new,
);
