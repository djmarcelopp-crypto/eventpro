abstract class BrazilianMobilePhone {
  static String? normalizeWhatsAppDigits(String? rawPhone) {
    if (rawPhone == null) {
      return null;
    }

    final digits = rawPhone.replaceAll(RegExp(r'\D'), '');
    if (!isValidBrazilianMobile(digits)) {
      return null;
    }

    if (digits.length == 11) {
      return '55$digits';
    }

    if (digits.length == 13 && digits.startsWith('55')) {
      return digits;
    }

    return null;
  }

  static bool isValidBrazilianMobile(String digits) {
    if (digits.length == 13 && digits.startsWith('55')) {
      return _isValidNationalMobile(digits.substring(2));
    }

    if (digits.length == 11) {
      return _isValidNationalMobile(digits);
    }

    return false;
  }

  static bool _isValidNationalMobile(String nationalDigits) {
    if (nationalDigits.length != 11) {
      return false;
    }

    final ddd = int.tryParse(nationalDigits.substring(0, 2));
    if (ddd == null || ddd < 11 || ddd > 99) {
      return false;
    }

    return nationalDigits[2] == '9';
  }
}
