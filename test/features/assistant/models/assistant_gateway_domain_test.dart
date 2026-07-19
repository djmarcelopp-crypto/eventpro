import 'package:eventpro/features/assistant/domain/gateway/agenda_gateway.dart';
import 'package:eventpro/features/assistant/domain/gateway/assistant_gateway.dart';
import 'package:eventpro/features/assistant/domain/gateway/assistant_module_adapter.dart';
import 'package:eventpro/features/assistant/domain/gateway/client_gateway.dart';
import 'package:eventpro/features/assistant/domain/gateway/inventory_gateway.dart';
import 'package:eventpro/features/assistant/domain/gateway/quote_gateway.dart';
import 'package:eventpro/features/assistant/domain/gateway/team_gateway.dart';
import 'package:eventpro/features/assistant/models/assistant_module_availability.dart';
import 'package:eventpro/features/assistant/models/assistant_module_capability.dart';
import 'package:eventpro/features/assistant/models/assistant_module_data_source.dart';
import 'package:eventpro/features/assistant/models/assistant_module_error.dart';
import 'package:eventpro/features/assistant/models/assistant_module_request.dart';
import 'package:eventpro/features/assistant/models/assistant_module_response.dart';
import 'package:eventpro/features/assistant/models/assistant_module_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Assistant gateway domain', () {
    test('module request response result carry typed fields and dataSource',
        () {
      const request = AssistantModuleRequest(
        id: 'mod-req-1',
        requestId: 'req-1',
        capability: AssistantModuleCapability.searchClient,
        query: 'Maria',
      );
      final result = AssistantModuleResult(
        id: 'res-1',
        capability: AssistantModuleCapability.searchClient,
        dataSource: AssistantModuleDataSource.inMemory,
        found: true,
        displayName: 'Maria Silva',
        identifier: 'cli-1',
        confidence: 0.92,
        summary: 'Cliente encontrado',
      );
      const error = AssistantModuleError(
        code: 'adapter_failure',
        message: 'Falha encapsulada',
      );
      final response = AssistantModuleResponse(
        requestId: 'req-1',
        capability: AssistantModuleCapability.searchClient,
        availability: AssistantModuleAvailability.available,
        dataSource: AssistantModuleDataSource.inMemory,
        result: result,
      );

      expect(request.query, 'Maria');
      expect(result.found, isTrue);
      expect(result.isSimulatedData, isTrue);
      expect(result.isErpData, isFalse);
      expect(response.isSuccess, isTrue);
      expect(response.isSimulated, isTrue);
      expect(error.code, 'adapter_failure');
      expect(
        response.copyWith(error: error, clearResult: true).isSuccess,
        isFalse,
      );
      expect(
        () => result.metadata['x'] = 1,
        throwsUnsupportedError,
      );
    });

    test('gateway contracts and data sources are explicit', () {
      expect(
        AssistantModuleCapability.values,
        containsAll([
          AssistantModuleCapability.searchClient,
          AssistantModuleCapability.checkSchedule,
          AssistantModuleCapability.checkAvailability,
          AssistantModuleCapability.lookupQuote,
          AssistantModuleCapability.searchInventory,
          AssistantModuleCapability.searchTeam,
        ]),
      );
      expect(
        AssistantModuleDataSource.values,
        containsAll([
          AssistantModuleDataSource.inMemory,
          AssistantModuleDataSource.demo,
          AssistantModuleDataSource.test,
          AssistantModuleDataSource.erp,
          AssistantModuleDataSource.remote,
        ]),
      );
      expect(ClientGateway, isNotNull);
      expect(AgendaGateway, isNotNull);
      expect(QuoteGateway, isNotNull);
      expect(InventoryGateway, isNotNull);
      expect(TeamGateway, isNotNull);
      expect(AssistantGateway, isNotNull);
      expect(AssistantModuleAdapter, isNotNull);
    });
  });
}
