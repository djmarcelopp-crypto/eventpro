import 'dart:convert';
import 'dart:typed_data';

import 'package:eventpro/features/catalog/data/exceptions/catalog_image_pick_exception.dart';
import 'package:eventpro/features/catalog/data/models/catalog_image_pick_result.dart';
import 'package:eventpro/features/catalog/data/services/catalog_image_picker_service.dart';

final Uint8List kTestPngBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

class FakeCatalogImagePickerService implements CatalogImagePickerService {
  FakeCatalogImagePickerService({
    this.pickResult,
    this.pickResults,
    this.pickException,
  });

  final CatalogImagePickResult? pickResult;
  final List<CatalogImagePickResult?>? pickResults;
  final CatalogImagePickException? pickException;

  var pickCount = 0;

  @override
  Future<CatalogImagePickResult?> pickImage() async {
    if (pickException != null) {
      pickCount++;
      throw pickException!;
    }

    if (pickResults != null) {
      final index = pickCount < pickResults!.length ? pickCount : pickResults!.length - 1;
      pickCount++;
      return pickResults![index];
    }

    pickCount++;
    return pickResult;
  }
}
