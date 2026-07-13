abstract class CatalogPriceFormatter {
  static String format(double value) {
    final isNegative = value < 0;
    final abs = value.abs();
    final formatted = formatForInput(abs);
    final result = 'R\$ $formatted';
    return isNegative ? '-$result' : result;
  }

  static String formatForInput(double value) {
    final fixed = value.abs().toStringAsFixed(2);
    final parts = fixed.split('.');
    final intPart = _addThousandsSeparator(parts[0]);
    return '$intPart,${parts[1]}';
  }

  static String formatIntegerInput(String digits) {
    final normalized = digits.replaceAll('.', '');
    if (normalized.isEmpty) {
      return '';
    }
    return _addThousandsSeparator(normalized);
  }

  static String formatEditable(String sanitized) {
    if (sanitized.isEmpty) {
      return '';
    }

    final commaIndex = sanitized.indexOf(',');
    if (commaIndex >= 0) {
      final rawInt = sanitized.substring(0, commaIndex).replaceAll('.', '');
      final decPart =
          sanitized.substring(commaIndex + 1).replaceAll(',', '');
      final intPart = formatIntegerInput(rawInt);
      if (decPart.isEmpty) {
        return '$intPart,';
      }
      return '$intPart,${decPart.substring(0, decPart.length.clamp(0, 2))}';
    }

    final digitsOnly = sanitized.replaceAll('.', '');
    return formatIntegerInput(digitsOnly);
  }

  static double? parse(String? input) {
    if (input == null) {
      return null;
    }

    var cleaned = input.trim();
    if (cleaned.isEmpty) {
      return null;
    }

    cleaned = cleaned
        .replaceAll(RegExp(r'R\$\s*', caseSensitive: false), '')
        .replaceAll('\u00A0', '')
        .replaceAll(' ', '');

    if (cleaned.isEmpty) {
      return null;
    }

    if (!_isAllowedPriceCharacters(cleaned)) {
      return null;
    }

    final hasComma = cleaned.contains(',');
    final hasDot = cleaned.contains('.');

    final String normalized;
    if (hasComma) {
      final commaIndex = cleaned.lastIndexOf(',');
      final intPart = cleaned.substring(0, commaIndex).replaceAll('.', '');
      final decPart = cleaned.substring(commaIndex + 1);

      if (intPart.isNotEmpty && !_isDigitsOnly(intPart)) {
        return null;
      }
      if (decPart.isNotEmpty && !_isDigitsOnly(decPart)) {
        return null;
      }

      normalized = decPart.isEmpty ? intPart : '$intPart.$decPart';
    } else if (hasDot) {
      final parts = cleaned.split('.');
      if (parts.length == 2 &&
          parts[1].isNotEmpty &&
          parts[1].length <= 2 &&
          _isDigitsOnly(parts[0]) &&
          _isDigitsOnly(parts[1])) {
        normalized = '${parts[0]}.${parts[1]}';
      } else if (parts.every(_isDigitsOnly)) {
        normalized = cleaned.replaceAll('.', '');
      } else {
        return null;
      }
    } else {
      if (!_isDigitsOnly(cleaned)) {
        return null;
      }
      normalized = cleaned;
    }

    if (normalized.isEmpty) {
      return null;
    }

    return double.tryParse(normalized);
  }

  static String _addThousandsSeparator(String digits) {
    if (digits.length <= 3) {
      return digits;
    }

    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final remaining = digits.length - i;
      if (i > 0 && remaining % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  static bool _isDigitsOnly(String value) {
    return RegExp(r'^\d+$').hasMatch(value);
  }

  static bool _isAllowedPriceCharacters(String value) {
    return RegExp(r'^[\d.,]+$').hasMatch(value);
  }
}
