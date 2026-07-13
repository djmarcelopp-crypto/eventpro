import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/core/media/exceptions/app_image_storage_exception.dart';
import 'package:eventpro/core/media/utils/app_image_reference_validator.dart';

void main() {
  group('AppImageReferenceValidator', () {
    test('aceita referência válida', () {
      expect(
        () => AppImageReferenceValidator.validateReference(
          'settings/logo/profile_1.png',
        ),
        returnsNormally,
      );
    });

    test('rejeita path traversal', () {
      expect(
        () => AppImageReferenceValidator.validateReference(
          'settings/logo/../secret.png',
        ),
        throwsA(isA<InvalidImageReferenceException>()),
      );
    });

    test('rejeita referência absoluta', () {
      expect(
        () => AppImageReferenceValidator.validateReference('/etc/passwd'),
        throwsA(isA<InvalidImageReferenceException>()),
      );
    });

    test('normaliza jpeg para jpg', () {
      expect(
        AppImageReferenceValidator.normalizeImageExtension(
          'settings/logo/logo.jpeg',
        ),
        'jpg',
      );
    });

    test('aceita png e jpg', () {
      expect(
        AppImageReferenceValidator.normalizeImageExtension(
          'settings/logo/logo.png',
        ),
        'png',
      );
      expect(
        AppImageReferenceValidator.normalizeImageExtension(
          'settings/logo/logo.jpg',
        ),
        'jpg',
      );
    });

    test('rejeita extensão não suportada', () {
      expect(
        () => AppImageReferenceValidator.normalizeImageExtension(
          'settings/logo/logo.gif',
        ),
        throwsA(isA<InvalidImageReferenceException>()),
      );
    });
  });
}
