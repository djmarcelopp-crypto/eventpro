import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/data/utils/catalog_image_validator.dart';

final Uint8List _minimalPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

final Uint8List _fakeJpgWithPngBytes = _minimalPng;

final Uint8List _heicHeader = Uint8List.fromList([
  0x00, 0x00, 0x00, 0x18, 0x66, 0x74, 0x79, 0x70, 0x68, 0x65, 0x69, 0x63,
  0x00, 0x00, 0x00, 0x00,
]);

void main() {
  group('CatalogImageValidator', () {
    test('aceita PNG válido', () async {
      final result = await CatalogImageValidator.validate(_minimalPng);
      expect(result.isValid, isTrue);
    });

    test('aceita JPG válido pelos bytes', () async {
      final result = await CatalogImageValidator.validate(_fakeJpgWithPngBytes);
      expect(result.isValid, isTrue);
    });

    test('rejeita arquivo maior que 10 MB', () async {
      final bytes = Uint8List(CatalogImageValidator.maxBytes + 1);
      final result = await CatalogImageValidator.validate(bytes);
      expect(result.isValid, isFalse);
      expect(result.errorMessage, CatalogImageValidator.maxSizeMessage);
    });

    test('rejeita bytes inválidos', () async {
      final result = await CatalogImageValidator.validate(
        Uint8List.fromList([1, 2, 3, 4]),
      );
      expect(result.isValid, isFalse);
      expect(result.errorMessage, CatalogImageValidator.unsupportedFormatMessage);
    });

    test('rejeita HEIC com mensagem específica', () async {
      final result = await CatalogImageValidator.validate(_heicHeader);
      expect(result.isValid, isFalse);
      expect(result.errorMessage, CatalogImageValidator.heicFormatMessage);
    });
  });
}
