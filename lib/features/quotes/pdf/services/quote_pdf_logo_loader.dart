import 'dart:typed_data';

import '../../data/services/local_quote_company_logo_storage_service.dart';
import '../../data/services/quote_company_logo_storage_service.dart';

abstract class QuotePdfLogoLoader {
  static const allowedPrefix =
      LocalQuoteCompanyLogoStorageService.committedPrefix;

  static Future<Uint8List?> load({
    required QuoteCompanyLogoStorageService storage,
    required String? logoReference,
  }) async {
    final reference = logoReference?.trim();
    if (reference == null || reference.isEmpty) {
      return null;
    }

    if (!reference.startsWith(allowedPrefix)) {
      return null;
    }

    try {
      final bytes = await storage.readBytes(reference);
      if (bytes == null || bytes.isEmpty) {
        return null;
      }
      return bytes;
    } catch (_) {
      return null;
    }
  }
}
