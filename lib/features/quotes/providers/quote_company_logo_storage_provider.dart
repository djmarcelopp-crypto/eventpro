import 'package:eventpro/core/media/services/app_image_copy_service.dart';
import 'package:eventpro/core/media/services/app_image_memory_cache.dart';
import 'package:eventpro/core/media/services/local_app_image_copy_service.dart';
import 'package:eventpro/features/settings/data/services/local_company_logo_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/local_quote_company_logo_storage_service.dart';
import '../data/services/quote_company_logo_storage_service.dart';

final quoteCompanyLogoMemoryCacheProvider = Provider<AppImageMemoryCache>(
  (ref) => AppImageMemoryCache(),
);

final quoteCompanyLogoCopyServiceProvider = Provider<AppImageCopyService>(
  (ref) {
    return LocalAppImageCopyService(
      cache: ref.watch(quoteCompanyLogoMemoryCacheProvider),
      sourcePrefixToDirectoryName: {
        LocalCompanyLogoStorageService.committedPrefix: 'settings_logo',
      },
      targetPrefixToDirectoryName: {
        LocalQuoteCompanyLogoStorageService.committedPrefix:
            LocalQuoteCompanyLogoStorageService.committedDirectoryName,
      },
    );
  },
);

final quoteCompanyLogoStorageProvider =
    Provider<QuoteCompanyLogoStorageService>((ref) {
  return LocalQuoteCompanyLogoStorageService(
    cache: ref.watch(quoteCompanyLogoMemoryCacheProvider),
    copyService: ref.watch(quoteCompanyLogoCopyServiceProvider),
  );
});
