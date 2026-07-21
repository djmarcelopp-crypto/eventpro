import 'package:eventpro/features/assistant/domain/business/reasoning/business_reasoning_confidence.dart';
import 'package:eventpro/features/assistant/domain/business/reasoning/business_reasoning_decision.dart';
import 'package:eventpro/features/assistant/domain/business/reasoning/business_reasoning_issue.dart';
import 'package:eventpro/features/assistant/domain/business/reasoning/business_reasoning_request.dart';
import 'package:eventpro/features/assistant/domain/business/reasoning/business_reasoning_suggestion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-023 CP-1 business reasoning contracts', () {
    test('request/decision imutáveis e explicáveis', () {
      const decision = BusinessReasoningDecision(
        kind: BusinessReasoningDecisionKind.askUser,
        reason: 'Falta cliente',
        confidence: BusinessReasoningConfidence.high,
        appliedRules: ['rule.client.required'],
        evidence: ['clientRequired'],
      );
      expect(decision.toDeterministicMap()['kind'], 'askUser');
      expect(BusinessReasoningConfidence.high.score, 0.85);
      const issue = BusinessReasoningIssue(
        code: BusinessReasoningIssueCode.clientMissing,
        message: 'Cliente ausente',
      );
      expect(issue.toDeterministicMap()['code'], 'clientMissing');
      const suggestion = BusinessReasoningSuggestion(
        code: 'suggest.select_client',
        message: 'Selecione um cliente.',
      );
      expect(suggestion.message, contains('cliente'));
      const request = BusinessReasoningRequest(requestId: 'r1');
      expect(request.toDeterministicMap()['requestId'], 'r1');
    });
  });
}
