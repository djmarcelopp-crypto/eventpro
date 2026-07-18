/// Lightweight text normalization for deterministic Portuguese parsing.
abstract class AssistantTextNormalizer {
  static String normalize(String input) {
    var text = input.trim();
    text = text.replaceAll(RegExp(r'\s+'), ' ');
    return text;
  }

  static String fold(String input) {
    const map = {
      'á': 'a',
      'à': 'a',
      'â': 'a',
      'ã': 'a',
      'ä': 'a',
      'é': 'e',
      'ê': 'e',
      'ë': 'e',
      'í': 'i',
      'ï': 'i',
      'ó': 'o',
      'ô': 'o',
      'õ': 'o',
      'ö': 'o',
      'ú': 'u',
      'ü': 'u',
      'ç': 'c',
    };
    final lower = input.toLowerCase();
    final buffer = StringBuffer();
    for (final rune in lower.runes) {
      final char = String.fromCharCode(rune);
      buffer.write(map[char] ?? char);
    }
    return buffer.toString();
  }
}
