import 'package:flutter/services.dart';

class QuoteQuantityInputFormatter extends TextInputFormatter {
  const QuoteQuantityInputFormatter();

  static const maxDecimalPlaces = 3;

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

    if (_separatorCount(sanitized, ',') > 1 ||
        _separatorCount(sanitized, '.') > 1) {
      return oldValue;
    }

    sanitized = _normalizeDecimalSeparator(sanitized);
    if (!_isValidStructure(sanitized)) {
      return oldValue;
    }

    final formatted = _formatEditable(sanitized);
    return _withPreservedCursor(
      newValue: newValue,
      formatted: formatted,
    );
  }

  static String _sanitize(String text) {
    return text
        .replaceAll('\u00A0', '')
        .replaceAll(' ', '')
        .replaceAll(RegExp(r'[^\d.,]'), '');
  }

  static int _separatorCount(String text, String separator) {
    return separator.allMatches(text).length;
  }

  static String _normalizeDecimalSeparator(String text) {
    if (text.contains(',') && text.contains('.')) {
      final lastComma = text.lastIndexOf(',');
      final lastDot = text.lastIndexOf('.');
      if (lastComma > lastDot) {
        return text.replaceAll('.', '').replaceAll(',', ',');
      }
      return text.replaceAll(',', '');
    }

    if (text.contains('.')) {
      final lastDot = text.lastIndexOf('.');
      final afterLastDot = text.substring(lastDot + 1);
      final isDecimalDot = afterLastDot.length <= maxDecimalPlaces &&
          RegExp(r'^\d*$').hasMatch(afterLastDot);
      if (isDecimalDot) {
        final beforeLastDot = text.substring(0, lastDot);
        return '${beforeLastDot.replaceAll('.', '')},$afterLastDot';
      }
      return text.replaceAll('.', '');
    }

    return text;
  }

  static bool _isValidStructure(String text) {
    if (text.contains(',')) {
      final commaIndex = text.indexOf(',');
      final decPart = text.substring(commaIndex + 1);
      if (decPart.length > maxDecimalPlaces || !_isDigitsOnly(decPart)) {
        return false;
      }
      final intPart = text.substring(0, commaIndex);
      return intPart.isEmpty || _isDigitsOnly(intPart);
    }

    return _isDigitsOnly(text);
  }

  static bool _isDigitsOnly(String value) {
    return value.isEmpty || RegExp(r'^\d+$').hasMatch(value);
  }

  static String _formatEditable(String sanitized) {
    if (sanitized.isEmpty) {
      return '';
    }

    final commaIndex = sanitized.indexOf(',');
    if (commaIndex >= 0) {
      final intPart = sanitized.substring(0, commaIndex);
      final decPart = sanitized.substring(commaIndex + 1);
      if (decPart.isEmpty) {
        return '$intPart,';
      }
      return '$intPart,$decPart';
    }

    return sanitized;
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
      return context.intDigits.clamp(0, formatted.length);
    }

    final commaPos = formatted.indexOf(',');
    if (!context.inDecimalPart) {
      return context.intDigits.clamp(0, commaPos);
    }

    return (commaPos + 1 + context.decDigits).clamp(0, formatted.length);
  }

  static _CursorContext _cursorContext(String text, int cursor) {
    final clampedCursor = cursor.clamp(0, text.length);
    final before = text.substring(0, clampedCursor);
    final sanitizedBefore = _normalizeDecimalSeparator(_sanitize(before));
    final commaInBefore = sanitizedBefore.indexOf(',');

    if (commaInBefore >= 0) {
      return _CursorContext(
        intDigits: sanitizedBefore.substring(0, commaInBefore).length,
        decDigits: sanitizedBefore.substring(commaInBefore + 1).length,
        inDecimalPart: true,
      );
    }

    return _CursorContext(
      intDigits: sanitizedBefore.length,
      decDigits: 0,
      inDecimalPart: false,
    );
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
