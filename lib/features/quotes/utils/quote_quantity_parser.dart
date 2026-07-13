import 'quote_quantity_validator.dart';

abstract class QuoteQuantityParser {
  static double? tryParse(String? input) {
    if (input == null) {
      return null;
    }

    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final normalized = _normalize(trimmed);
    if (normalized == null) {
      return null;
    }

    final value = double.tryParse(normalized);
    if (value == null || value <= 0) {
      return null;
    }

    if (!QuoteQuantityValidator.isValid(value)) {
      return null;
    }

    return value;
  }

  static bool isCompleteValid(String? input) {
    return tryParse(input) != null;
  }

  static String? validateForSave(String? input) {
    if (input == null || input.trim().isEmpty) {
      return 'Informe a quantidade';
    }

    final trimmed = input.trim();
    final normalized = _normalize(trimmed);
    if (normalized == null) {
      return 'Quantidade inválida';
    }

    final value = double.tryParse(normalized);
    if (value == null || value <= 0) {
      return 'A quantidade deve ser maior que zero';
    }

    if (!QuoteQuantityValidator.isValid(value)) {
      return 'Quantidade inválida (máximo 3 casas decimais)';
    }

    return null;
  }

  static String? validateForDisplay(String? input) {
    if (input == null || input.trim().isEmpty) {
      return 'Informe a quantidade';
    }

    final trimmed = input.trim();
    if (trimmed.endsWith(',') || trimmed.endsWith('.')) {
      return 'Quantidade incompleta';
    }

    return validateForSave(input);
  }

  static String? _normalize(String text) {
    var sanitized = text.replaceAll(' ', '');

    if (sanitized.contains(',') && sanitized.contains('.')) {
      final lastComma = sanitized.lastIndexOf(',');
      final lastDot = sanitized.lastIndexOf('.');
      if (lastComma > lastDot) {
        sanitized = sanitized.replaceAll('.', '').replaceAll(',', '.');
      } else {
        sanitized = sanitized.replaceAll(',', '');
      }
    } else if (sanitized.contains(',')) {
      sanitized = sanitized.replaceAll(',', '.');
    }

    if (!_isValidNormalizedStructure(sanitized)) {
      return null;
    }

    return sanitized;
  }

  static bool _isValidNormalizedStructure(String text) {
    if (!text.contains('.')) {
      return RegExp(r'^\d+$').hasMatch(text);
    }

    final parts = text.split('.');
    if (parts.length != 2) {
      return false;
    }

    return RegExp(r'^\d+$').hasMatch(parts[0]) &&
        RegExp(r'^\d{1,3}$').hasMatch(parts[1]);
  }
}
