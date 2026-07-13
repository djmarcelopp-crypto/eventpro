import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/utils/client_date_formatter.dart';

void main() {
  group('ClientDateFormatter', () {
    test('formata data de aniversário com mês em português minúsculo', () {
      expect(
        ClientDateFormatter.formatBirthday(DateTime(1979, 5, 20)),
        '20/maio/1979',
      );
    });

    test('formata dia com zero à esquerda', () {
      expect(
        ClientDateFormatter.formatBirthday(DateTime(1990, 1, 5)),
        '05/janeiro/1990',
      );
    });

    test('formata meses com acento corretamente', () {
      expect(
        ClientDateFormatter.formatBirthday(DateTime(1985, 3, 12)),
        '12/março/1985',
      );
    });
  });
}
