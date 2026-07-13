import 'dart:typed_data';

abstract class QuoteCompanyLogoStorageService {
  Future<String?> copyFromSettingsLogo({
    required String settingsLogoReference,
    required String quoteId,
    required DateTime timestamp,
  });

  Future<void> deleteCommitted(String? imageReference);

  Future<Uint8List?> readBytes(String imageReference);

  Future<bool> exists(String imageReference);
}
