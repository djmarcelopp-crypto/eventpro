import 'package:flutter/foundation.dart';

class AppImageValidationResult {
  const AppImageValidationResult.valid()
      : isValid = true,
        errorMessage = null;

  const AppImageValidationResult.invalid(this.errorMessage) : isValid = false;

  final bool isValid;
  final String? errorMessage;
}

abstract class AppImageValidator {
  static const maxBytes = 10 * 1024 * 1024;

  static const unsupportedFormatMessage =
      'Formato não suportado. Use JPG ou PNG.';

  static const heicFormatMessage =
      'Este formato não é suportado. Selecione uma foto em JPG ou PNG.';

  static const maxSizeMessage = 'A foto deve ter no máximo 10 MB.';

  static Future<AppImageValidationResult> validate(Uint8List bytes) async {
    if (bytes.length > maxBytes) {
      return const AppImageValidationResult.invalid(maxSizeMessage);
    }

    if (_looksLikeHeic(bytes)) {
      return const AppImageValidationResult.invalid(heicFormatMessage);
    }

    if (!_hasSupportedImageSignature(bytes)) {
      return const AppImageValidationResult.invalid(
        unsupportedFormatMessage,
      );
    }

    return const AppImageValidationResult.valid();
  }

  static bool _hasSupportedImageSignature(Uint8List bytes) {
    return _isPng(bytes) || _isJpeg(bytes);
  }

  static bool _isPng(Uint8List bytes) {
    return bytes.length >= 4 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47;
  }

  static bool _isJpeg(Uint8List bytes) {
    return bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF;
  }

  static bool _looksLikeHeic(Uint8List bytes) {
    if (bytes.length < 12) {
      return false;
    }

    final boxType = String.fromCharCodes(bytes.sublist(4, 8));
    if (boxType != 'ftyp') {
      return false;
    }

    final brand = String.fromCharCodes(bytes.sublist(8, 12)).toLowerCase();
    return brand.startsWith('heic') ||
        brand.startsWith('heif') ||
        brand.startsWith('mif1') ||
        brand.startsWith('msf1');
  }
}
