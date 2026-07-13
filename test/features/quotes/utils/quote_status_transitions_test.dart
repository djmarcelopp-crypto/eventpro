import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/utils/quote_status_transitions.dart';

void main() {
  group('QuoteStatusTransitions', () {
    test('permite transições válidas', () {
      expect(
        QuoteStatusTransitions.isAllowed(QuoteStatus.draft, QuoteStatus.sent),
        isTrue,
      );
      expect(
        QuoteStatusTransitions.isAllowed(
          QuoteStatus.sent,
          QuoteStatus.approved,
        ),
        isTrue,
      );
      expect(
        QuoteStatusTransitions.isAllowed(
          QuoteStatus.approved,
          QuoteStatus.cancelled,
        ),
        isTrue,
      );
      expect(
        QuoteStatusTransitions.isAllowed(
          QuoteStatus.approved,
          QuoteStatus.draft,
        ),
        isTrue,
      );
    });

    test('bloqueia transições inválidas', () {
      expect(
        QuoteStatusTransitions.isAllowed(QuoteStatus.draft, QuoteStatus.approved),
        isFalse,
      );
      expect(
        QuoteStatusTransitions.isAllowed(
          QuoteStatus.sent,
          QuoteStatus.draft,
        ),
        isFalse,
      );
      expect(
        QuoteStatusTransitions.isAllowed(
          QuoteStatus.rejected,
          QuoteStatus.draft,
        ),
        isFalse,
      );
      expect(
        QuoteStatusTransitions.isAllowed(
          QuoteStatus.cancelled,
          QuoteStatus.sent,
        ),
        isFalse,
      );
    });

    test('rejeita transição para o mesmo status', () {
      expect(
        QuoteStatusTransitions.isAllowed(QuoteStatus.draft, QuoteStatus.draft),
        isFalse,
      );
    });
  });
}
