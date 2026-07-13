import 'package:flutter/services.dart';

String applyDigitMask(String digits, String mask) {
  final buffer = StringBuffer();
  var digitIndex = 0;

  for (var i = 0; i < mask.length; i++) {
    if (digitIndex >= digits.length) {
      break;
    }

    final maskChar = mask[i];
    if (maskChar == '#') {
      buffer.write(digits[digitIndex]);
      digitIndex++;
    } else {
      buffer.write(maskChar);
    }
  }

  return buffer.toString();
}

class DigitMaskFormatter extends TextInputFormatter {
  DigitMaskFormatter({
    required this.mask,
    required this.maxDigits,
  });

  final String mask;
  final int maxDigits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > maxDigits
        ? digits.substring(0, maxDigits)
        : digits;
    final formatted = applyDigitMask(limited, mask);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class BrazilianPhoneInputFormatter extends TextInputFormatter {
  static const _maxDigits = 11;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > _maxDigits
        ? digits.substring(0, _maxDigits)
        : digits;
    final formatted = formatFromDigits(limited);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static String formatFromDigits(String rawDigits) {
    var digits = rawDigits.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) {
      return '';
    }

    if (digits.startsWith('55') && digits.length >= 12) {
      digits = digits.substring(2);
    }

    if (digits.length > _maxDigits) {
      digits = digits.substring(0, _maxDigits);
    }

    return _formatPhone(digits);
  }

  static String _formatPhone(String digits) {
    final useMobileMask = _usesMobileMask(digits);
    final mask = useMobileMask ? '(##) #####-####' : '(##) ####-####';
    return applyDigitMask(digits, mask);
  }

  static bool _usesMobileMask(String digits) {
    return digits.length == 11 ||
        (digits.length >= 3 && digits[2] == '9');
  }
}

class BrazilianWhatsAppInputFormatter extends TextInputFormatter {
  static const _maxDigits = 13;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    if (!digits.startsWith('55')) {
      digits = '55$digits';
    }

    if (digits.length > _maxDigits) {
      digits = digits.substring(0, _maxDigits);
    }

    final formatted = _formatWhatsApp(digits);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static String formatFromDigits(String rawDigits) {
    var digits = rawDigits.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) {
      return '';
    }

    if (!digits.startsWith('55')) {
      digits = '55$digits';
    }

    if (digits.length > _maxDigits) {
      digits = digits.substring(0, _maxDigits);
    }

    return _formatWhatsApp(digits);
  }

  static String _formatWhatsApp(String digits) {
    final buffer = StringBuffer('+55');

    if (digits.length <= 2) {
      return buffer.toString();
    }

    final national = digits.substring(2);
    buffer.write(' (');

    if (national.isEmpty) {
      return buffer.toString();
    }

    final areaCode = national.length >= 2
        ? national.substring(0, 2)
        : national;
    buffer.write(areaCode);

    if (national.length >= 2) {
      buffer.write(')');
    }

    if (national.length > 2) {
      buffer.write(' ');
      final number = national.substring(2);

      if (number.length <= 5) {
        buffer.write(number);
      } else {
        buffer.write('${number.substring(0, 5)}-${number.substring(5)}');
      }
    }

    return buffer.toString();
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final lettersOnly = newValue.text
        .toUpperCase()
        .replaceAll(RegExp(r'[^A-Z]'), '');
    final limited = lettersOnly.length > 2
        ? lettersOnly.substring(0, 2)
        : lettersOnly;

    return TextEditingValue(
      text: limited,
      selection: TextSelection.collapsed(offset: limited.length),
    );
  }
}

class CepInputFormatter extends DigitMaskFormatter {
  CepInputFormatter()
      : super(
          mask: '#####-###',
          maxDigits: 8,
        );

  static String formatFromDigits(String rawDigits) {
    final digits = rawDigits.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return '';
    }

    final limited = digits.length > 8 ? digits.substring(0, 8) : digits;
    return applyDigitMask(limited, '#####-###');
  }
}

class CpfInputFormatter extends DigitMaskFormatter {
  CpfInputFormatter()
      : super(
          mask: '###.###.###-##',
          maxDigits: 11,
        );
}

class CnpjInputFormatter extends DigitMaskFormatter {
  CnpjInputFormatter()
      : super(
          mask: '##.###.###/####-##',
          maxDigits: 14,
        );
}
