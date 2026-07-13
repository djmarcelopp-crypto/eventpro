import 'dart:io';
import 'dart:typed_data';

import 'package:eventpro/core/media/services/app_image_memory_cache.dart';
import 'package:eventpro/core/media/services/local_app_image_storage_service.dart';

import 'company_logo_storage_service.dart';

class LocalCompanyLogoStorageService implements CompanyLogoStorageService {
  LocalCompanyLogoStorageService({
    required AppImageMemoryCache cache,
    Future<Directory> Function()? documentsDirectoryProvider,
  }) : _delegate = LocalAppImageStorageService(
          cache: cache,
          stagedReferencePrefix: stagedPrefix,
          committedReferencePrefix: committedPrefix,
          stagedDirectoryName: 'settings_logo_staged',
          committedDirectoryName: 'settings_logo',
          documentsDirectoryProvider: documentsDirectoryProvider,
        );

  static const stagedPrefix = 'settings/logo/staged/';
  static const committedPrefix = 'settings/logo/';

  final LocalAppImageStorageService _delegate;

  @override
  Future<String> stageFromPick({
    required Uint8List bytes,
    required String extension,
  }) {
    return _delegate.stageFromPick(bytes: bytes, extension: extension);
  }

  @override
  Future<String> commitStaged({
    required String stagedReference,
    required String ownerId,
  }) {
    return _delegate.commitStaged(
      stagedReference: stagedReference,
      ownerId: ownerId,
    );
  }

  @override
  Future<void> discardStaged(String? stagedReference) {
    return _delegate.discardStaged(stagedReference);
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
}
