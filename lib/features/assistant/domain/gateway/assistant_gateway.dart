import '../../models/assistant_module_capability.dart';
import 'agenda_gateway.dart';
import 'client_gateway.dart';
import 'inventory_gateway.dart';
import 'quote_gateway.dart';
import 'team_gateway.dart';

/// Facade that exposes only registered read-only module gateways.
///
/// The assistant never reaches repositories through this contract.
abstract class AssistantGateway {
  ClientGateway? get clients;

  AgendaGateway? get agenda;

  QuoteGateway? get quotes;

  InventoryGateway? get inventory;

  TeamGateway? get team;

  bool isRegistered(AssistantModuleCapability capability);
}
