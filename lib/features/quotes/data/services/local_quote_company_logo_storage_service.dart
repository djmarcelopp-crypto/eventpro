import 'dart:io';
import 'dart:typed_data';

import 'package:eventpro/core/media/exceptions/app_image_storage_exception.dart';
import 'package:eventpro/core/media/services/app_image_copy_service.dart';
import 'package:eventpro/core/media/services/app_image_memory_cache.dart';
import 'package:eventpro/core/media/services/local_app_image_storage_service.dart';
import 'package:eventpro/core/media/utils/app_image_reference_validator.dart';
import 'package:eventpro/features/settings/data/services/local_company_logo_storage_service.dart';

import 'quote_company_logo_storage_service.dart';

class LocalQuoteCompanyLogoStorageService
    implements QuoteCompanyLogoStorageService {
  LocalQuoteCompanyLogoStorageService({
    required AppImageMemoryCache cache,
    required this.copyService,
    Future<Directory> Function()? documentsDirectoryProvider,
  }) : _delegate = LocalAppImageStorageService(
          cache: cache,
          stagedReferencePrefix: stagedPrefix,
          committedReferencePrefix: committedPrefix,
          stagedDirectoryName: stagedDirectoryName,
          committedDirectoryName: committedDirectoryName,
          documentsDirectoryProvider: documentsDirectoryProvider,
        );

  static const stagedPrefix = 'quotes/company-assets/staged/';
  static const committedPrefix = 'quotes/company-assets/';
  static const stagedDirectoryName = 'quotes_company_assets_staged';
  static const committedDirectoryName = 'quotes_company_assets';

  static const Set<String> allowedSettingsLogoPrefixes = {
    LocalCompanyLogoStorageService.committedPrefix,
  };

  final AppImageCopyService copyService;
  final LocalAppImageStorageService _delegate;

  @override
  Future<String?> copyFromSettingsLogo({
    required String settingsLogoReference,
    required String quoteId,
    required DateTime timestamp,
  }) async {
    validateSettingsLogoReference(settingsLogoReference);

    final sourceExists = await copyService.exists(settingsLogoReference);
    if (!sourceExists) {
      return null;
    }

    try {
      return await copyService.copyCommitted(
        sourceReference: settingsLogoReference,
        allowedSourcePrefixes: allowedSettingsLogoPrefixes,
        targetReferencePrefix: committedPrefix,
        targetDirectoryName: committedDirectoryName,
        ownerId: quoteId,
        timestamp: timestamp,
      );
    } on InvalidImageReferenceException {
      rethrow;
    } on ImageCopyFailedException {
      rethrow;
    } catch (_) {
      throw const ImageCopyFailedException();
    }
  }

  @override
  Future<void> deleteCommitted(String? imageReference) {
    return _delegate.deleteCommitted(imageReference);
  }

  @override
  Future<Uint8List?> readBytes(String imageReference) {
    return _delegate.readBytes(imageReference);
  }

  @override
  Future<bool> exists(String imageReference) {
    return _delegate.exists(imageReference);
  }

  static void validateSettingsLogoReference(String reference) {
    AppImageReferenceValidator.validateReference(reference);

    if (reference.startsWith(LocalCompanyLogoStorageService.stagedPrefix)) {
      throw const InvalidImageReferenceException();
    }

    if (!reference.startsWith(LocalCompanyLogoStorageService.committedPrefix)) {
      throw const InvalidImageReferenceException();
    }
  }
}
