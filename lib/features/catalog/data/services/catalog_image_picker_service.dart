import '../models/catalog_image_pick_result.dart';

abstract class CatalogImagePickerService {
  Future<CatalogImagePickResult?> pickImage();
}
