abstract class QuotePdfFilenameBuilder {
  static const prefix = 'orcamento_';
  static const extension = '.pdf';

  static final _invalidCharacters = RegExp(r'[\\/:*?"<>|\s]+');

  static String build(String quoteNumber) {
    final trimmed = quoteNumber.trim();
    final sanitized = trimmed.replaceAll(_invalidCharacters, '');
    final safeNumber = sanitized.isEmpty ? 'orcamento' : sanitized;
    return '$prefix$safeNumber$extension';
  }
}
