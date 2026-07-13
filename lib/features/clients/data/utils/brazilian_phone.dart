abstract class BrazilianPhone {
  static String? normalizeNationalDigits(String? rawPhone) {
    if (rawPhone == null) {
      return null;
    }

    var digits = rawPhone.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return null;
    }

    if (digits.startsWith('55') && digits.length >= 12) {
      digits = digits.substring(2);
    }

    if (!_isValidNationalPhone(digits)) {
      return null;
    }

    return digits;
  }

  static bool isValidNationalPhone(String digits) {
    return _isValidNationalPhone(digits);
  }

  static bool _isValidNationalPhone(String digits) {
    if (digits.length != 10 && digits.length != 11) {
      return false;
    }

    return _isValidAreaCode(digits.substring(0, 2));
  }

  static bool _isValidAreaCode(String areaCode) {
    final ddd = int.tryParse(areaCode);
    return ddd != null && ddd >= 11 && ddd <= 99;
  }
}
