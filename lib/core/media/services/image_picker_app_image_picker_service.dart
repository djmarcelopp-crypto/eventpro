import 'package:image_picker/image_picker.dart';

import '../models/app_image_pick_result.dart';
import 'app_image_picker_service.dart';

class ImagePickerAppImagePickerService implements AppImagePickerService {
  ImagePickerAppImagePickerService({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<AppImagePickResult?> pickImage() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (file == null) {
      return null;
    }

    final bytes = await file.readAsBytes();
    final extension = _resolveExtension(file.path);
    return AppImagePickResult(bytes: bytes, extension: extension);
  }

  String _resolveExtension(String path) {
    if (!path.contains('.')) {
      return 'jpg';
    }

    return path.split('.').last.toLowerCase();
  }
}
