import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote_line_draft.dart';
import 'package:eventpro/features/quotes/state/quote_form_state.dart';

void main() {
  group('QuoteFormState', () {
    test('linha inválida não quebra cálculo e total temporário pode ser zero', () {
      final draft = QuoteLineDraft(
        draftId: 'line_1',
        catalogItemId: 'item-1',
        name: 'Caixa de som',
        unit: 'Unidade',
        quantityText: '',
        priceText: '1.500,00',
      );

      final calculation = QuoteFormState.calculateLine(draft);
      expect(calculation.isValid, isFalse);
      expect(calculation.lineTotalCents, 0);

      final summary = QuoteFormState.calculateSummary(
        lines: [draft],
        discountText: '',
        freightText: '',
      );
      expect(summary.subtotalCents, 0);
      expect(summary.totalCents, 0);
    });

    test('recalcula subtotal e total com desconto', () {
      final draft = QuoteLineDraft(
        draftId: 'line_1',
        catalogItemId: 'item-1',
        name: 'Caixa de som',
        unit: 'Unidade',
        quantityText: '2',
        priceText: '1.000,00',
      );

      final summary = QuoteFormState.calculateSummary(
        lines: [draft],
        discountText: '500,00',
        freightText: '100,00',
      );

      expect(summary.subtotalCents, 200_000);
      expect(summary.discountCents, 50_000);
      expect(summary.freightCents, 10_000);
      expect(summary.totalCents, 160_000);
    });

    test('desconto e frete vazios representam zero', () {
      final draft = QuoteLineDraft(
        draftId: 'line_1',
        catalogItemId: 'item-1',
        name: 'Caixa de som',
        unit: 'Unidade',
        quantityText: '1',
        priceText: '100,00',
      );

      final summary = QuoteFormState.calculateSummary(
        lines: [draft],
        discountText: '',
        freightText: '',
      );

      expect(summary.subtotalCents, 10_000);
      expect(summary.discountCents, 0);
      expect(summary.freightCents, 0);
      expect(summary.totalCents, 10_000);
    });

    test('atualiza desconto e frete a partir do texto digitado', () {
      final draft = QuoteLineDraft(
        draftId: 'line_1',
        catalogItemId: 'item-1',
        name: 'Caixa de som',
        unit: 'Unidade',
        quantityText: '1',
        priceText: '100,00',
      );

      final withDiscount = QuoteFormState.calculateSummary(
        lines: [draft],
        discountText: '10,00',
        freightText: '',
      );
      expect(withDiscount.discountCents, 1_000);
      expect(withDiscount.totalCents, 9_000);

      final withBoth = QuoteFormState.calculateSummary(
        lines: [draft],
        discountText: '10,00',
        freightText: '5,00',
      );
      expect(withBoth.freightCents, 500);
      expect(withBoth.totalCents, 9_500);
    });

    test('desconto maior que subtotal resulta em total zero', () {
      final draft = QuoteLineDraft(
        draftId: 'line_1',
        catalogItemId: 'item-1',
        name: 'Caixa de som',
        unit: 'Unidade',
        quantityText: '1',
        priceText: '100,00',
      );

      final summary = QuoteFormState.calculateSummary(
        lines: [draft],
        discountText: '500,00',
        freightText: '',
      );

      expect(summary.totalCents, 0);
    });
  });
}
