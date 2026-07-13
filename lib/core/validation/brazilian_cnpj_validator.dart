abstract class BrazilianCnpjValidator {
  static const _firstWeights = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
  static const _secondWeights = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];

  static bool isValid(String digits) {
    if (digits.length != 14) {
      return false;
    }

    if (RegExp(r'^(\d)\1{13}$').hasMatch(digits)) {
      return false;
    }

    final firstDigit = _calculateCheckDigit(digits, _firstWeights);
    if (firstDigit != int.parse(digits[12])) {
      return false;
    }

    final secondDigit = _calculateCheckDigit(digits, _secondWeights);
    return secondDigit == int.parse(digits[13]);
  }

  static int _calculateCheckDigit(String digits, List<int> weights) {
    var sum = 0;
    for (var index = 0; index < weights.length; index++) {
      sum += int.parse(digits[index]) * weights[index];
    }

    final remainder = sum % 11;
    return remainder < 2 ? 0 : 11 - remainder;
  }
}
