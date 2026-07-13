import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

import '../exceptions/catalog_image_pick_exception.dart';
import '../models/catalog_image_pick_result.dart';
import 'catalog_image_picker_service.dart';

class FilePickerCatalogImagePickerService implements CatalogImagePickerService {
  static const _allowedExtensions = ['jpg', 'jpeg', 'png'];

  static const _pickerUnavailableMessage =
      'Não foi possível abrir o seletor de imagens. Tente novamente.';

  static const _readFailureMessage =
      'Não foi possível ler o arquivo selecionado. Tente outra imagem.';

  @override
  Future<CatalogImagePickResult?> pickImage() async {
    FilePickerResult? result;

    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _allowedExtensions,
        withData: true,
      );
    } on PlatformException {
      throw const CatalogImagePickException(_pickerUnavailableMessage);
    } catch (error) {
      if (error is CatalogImagePickException) {
        rethrow;
      }
      throw const CatalogImagePickException(_pickerUnavailableMessage);
    }

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final file = result.files.single;
    final bytes = await _readBytes(file);
    if (bytes == null) {
      throw const CatalogImagePickException(_readFailureMessage);
    }

    final extension = _resolveExtension(file);
    return CatalogImagePickResult(bytes: bytes, extension: extension);
  }

  Future<Uint8List?> _readBytes(PlatformFile file) async {
    if (file.bytes != null) {
      return file.bytes;
    }

    final path = file.path;
    if (path == null) {
      return null;
    }

    try {
      return await File(path).readAsBytes();
    } on FileSystemException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  String _resolveExtension(PlatformFile file) {
    final extension = file.extension?.toLowerCase();
    if (extension != null && extension.isNotEmpty) {
      return extension;
    }

    final path = file.path;
    if (path != null && path.contains('.')) {
      return path.split('.').last.toLowerCase();
    }

    return 'jpg';
  }
}
