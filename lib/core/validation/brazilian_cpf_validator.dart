abstract class BrazilianCpfValidator {
  static bool isValid(String digits) {
    if (digits.length != 11) {
      return false;
    }

    if (RegExp(r'^(\d)\1{10}$').hasMatch(digits)) {
      return false;
    }

    final firstDigit = _calculateCheckDigit(digits, 9);
    if (firstDigit != int.parse(digits[9])) {
      return false;
    }

    final secondDigit = _calculateCheckDigit(digits, 10);
    return secondDigit == int.parse(digits[10]);
  }

  static int _calculateCheckDigit(String digits, int length) {
    var sum = 0;
    for (var index = 0; index < length; index++) {
      sum += int.parse(digits[index]) * ((length + 1) - index);
    }

    final remainder = sum % 11;
    return remainder < 2 ? 0 : 11 - remainder;
  }
}
