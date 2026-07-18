import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/app/providers/app_bootstrap_provider.dart';
import 'package:eventpro/features/agenda/models/agenda_block.dart';
import 'package:eventpro/features/agenda/providers/agenda_blocks_provider.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/providers/catalog_provider.dart';
import 'package:eventpro/features/clients/models/client.dart';
import 'package:eventpro/features/clients/providers/client_repository_provider.dart';
import 'package:eventpro/features/clients/providers/clients_provider.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/providers/quotes_provider.dart';
import 'package:eventpro/features/settings/models/company_profile.dart';
import 'package:eventpro/features/settings/providers/company_profile_provider.dart';

import '../../features/agenda/fakes/agenda_block_repository_test_overrides.dart';
import '../../features/agenda/fakes/fake_agenda_block_repository.dart';
import '../../features/catalog/fakes/catalog_repository_test_overrides.dart';
import '../../features/catalog/fakes/fake_catalog_repository.dart';
import '../../features/clients/fakes/fake_client_repository.dart';
import '../../features/quotes/fakes/fake_quote_repository.dart';
import '../../features/quotes/fakes/quote_repository_test_overrides.dart';
import '../../features/quotes/quotes_test_helpers.dart';
import '../../features/settings/fakes/company_profile_repository_test_overrides.dart';
import '../../features/settings/fakes/fake_company_profile_repository.dart';

void main() {
  group('AppBootstrapProvider', () {
    late Client seededClient;
    late CompanyProfile seededProfile;
    late CatalogItem seededCatalogItem;
    late Quote seededQuote;
    late AgendaBlock seededAgendaBlock;

    late FakeClientRepository clientRepository;
    late FakeCompanyProfileRepository companyProfileRepository;
    late FakeCatalogRepository catalogRepository;
    late FakeQuoteRepository quoteRepository;
    late FakeAgendaBlockRepository agendaBlockRepository;
    late ProviderContainer container;

    ProviderContainer createContainer() {
      return ProviderContainer(
        overrides: [
          clientRepositoryProvider.overrideWithValue(clientRepository),
          ...companyProfileRepositoryOverrides(
            repository: companyProfileRepository,
          ),
          ...catalogRepositoryOverrides(repository: catalogRepository),
          ...quoteRepositoryOverrides(repository: quoteRepository),
          ...agendaBlockRepositoryOverrides(repository: agendaBlockRepository),
        ],
      );
    }

    Future<void> expectAllProvidersHydrated() async {
      expect(container.read(clientsProvider), [seededClient]);
      expect(container.read(companyProfileProvider), seededProfile);
      expect(container.read(catalogProvider), [seededCatalogItem]);
      expect(container.read(quotesProvider), [seededQuote]);
      expect(await container.read(agendaBlocksProvider.future), [
        seededAgendaBlock,
      ]);
    }

    Future<void> expectNoProviderHydrated() async {
      expect(container.read(clientsProvider), isEmpty);
      expect(container.read(companyProfileProvider), isNull);
      expect(container.read(catalogProvider), isEmpty);
      expect(container.read(quotesProvider), isEmpty);
      expect(await container.read(agendaBlocksProvider.future), isEmpty);
    }

    setUp(() {
      seededClient = sampleClient();
      seededProfile = sampleConfiguredCompanyProfile();
      seededCatalogItem = sampleCatalogItem();
      seededQuote = sampleQuoteDraft();
      seededAgendaBlock = AgendaBlock(
        id: 'block-1',
        title: 'Montagem de palco',
        start: DateTime(2026, 8, 20, 8, 0),
        end: DateTime(2026, 8, 20, 12, 0),
        createdAt: DateTime(2026, 8, 1),
        updatedAt: DateTime(2026, 8, 1),
      );

      clientRepository = FakeClientRepository(initialClients: [seededClient]);
      companyProfileRepository = FakeCompanyProfileRepository(
        initialProfile: seededProfile,
      );
      catalogRepository = FakeCatalogRepository(
        initialItems: [seededCatalogItem],
      );
      quoteRepository = FakeQuoteRepository(initialQuotes: [seededQuote]);
      agendaBlockRepository = FakeAgendaBlockRepository(
        initialBlocks: [seededAgendaBlock],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test(
      'bootstrap com sucesso hidrata os cinco providers a partir dos repositories',
      () async {
        container = createContainer();

        await container.read(appBootstrapProvider.future);

        expect(
          container.read(appBootstrapProvider),
          const AsyncData<void>(null),
        );
        await expectAllProvidersHydrated();
      },
    );

    test(
      'falha em um repository deixa o bootstrap em erro e nenhum provider é hidratado',
      () async {
        quoteRepository.shouldFailOnNextOperation = true;
        container = createContainer();

        await expectLater(
          container.read(appBootstrapProvider.future),
          throwsA(isA<StateError>()),
        );

        expect(container.read(appBootstrapProvider).hasError, isTrue);
        await expectNoProviderHydrated();
      },
    );

    test(
      'falha no repository da Agenda deixa o bootstrap em erro e nenhum provider é hidratado',
      () async {
        agendaBlockRepository.shouldFailOnNextOperation = true;
        container = createContainer();

        await expectLater(
          container.read(appBootstrapProvider.future),
          throwsA(isA<StateError>()),
        );

        expect(container.read(appBootstrapProvider).hasError, isTrue);
        await expectNoProviderHydrated();
      },
    );

    test(
      'retry após falha executa o bootstrap novamente e hidrata com sucesso',
      () async {
        quoteRepository.shouldFailOnNextOperation = true;
        container = createContainer();

        await expectLater(
          container.read(appBootstrapProvider.future),
          throwsA(isA<StateError>()),
        );
        expect(container.read(appBootstrapProvider).hasError, isTrue);
        await expectNoProviderHydrated();

        container.invalidate(appBootstrapProvider);
        await container.read(appBootstrapProvider.future);

        expect(
          container.read(appBootstrapProvider),
          const AsyncData<void>(null),
        );
        await expectAllProvidersHydrated();
      },
    );

    test(
      'retry após falha na Agenda executa o bootstrap novamente e hidrata com sucesso',
      () async {
        agendaBlockRepository.shouldFailOnNextOperation = true;
        container = createContainer();

        await expectLater(
          container.read(appBootstrapProvider.future),
          throwsA(isA<StateError>()),
        );
        expect(container.read(appBootstrapProvider).hasError, isTrue);
        await expectNoProviderHydrated();

        container.invalidate(appBootstrapProvider);
        await container.read(appBootstrapProvider.future);

        expect(
          container.read(appBootstrapProvider),
          const AsyncData<void>(null),
        );
        await expectAllProvidersHydrated();
      },
    );
  });
}
