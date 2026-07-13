import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/catalog_image_memory_cache.dart';
import '../data/services/catalog_image_picker_service.dart';
import '../data/services/catalog_image_storage_service.dart';
import '../data/services/file_picker_catalog_image_picker_service.dart';
import '../data/services/image_picker_catalog_image_picker_service.dart';
import '../data/services/local_catalog_image_storage_service.dart';

final catalogImageMemoryCacheProvider = Provider<CatalogImageMemoryCache>((ref) {
  return CatalogImageMemoryCache();
});

final catalogImagePickerProvider = Provider<CatalogImagePickerService>((ref) {
  if (Platform.isAndroid || Platform.isIOS) {
    return ImagePickerCatalogImagePickerService();
  }

  return FilePickerCatalogImagePickerService();
});

final catalogImageStorageProvider = Provider<CatalogImageStorageService>((ref) {
  return LocalCatalogImageStorageService(
    cache: ref.watch(catalogImageMemoryCacheProvider),
  );
});
