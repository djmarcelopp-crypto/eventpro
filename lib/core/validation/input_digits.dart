abstract class InputDigits {
  static String extract(String? value) {
    return (value ?? '').replaceAll(RegExp(r'\D'), '');
  }
}
