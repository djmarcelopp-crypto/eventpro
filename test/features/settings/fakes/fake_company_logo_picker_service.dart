import 'dart:convert';
import 'dart:typed_data';

import 'package:eventpro/core/media/exceptions/app_image_pick_exception.dart';
import 'package:eventpro/core/media/models/app_image_pick_result.dart';
import 'package:eventpro/features/settings/data/services/company_logo_picker_service.dart';

final Uint8List kSettingsTestPngBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

class FakeCompanyLogoPickerService implements CompanyLogoPickerService {
  FakeCompanyLogoPickerService({
    this.pickResult,
    this.pickResults,
    this.pickException,
  });

  final AppImagePickResult? pickResult;
  final List<AppImagePickResult?>? pickResults;
  final AppImagePickException? pickException;

  var pickCount = 0;

  @override
  Future<AppImagePickResult?> pickImage() async {
    if (pickException != null) {
      pickCount++;
      throw pickException!;
    }

    if (pickResults != null) {
      final index =
          pickCount < pickResults!.length ? pickCount : pickResults!.length - 1;
      pickCount++;
      return pickResults![index];
    }

    pickCount++;
    return pickResult;
  }
}
