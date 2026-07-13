import '../models/quote_line_draft.dart';
import 'quote_date_formatter.dart';
import 'quote_money_display.dart';
import 'quote_quantity_parser.dart';

abstract class QuoteFormValidators {
  static String? validateClientSelection(String? clientId) {
    if (clientId == null || clientId.isEmpty) {
      return 'Selecione um cliente';
    }
    return null;
  }

  static String? validateLinesNotEmpty(List<QuoteLineDraft> lines) {
    if (lines.isEmpty) {
      return 'Adicione pelo menos um item do catálogo';
    }
    return null;
  }

  static String? validatePriceForSave(String? input) {
    if (input == null || input.trim().isEmpty) {
      return 'Informe o preço unitário';
    }

    final cents = QuoteMoneyDisplay.parseToCents(input);
    if (cents == null) {
      return 'O preço deve ser maior que zero';
    }

    return null;
  }

  static String? validateDiscount(String? input, {required int subtotalCents}) {
    if (input == null || input.trim().isEmpty) {
      return null;
    }

    final cents = QuoteMoneyDisplay.parseNonNegativeCents(input);
    if (cents == null) {
      return 'Desconto inválido';
    }

    return null;
  }

  static String? validateFreight(String? input) {
    if (input == null || input.trim().isEmpty) {
      return null;
    }

    final cents = QuoteMoneyDisplay.parseNonNegativeCents(input);
    if (cents == null) {
      return 'Frete inválido';
    }

    return null;
  }

  static String? validateValidUntil(DateTime? validUntil, DateTime today) {
    if (validUntil == null) {
      return null;
    }

    final validDate = QuoteDateFormatter.dateOnly(validUntil);
    final todayDate = QuoteDateFormatter.dateOnly(today);
    if (validDate.isBefore(todayDate)) {
      return 'A validade não pode ser anterior à data atual';
    }

    return null;
  }

  static String? validateGuestCount(String? input) {
    if (input == null || input.trim().isEmpty) {
      return null;
    }

    final value = int.tryParse(input.trim());
    if (value == null || value <= 0) {
      return 'A quantidade de convidados deve ser maior que zero';
    }

    return null;
  }

  static String? validateQuantityForSave(String? input) {
    return QuoteQuantityParser.validateForSave(input);
  }
}
