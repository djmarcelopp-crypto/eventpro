import 'package:eventpro/core/media/models/app_image_pick_result.dart';

abstract class CompanyLogoPickerService {
  Future<AppImagePickResult?> pickImage();
}
