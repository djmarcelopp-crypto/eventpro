import '../../quotes/utils/quote_money_display.dart';

/// Presentation-only helpers for financial values. Domain remains in cents.
abstract class FinancialDisplayFormatter {
  static String money(int cents) => QuoteMoneyDisplay.format(cents);

  static String civilDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}
