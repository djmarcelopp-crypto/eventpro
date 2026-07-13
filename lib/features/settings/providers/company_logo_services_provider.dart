import 'dart:io';

import 'package:eventpro/core/media/models/app_image_pick_result.dart';
import 'package:eventpro/core/media/services/app_image_memory_cache.dart';
import 'package:eventpro/core/media/services/file_picker_app_image_picker_service.dart';
import 'package:eventpro/core/media/services/image_picker_app_image_picker_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/company_logo_picker_service.dart';
import '../data/services/company_logo_storage_service.dart';
import '../data/services/local_company_logo_storage_service.dart';

class ImagePickerCompanyLogoPickerService implements CompanyLogoPickerService {
  final _delegate = ImagePickerAppImagePickerService();

  @override
  Future<AppImagePickResult?> pickImage() => _delegate.pickImage();
}

class FilePickerCompanyLogoPickerService implements CompanyLogoPickerService {
  final _delegate = FilePickerAppImagePickerService();

  @override
  Future<AppImagePickResult?> pickImage() => _delegate.pickImage();
}

final companyLogoMemoryCacheProvider = Provider<AppImageMemoryCache>((ref) {
  return AppImageMemoryCache();
});

final companyLogoPickerProvider = Provider<CompanyLogoPickerService>((ref) {
  if (Platform.isAndroid || Platform.isIOS) {
    return ImagePickerCompanyLogoPickerService();
  }

  return FilePickerCompanyLogoPickerService();
});

final companyLogoStorageProvider = Provider<CompanyLogoStorageService>((ref) {
  return LocalCompanyLogoStorageService(
    cache: ref.watch(companyLogoMemoryCacheProvider),
  );
});
