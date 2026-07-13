import 'package:flutter_test/flutter_test.dart';

import 'package:eventpro/features/quotes/utils/quote_datetime_formatter.dart';

void main() {
  group('QuoteDateTimeFormatter', () {
    test('formata data e hora em pt-BR', () {
      final formatted = QuoteDateTimeFormatter.format(
        DateTime(2026, 7, 13, 14, 5),
      );

      expect(formatted, '13/julho/2026 às 14:05');
    });
  });
}
