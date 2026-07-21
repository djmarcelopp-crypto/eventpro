import 'package:eventpro/features/assistant/domain/context/assistant_conversation.dart';
import 'package:eventpro/features/assistant/domain/context/assistant_conversation_id.dart';
import 'package:eventpro/features/assistant/domain/context/assistant_conversation_metadata.dart';
import 'package:eventpro/features/assistant/domain/context/assistant_conversation_state.dart';
import 'package:eventpro/features/assistant/domain/context/assistant_conversation_status.dart';
import 'package:eventpro/features/assistant/domain/context/assistant_conversation_summary.dart';
import 'package:eventpro/features/assistant/domain/context/assistant_conversation_turn.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 7, 20, 22);

  group('AI-021 CP-1 conversation contracts', () {
    test('imutáveis e rastreáveis', () {
      const id = AssistantConversationId('c1');
      final turn = AssistantConversationTurn(
        turnIndex: 0,
        timestamp: now,
        requestId: 'r1',
        intentLabel: 'create_quote',
        commandIds: const ['cmd.search_client'],
        entityRefs: const ['client:1'],
      );
      final conversation = AssistantConversation(
        id: id,
        createdAt: now,
        updatedAt: now,
        metadata: const AssistantConversationMetadata(sessionId: 's1'),
        state: const AssistantConversationState(
          lastIntentLabel: 'create_quote',
          activeClientId: 'client:1',
        ),
        turns: [turn],
        status: AssistantConversationStatus.active,
      );

      expect(conversation.id.value, 'c1');
      expect(conversation.lastTurn?.intentLabel, 'create_quote');
      expect(conversation.toSnapshot().recentTurns, hasLength(1));
      expect(
        conversation.toDeterministicMap()['status'],
        'active',
      );
      expect(
        conversation.summary,
        AssistantConversationSummary.empty,
      );
    });

    test('status e summary tipados', () {
      expect(AssistantConversationStatus.values.map((e) => e.name), [
        'active',
        'idle',
        'summarized',
        'closed',
      ]);
      const summary = AssistantConversationSummary(
        text: 'intents=a',
        intentLabels: ['a'],
        coveredTurnCount: 2,
      );
      expect(summary.isEmpty, isFalse);
      expect(summary.toDeterministicMap()['coveredTurnCount'], 2);
    });
  });
}
