import 'dart:io';
import 'dart:typed_data';

import 'package:eventpro/core/media/services/local_app_image_storage_service.dart';

import 'catalog_image_memory_cache.dart';
import 'catalog_image_storage_service.dart';

class LocalCatalogImageStorageService implements CatalogImageStorageService {
  LocalCatalogImageStorageService({
    required CatalogImageMemoryCache cache,
    Future<Directory> Function()? documentsDirectoryProvider,
  }) : _delegate = LocalAppImageStorageService(
          cache: cache,
          stagedReferencePrefix: stagedPrefix,
          committedReferencePrefix: committedPrefix,
          stagedDirectoryName: 'catalog_images_staged',
          committedDirectoryName: 'catalog_images',
          documentsDirectoryProvider: documentsDirectoryProvider,
        );

  static const stagedPrefix = 'catalog/images/staged/';
  static const committedPrefix = 'catalog/images/';

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
    required String itemId,
  }) {
    return _delegate.commitStaged(
      stagedReference: stagedReference,
      ownerId: itemId,
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
