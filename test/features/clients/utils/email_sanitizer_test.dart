import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/utils/email_sanitizer.dart';

void main() {
  group('EmailSanitizer', () {
    test('sanitiza e-mail válido', () {
      expect(
        EmailSanitizer.sanitize(' contato@exemplo.test '),
        'contato@exemplo.test',
      );
    });

    test('retorna null para e-mail inválido', () {
      expect(EmailSanitizer.sanitize('invalido'), isNull);
      expect(EmailSanitizer.sanitize('sem-arroba.test'), isNull);
    });

    test('retorna null para ausente ou vazio', () {
      expect(EmailSanitizer.sanitize(null), isNull);
      expect(EmailSanitizer.sanitize(''), isNull);
      expect(EmailSanitizer.sanitize('   '), isNull);
    });

    test('validateForForm segue mesma regra do formulário', () {
      expect(EmailSanitizer.validateForForm(null), isNull);
      expect(EmailSanitizer.validateForForm(''), isNull);
      expect(EmailSanitizer.validateForForm('invalido'), 'E-mail inválido');
      expect(EmailSanitizer.validateForForm('maria@email.com'), isNull);
    });
  });
}
