import '../models/quote.dart';
import '../models/quote_line_draft.dart';
import '../utils/quote_calculator.dart';
import '../utils/quote_date_formatter.dart';
import '../utils/quote_money_display.dart';
import '../utils/quote_quantity_parser.dart';

class QuoteLineCalculation {
  const QuoteLineCalculation({
    required this.isValid,
    this.quantityError,
    this.priceError,
    this.quantity,
    this.unitPriceCents,
    required this.lineTotalCents,
  });

  final bool isValid;
  final String? quantityError;
  final String? priceError;
  final double? quantity;
  final int? unitPriceCents;
  final int lineTotalCents;
}

class QuoteFinancialSummaryData {
  const QuoteFinancialSummaryData({
    required this.subtotalCents,
    required this.discountCents,
    required this.freightCents,
    required this.totalCents,
  });

  final int subtotalCents;
  final int discountCents;
  final int freightCents;
  final int totalCents;
}

abstract class QuoteFormState {
  static QuoteLineCalculation calculateLine(QuoteLineDraft draft) {
    final quantityError = QuoteQuantityParser.validateForDisplay(
      draft.quantityText,
    );
    final quantity = QuoteQuantityParser.tryParse(draft.quantityText);

    String? priceError;
    int? unitPriceCents;
    if (draft.priceText.trim().isEmpty) {
      priceError = 'Informe o preço unitário';
    } else {
      unitPriceCents = QuoteMoneyDisplay.parseToCents(draft.priceText);
      if (unitPriceCents == null) {
        priceError = 'O preço deve ser maior que zero';
      }
    }

    final isValid = quantityError == null &&
        priceError == null &&
        quantity != null &&
        unitPriceCents != null;

    if (!isValid) {
      return QuoteLineCalculation(
        isValid: false,
        quantityError: quantityError,
        priceError: priceError,
        quantity: quantity,
        unitPriceCents: unitPriceCents,
        lineTotalCents: 0,
      );
    }

    final lineTotalCents = QuoteCalculator.lineTotalCents(
      quantity: quantity,
      unitPriceCents: unitPriceCents,
    );

    return QuoteLineCalculation(
      isValid: true,
      quantityError: null,
      priceError: null,
      quantity: quantity,
      unitPriceCents: unitPriceCents,
      lineTotalCents: lineTotalCents,
    );
  }

  static QuoteFinancialSummaryData calculateSummary({
    required List<QuoteLineDraft> lines,
    required String discountText,
    required String freightText,
  }) {
    var subtotalCents = 0;
    for (final line in lines) {
      final calculation = calculateLine(line);
      if (calculation.isValid) {
        subtotalCents += calculation.lineTotalCents;
      }
    }

    final discountCents = QuoteMoneyDisplay.parseToCentsOrZero(discountText);
    final freightCents = QuoteMoneyDisplay.parseToCentsOrZero(freightText);
    final totalCents = QuoteCalculator.totalCents(
      subtotalCents: subtotalCents,
      discountCents: discountCents,
      freightCents: freightCents,
    );

    return QuoteFinancialSummaryData(
      subtotalCents: subtotalCents,
      discountCents: discountCents,
      freightCents: freightCents,
      totalCents: totalCents,
    );
  }

  static bool hasDuplicateCatalogItem(
    List<QuoteLineDraft> lines,
    String catalogItemId,
  ) {
    var count = 0;
    for (final line in lines) {
      if (line.catalogItemId == catalogItemId) {
        count++;
        if (count > 1) {
          return true;
        }
      }
    }
    return false;
  }
}

abstract class QuoteListPresenter {
  static String formatEventDate(Quote quote) {
    final date = quote.eventSnapshot.date;
    if (date == null) {
      return '—';
    }
    return QuoteDateFormatter.format(date);
  }

  static String formatValidUntil(Quote quote) {
    final validUntil = quote.validUntil;
    if (validUntil == null) {
      return '—';
    }
    return QuoteDateFormatter.format(validUntil);
  }

  static String formatTotal(Quote quote) {
    return QuoteMoneyDisplay.format(quote.totalCents);
  }

  static String formatItemsCount(Quote quote) {
    final count = quote.items.length;
    return count == 1 ? '1 item' : '$count itens';
  }

  static String clientName(Quote quote) {
    return quote.clientSnapshot.displayName;
  }
}
