import '../../catalog/utils/catalog_price_formatter.dart';
import 'quote_money.dart';

abstract class QuoteMoneyDisplay {
  static String format(int cents) {
    return CatalogPriceFormatter.format(QuoteMoney.centsToReais(cents));
  }

  static String formatForInput(int cents) {
    return CatalogPriceFormatter.formatForInput(QuoteMoney.centsToReais(cents));
  }

  static int? parseToCents(String? input) {
    final reais = CatalogPriceFormatter.parse(input);
    if (reais == null) {
      return null;
    }
    if (reais <= 0) {
      return null;
    }
    return QuoteMoney.reaisToCents(reais);
  }

  static int? parseNonNegativeCents(String? input) {
    if (input == null || input.trim().isEmpty) {
      return 0;
    }

    final reais = CatalogPriceFormatter.parse(input);
    if (reais == null || reais < 0) {
      return null;
    }

    return QuoteMoney.reaisToCents(reais);
  }

  static int parseToCentsOrZero(String? input) {
    return parseNonNegativeCents(input) ?? 0;
  }
}
