abstract class EmailSanitizer {
  static final _emailPattern = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

  static String? sanitize(String? raw) {
    final trimmed = raw?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    if (!_emailPattern.hasMatch(trimmed)) {
      return null;
    }

    return trimmed;
  }

  static String? validateForForm(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }

    if (!_emailPattern.hasMatch(trimmed)) {
      return 'E-mail inválido';
    }

    return null;
  }
}
