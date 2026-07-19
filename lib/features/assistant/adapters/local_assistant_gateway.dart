import '../domain/gateway/agenda_gateway.dart';
import '../domain/gateway/assistant_gateway.dart';
import '../domain/gateway/client_gateway.dart';
import '../domain/gateway/inventory_gateway.dart';
import '../domain/gateway/quote_gateway.dart';
import '../domain/gateway/team_gateway.dart';
import '../models/assistant_module_capability.dart';
import '../models/assistant_module_data_source.dart';

/// Local composition root for read-only gateways.
///
/// AI-003 only wires in-memory adapters. [dataSource] is always [inMemory]
/// for this facade — never claims ERP.
class LocalAssistantGateway implements AssistantGateway {
  const LocalAssistantGateway({
    this.clients,
    this.agenda,
    this.quotes,
    this.inventory,
    this.team,
    this.dataSource = AssistantModuleDataSource.inMemory,
  }) : assert(
          dataSource != AssistantModuleDataSource.erp &&
              dataSource != AssistantModuleDataSource.remote,
          'LocalAssistantGateway cannot claim ERP/remote data sources',
        );

  @override
  final ClientGateway? clients;

  @override
  final AgendaGateway? agenda;

  @override
  final QuoteGateway? quotes;

  @override
  final InventoryGateway? inventory;

  @override
  final TeamGateway? team;

  /// Kind of adapters composed by this gateway (AI-003: inMemory only).
  final AssistantModuleDataSource dataSource;

  @override
  bool isRegistered(AssistantModuleCapability capability) {
    return switch (capability) {
      AssistantModuleCapability.searchClient => clients != null,
      AssistantModuleCapability.checkSchedule ||
      AssistantModuleCapability.checkAvailability =>
        agenda != null,
      AssistantModuleCapability.lookupQuote => quotes != null,
      AssistantModuleCapability.searchInventory => inventory != null,
      AssistantModuleCapability.searchTeam => team != null,
    };
  }
}
