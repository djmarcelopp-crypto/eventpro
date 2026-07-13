import 'dart:typed_data';

import 'package:eventpro/core/media/services/app_image_memory_cache.dart';
import 'package:eventpro/features/quotes/data/services/local_quote_company_logo_storage_service.dart';
import 'package:eventpro/features/quotes/data/services/quote_company_logo_storage_service.dart';

class FakeQuoteCompanyLogoStorageService
    implements QuoteCompanyLogoStorageService {
  FakeQuoteCompanyLogoStorageService({AppImageMemoryCache? cache})
      : _cache = cache ?? AppImageMemoryCache();

  final AppImageMemoryCache _cache;
  final Map<String, Uint8List> _settingsLogos = {};
  final Map<String, Uint8List> _quoteLogos = {};
  final List<String> _deleteLog = [];
  var copyCallCount = 0;

  List<String> get deleteLog => List.unmodifiable(_deleteLog);

  void seedSettingsLogo(String reference, Uint8List bytes) {
    _settingsLogos[reference] = bytes;
    _cache.put(reference, bytes);
  }

  void seedQuoteLogo(String reference, Uint8List bytes) {
    _quoteLogos[reference] = bytes;
    _cache.put(reference, bytes);
  }

  @override
  Future<String?> copyFromSettingsLogo({
    required String settingsLogoReference,
    required String quoteId,
    required DateTime timestamp,
  }) async {
    copyCallCount++;
    LocalQuoteCompanyLogoStorageService.validateSettingsLogoReference(
      settingsLogoReference,
    );

    final bytes = _settingsLogos[settingsLogoReference];
    if (bytes == null) {
      return null;
    }

    final extension = settingsLogoReference.split('.').last.toLowerCase();
    final normalizedExtension = extension == 'jpeg' ? 'jpg' : extension;
    final copiedReference =
        '${LocalQuoteCompanyLogoStorageService.committedPrefix}${quoteId}_${timestamp.microsecondsSinceEpoch}.$normalizedExtension';

    _quoteLogos[copiedReference] = bytes;
    _cache.put(copiedReference, bytes);
    return copiedReference;
  }

  @override
  Future<void> deleteCommitted(String? imageReference) async {
    if (imageReference == null) {
      return;
    }

    _deleteLog.add(imageReference);
    _quoteLogos.remove(imageReference);
    _cache.invalidate(imageReference);
  }

  @override
  Future<Uint8List?> readBytes(String imageReference) async {
    final cached = _cache.get(imageReference);
    if (cached != null) {
      return cached;
    }

    return _quoteLogos[imageReference] ?? _settingsLogos[imageReference];
  }

  @override
  Future<bool> exists(String imageReference) async {
    return _quoteLogos.containsKey(imageReference) ||
        _settingsLogos.containsKey(imageReference);
  }
}
