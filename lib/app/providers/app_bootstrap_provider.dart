import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:eventpro/features/agenda/providers/agenda_block_repository_provider.dart';
import 'package:eventpro/features/agenda/providers/agenda_blocks_provider.dart';
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
    final agendaBlocksFuture = ref.read(agendaBlockRepositoryProvider).listAll();

    await Future.wait([
      clientsFuture,
      companyProfileFuture,
      catalogFuture,
      quotesFuture,
      agendaBlocksFuture,
    ]);

    ref.read(clientsProvider.notifier).hydrate(await clientsFuture);
    ref.read(companyProfileProvider.notifier).hydrate(await companyProfileFuture);
    ref.read(catalogProvider.notifier).hydrate(await catalogFuture);
    ref.read(quotesProvider.notifier).hydrate(await quotesFuture);

    // AgendaBlocksNotifier é assíncrono: é necessário aguardar a conclusão do
    // seu build() trivial antes de hidratar, para que o resultado do build()
    // não sobrescreva o estado hidratado por uma corrida de microtasks.
    await ref.read(agendaBlocksProvider.future);
    ref.read(agendaBlocksProvider.notifier).hydrate(await agendaBlocksFuture);
  }
}

final appBootstrapProvider = AsyncNotifierProvider<AppBootstrapNotifier, void>(
  AppBootstrapNotifier.new,
);
