import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import '../quotes_test_helpers.dart';

void main() {
  group('Quote imutabilidade', () {
    test('mutar lista original não altera Quote.items', () {
      final items = [sampleLineItem()];
      final quote = sampleQuoteDraft(items: items);

      items.add(sampleLineItem(quantity: 3));

      expect(quote.items, hasLength(1));
    });

    test('isApprovedForContract depende somente do status', () {
      final draft = sampleQuoteDraft();
      expect(draft.isApprovedForContract, isFalse);

      final approved = draft.copyWith(status: QuoteStatus.approved);
      expect(approved.isApprovedForContract, isTrue);
    });
  });
}
