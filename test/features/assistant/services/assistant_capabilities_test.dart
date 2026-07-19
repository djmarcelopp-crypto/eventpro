import 'package:eventpro/features/assistant/models/assistant_integration_mode.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AssistantCapabilities', () {
    test('localDefaults enables planning and disables all execution', () {
      final caps = AssistantCapabilities.localDefaults();
      expect(caps.integrationMode, AssistantIntegrationMode.none);
      expect(caps.canPlanCreateEvent, isTrue);
      expect(caps.canPlanCreateQuote, isTrue);
      expect(caps.canPlanCheckSchedule, isTrue);
      expect(caps.canPlanCheckAvailability, isTrue);
      expect(caps.canPlanSearchClient, isTrue);
      expect(caps.canPlanLookupQuote, isFalse);
      expect(caps.canPlanSearchInventory, isFalse);
      expect(caps.canPlanSearchTeam, isFalse);

      expect(caps.canExecuteCreateEvent, isFalse);
      expect(caps.canExecuteCreateQuote, isFalse);
      expect(caps.canExecuteScheduleRead, isFalse);
      expect(caps.canExecuteAvailabilityRead, isFalse);
      expect(caps.canExecuteClientSearch, isFalse);
      expect(caps.canExecuteLookupQuote, isFalse);
      expect(caps.anyExecutionEnabled, isFalse);
      expect(caps.claimsErpIntegration, isFalse);

      expect(caps.canUseOCR, isFalse);
      expect(caps.canUseSpeech, isFalse);
      expect(caps.canUseVision, isFalse);
      expect(caps.canUseLLM, isFalse);
    });

    test('copyWith can simulate future executors without enabling by default',
        () {
      final caps = AssistantCapabilities.localDefaults().copyWith(
        canExecuteCreateEvent: true,
        canPlanSearchClient: false,
      );
      expect(caps.canExecuteCreateEvent, isTrue);
      expect(caps.canPlanSearchClient, isFalse);
      expect(caps.canExecuteCreateQuote, isFalse);
      expect(caps.anyExecutionEnabled, isTrue);
    });

    test('localReadIntegration enables only in-memory read executors', () {
      final caps = AssistantCapabilities.localReadIntegration();
      expect(caps.integrationMode, AssistantIntegrationMode.inMemory);
      expect(caps.canExecuteClientSearch, isTrue);
      expect(caps.canExecuteScheduleRead, isTrue);
      expect(caps.canExecuteAvailabilityRead, isTrue);
      expect(caps.canExecuteCreateEvent, isFalse);
      expect(caps.canExecuteCreateQuote, isFalse);
      expect(caps.anyWriteExecutionEnabled, isFalse);
      expect(caps.claimsErpIntegration, isFalse);
    });
  });
}
