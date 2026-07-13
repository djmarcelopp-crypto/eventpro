import 'package:flutter/services.dart';

import 'catalog_price_formatter.dart';

class BrazilianCurrencyInputFormatter extends TextInputFormatter {
  static const maxIntegerDigits = 9;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    var sanitized = _sanitize(newValue.text);
    if (sanitized.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    if (_commaCount(sanitized) > 1) {
      return oldValue;
    }

    sanitized = _normalizeDecimalSeparator(sanitized);
    if (!_isValidStructure(sanitized)) {
      return oldValue;
    }

    if (_integerDigits(sanitized).length > maxIntegerDigits) {
      return oldValue;
    }

    final formatted = CatalogPriceFormatter.formatEditable(sanitized);
    return _withPreservedCursor(
      newValue: newValue,
      formatted: formatted,
    );
  }

  static String _sanitize(String text) {
    return text
        .replaceAll(RegExp(r'R\$\s*', caseSensitive: false), '')
        .replaceAll('\u00A0', '')
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll(RegExp(r'[^\d.,]'), '');
  }

  static String _normalizeDecimalSeparator(String text) {
    if (text.contains(',')) {
      final firstComma = text.indexOf(',');
      return text.substring(0, firstComma + 1) +
          text.substring(firstComma + 1).replaceAll(',', '');
    }

    if (!text.contains('.')) {
      return text;
    }

    final lastDot = text.lastIndexOf('.');
    final afterLastDot = text.substring(lastDot + 1);

    final isDecimalDot = afterLastDot.length <= 2 &&
        RegExp(r'^\d*$').hasMatch(afterLastDot);
    if (!isDecimalDot) {
      return text;
    }

    final beforeLastDot = text.substring(0, lastDot).replaceAll('.', '');
    final intPart = CatalogPriceFormatter.formatIntegerInput(beforeLastDot);
    if (afterLastDot.isEmpty) {
      return '$intPart,';
    }
    return '$intPart,$afterLastDot';
  }

  static int _commaCount(String text) {
    return ','.allMatches(text).length;
  }

  static bool _isValidStructure(String text) {
    if (text.contains(',')) {
      final commaIndex = text.indexOf(',');
      final decPart = text.substring(commaIndex + 1);
      if (decPart.length > 2 || !_isDigitsOnly(decPart)) {
        return false;
      }

      final intPart = text.substring(0, commaIndex).replaceAll('.', '');
      return intPart.isEmpty || _isDigitsOnly(intPart);
    }

    final withoutDots = text.replaceAll('.', '');
    return _isDigitsOnly(withoutDots);
  }

  static String _integerDigits(String text) {
    final commaIndex = text.indexOf(',');
    if (commaIndex >= 0) {
      return text.substring(0, commaIndex).replaceAll('.', '');
    }
    return text.replaceAll('.', '');
  }

  static bool _isDigitsOnly(String value) {
    return value.isEmpty || RegExp(r'^\d+$').hasMatch(value);
  }

  static TextEditingValue _withPreservedCursor({
    required TextEditingValue newValue,
    required String formatted,
  }) {
    final selection = newValue.selection;
    if (!selection.isValid) {
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    final start = _mapCursor(newValue.text, selection.start, formatted);
    final end = selection.isCollapsed
        ? start
        : _mapCursor(newValue.text, selection.end, formatted);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection(
        baseOffset: start.clamp(0, formatted.length),
        extentOffset: end.clamp(0, formatted.length),
      ),
    );
  }

  static int _mapCursor(String rawText, int rawOffset, String formatted) {
    if (rawOffset <= 0) {
      return 0;
    }

    final context = _cursorContext(rawText, rawOffset);

    if (!formatted.contains(',')) {
      return _offsetAfterIntegerDigits(formatted, context.intDigits);
    }

    final commaPos = formatted.indexOf(',');

    if (!context.inDecimalPart) {
      return _offsetAfterIntegerDigits(
        formatted.substring(0, commaPos),
        context.intDigits,
      );
    }

    return commaPos + 1 + context.decDigits;
  }

  static _CursorContext _cursorContext(String text, int cursor) {
    final clampedCursor = cursor.clamp(0, text.length);
    final before = text.substring(0, clampedCursor);
    final sanitizedBefore = _normalizeDecimalSeparator(_sanitize(before));
    final commaInBefore = sanitizedBefore.indexOf(',');

    if (commaInBefore >= 0) {
      return _CursorContext(
        intDigits: sanitizedBefore
            .substring(0, commaInBefore)
            .replaceAll('.', '')
            .length,
        decDigits: sanitizedBefore.substring(commaInBefore + 1).length,
        inDecimalPart: true,
      );
    }

    return _CursorContext(
      intDigits: sanitizedBefore.replaceAll('.', '').length,
      decDigits: 0,
      inDecimalPart: false,
    );
  }

  static int _offsetAfterIntegerDigits(String formattedIntPart, int digitCount) {
    if (digitCount <= 0) {
      return 0;
    }

    var seen = 0;
    for (var i = 0; i < formattedIntPart.length; i++) {
      if (_isDigit(formattedIntPart[i])) {
        seen++;
        if (seen == digitCount) {
          return i + 1;
        }
      }
    }

    return formattedIntPart.length;
  }

  static bool _isDigit(String char) {
    return RegExp(r'\d').hasMatch(char);
  }
}

class _CursorContext {
  const _CursorContext({
    required this.intDigits,
    required this.decDigits,
    required this.inDecimalPart,
  });

  final int intDigits;
  final int decDigits;
  final bool inDecimalPart;
}
