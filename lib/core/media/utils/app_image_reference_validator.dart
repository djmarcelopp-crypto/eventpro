import '../exceptions/app_image_storage_exception.dart';

abstract class AppImageReferenceValidator {
  static void validateReference(String reference) {
    if (reference.isEmpty) {
      throw const InvalidImageReferenceException();
    }

    if (reference.contains('..') ||
        reference.contains(r'\') ||
        reference.codeUnits.contains(0) ||
        reference.startsWith('/')) {
      throw const InvalidImageReferenceException();
    }
  }

  static void validateAllowedPrefix(
    String reference,
    Set<String> allowedPrefixes,
  ) {
    validateReference(reference);

    for (final prefix in allowedPrefixes) {
      if (reference.startsWith(prefix)) {
        return;
      }
    }

    throw const InvalidImageReferenceException();
  }

  static String normalizeImageExtension(String reference) {
    validateReference(reference);

    final lastDot = reference.lastIndexOf('.');
    if (lastDot == -1 || lastDot == reference.length - 1) {
      throw const InvalidImageReferenceException();
    }

    final extension = reference.substring(lastDot + 1).toLowerCase();
    return switch (extension) {
      'jpeg' => 'jpg',
      'jpg' || 'png' => extension,
      _ => throw const InvalidImageReferenceException(),
    };
  }
}
