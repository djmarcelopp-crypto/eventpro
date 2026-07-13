import '../models/app_image_pick_result.dart';

abstract class AppImagePickerService {
  Future<AppImagePickResult?> pickImage();
}
