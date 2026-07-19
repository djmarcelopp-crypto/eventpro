import 'package:eventpro/features/assistant/adapters/in_memory_agenda_gateway.dart';
import 'package:eventpro/features/assistant/adapters/in_memory_client_gateway.dart';
import 'package:eventpro/features/assistant/adapters/in_memory_inventory_gateway.dart';
import 'package:eventpro/features/assistant/adapters/in_memory_quote_gateway.dart';
import 'package:eventpro/features/assistant/adapters/in_memory_team_gateway.dart';
import 'package:eventpro/features/assistant/adapters/local_assistant_gateway.dart';
import 'package:eventpro/features/assistant/models/assistant_module_availability.dart';
import 'package:eventpro/features/assistant/models/assistant_module_capability.dart';
import 'package:eventpro/features/assistant/models/assistant_module_data_source.dart';
import 'package:eventpro/features/assistant/models/assistant_module_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('In-memory read adapters', () {
    test('searchClient returns structured found result', () {
      final gateway = InMemoryClientGateway(
        seed: const [
          InMemoryClientRecord(
            identifier: 'cli-joao',
            displayName: 'João Pereira',
            phone: '34999999999',
          ),
        ],
      );

      final response = gateway.searchClient(
        const AssistantModuleRequest(
          id: 'r1',
          requestId: 'req-1',
          capability: AssistantModuleCapability.searchClient,
          query: 'João',
        ),
      );

      expect(response.availability, AssistantModuleAvailability.available);
      expect(response.dataSource, AssistantModuleDataSource.inMemory);
      expect(response.result?.dataSource, AssistantModuleDataSource.inMemory);
      expect(response.result?.found, isTrue);
      expect(response.result?.displayName, 'João Pereira');
      expect(response.result?.identifier, 'cli-joao');
      expect(response.result?.confidence, greaterThan(0.7));
      expect(response.result?.isErpData, isFalse);
      expect(response.error, isNull);
    });

    test('seed lists are immutable from outside', () {
      final seed = [
        const InMemoryClientRecord(identifier: 'a', displayName: 'Ana'),
      ];
      final gateway = InMemoryClientGateway(seed: seed);
      seed.add(
        const InMemoryClientRecord(identifier: 'b', displayName: 'Bia'),
      );
      final response = gateway.searchClient(
        const AssistantModuleRequest(
          id: 'r2',
          requestId: 'req-2',
          capability: AssistantModuleCapability.searchClient,
          query: 'Bia',
        ),
      );
      expect(response.result?.found, isFalse);
    });

    test('agenda availability and quote lookup stay read-only', () {
      final agenda = InMemoryAgendaGateway(
        seed: const [
          InMemoryAgendaSlot(date: '2026-09-18', title: 'Casamento'),
        ],
      );
      final quotes = InMemoryQuoteGateway(
        seed: const [
          InMemoryQuoteRecord(
            identifier: 'q-1',
            title: 'Orçamento Casamento',
            clientName: 'Maria',
          ),
        ],
      );

      final availability = agenda.checkAvailability(
        const AssistantModuleRequest(
          id: 'a1',
          requestId: 'req-a',
          capability: AssistantModuleCapability.checkAvailability,
          parameters: {'date': '2026-09-18'},
        ),
      );
      expect(availability.result?.found, isFalse);
      expect(availability.result?.summary, contains('Indisponível'));

      final quote = quotes.lookupQuote(
        const AssistantModuleRequest(
          id: 'q1',
          requestId: 'req-q',
          capability: AssistantModuleCapability.lookupQuote,
          query: 'Maria',
        ),
      );
      expect(quote.result?.found, isTrue);
      expect(quote.result?.identifier, 'q-1');
    });

    test('LocalAssistantGateway reports registration without ERP coupling', () {
      final facade = LocalAssistantGateway(
        clients: InMemoryClientGateway(),
        inventory: InMemoryInventoryGateway(
          seed: const [
            InMemoryInventoryRecord(identifier: 'i1', name: 'Som'),
          ],
        ),
        team: InMemoryTeamGateway(
          seed: const [
            InMemoryTeamRecord(
              identifier: 't1',
              displayName: 'Ana',
              role: 'DJ',
            ),
          ],
        ),
      );

      expect(facade.isRegistered(AssistantModuleCapability.searchClient), isTrue);
      expect(
        facade.isRegistered(AssistantModuleCapability.checkSchedule),
        isFalse,
      );
      expect(
        facade.isRegistered(AssistantModuleCapability.searchInventory),
        isTrue,
      );
      expect(facade.isRegistered(AssistantModuleCapability.searchTeam), isTrue);
    });
  });
}
