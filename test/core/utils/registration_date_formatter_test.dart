import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/core/utils/registration_date_formatter.dart';

void main() {
  group('RegistrationDateFormatter', () {
    test('formata data de cadastro em português', () {
      expect(
        RegistrationDateFormatter.format(DateTime(2024, 3, 5)),
        '05/março/2024',
      );
    });
  });
}
