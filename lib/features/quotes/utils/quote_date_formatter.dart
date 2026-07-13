abstract class QuoteDateFormatter {
  static const _monthNames = [
    'janeiro',
    'fevereiro',
    'março',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro',
  ];

  static String format(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final day = normalized.day.toString().padLeft(2, '0');
    final month = _monthNames[normalized.month - 1];
    return '$day/$month/${normalized.year}';
  }

  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime addDays(DateTime date, int days) {
    final normalized = dateOnly(date);
    return DateTime(
      normalized.year,
      normalized.month,
      normalized.day + days,
    );
  }
}
