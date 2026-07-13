import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../exceptions/app_image_storage_exception.dart';
import '../utils/app_image_reference_validator.dart';
import 'app_image_copy_service.dart';
import 'app_image_memory_cache.dart';

class LocalAppImageCopyService implements AppImageCopyService {
  LocalAppImageCopyService({
    required this.cache,
    required this.sourcePrefixToDirectoryName,
    required this.targetPrefixToDirectoryName,
    Future<Directory> Function()? documentsDirectoryProvider,
  }) : _documentsDirectoryProvider =
            documentsDirectoryProvider ?? getApplicationDocumentsDirectory;

  final AppImageMemoryCache cache;
  final Map<String, String> sourcePrefixToDirectoryName;
  final Map<String, String> targetPrefixToDirectoryName;
  final Future<Directory> Function() _documentsDirectoryProvider;

  @override
  Future<String> copyCommitted({
    required String sourceReference,
    required Set<String> allowedSourcePrefixes,
    required String targetReferencePrefix,
    required String targetDirectoryName,
    required String ownerId,
    required DateTime timestamp,
  }) async {
    AppImageReferenceValidator.validateAllowedPrefix(
      sourceReference,
      allowedSourcePrefixes,
    );

    if (!targetPrefixToDirectoryName.containsKey(targetReferencePrefix)) {
      throw const InvalidImageReferenceException();
    }

    final extension =
        AppImageReferenceValidator.normalizeImageExtension(sourceReference);
    final sourceFile = await _resolveSourceFile(sourceReference);
    if (!await sourceFile.exists()) {
      throw const ImageCopyFailedException();
    }

    final committedName = '${ownerId}_${timestamp.microsecondsSinceEpoch}.$extension';
    final targetReference = '$targetReferencePrefix$committedName';
    final targetFile = await _resolveTargetFile(
      targetReference,
      targetDirectoryName,
    );

    await targetFile.parent.create(recursive: true);
    await sourceFile.copy(targetFile.path);

    final bytes = await targetFile.readAsBytes();
    cache.put(targetReference, bytes);
    return targetReference;
  }

  @override
  Future<Uint8List?> readBytes(String imageReference) async {
    final cached = cache.get(imageReference);
    if (cached != null) {
      return cached;
    }

    if (!await exists(imageReference)) {
      return null;
    }

    final file = await _resolveReadableFile(imageReference);
    final bytes = await file.readAsBytes();
    cache.put(imageReference, bytes);
    return bytes;
  }

  @override
  Future<bool> exists(String imageReference) async {
    try {
      AppImageReferenceValidator.validateReference(imageReference);
    } on InvalidImageReferenceException {
      return false;
    }

    final file = await _resolveReadableFile(imageReference);
    return file.exists();
  }

  Future<File> _resolveSourceFile(String sourceReference) async {
    final directoryName = _directoryForReference(
      sourceReference,
      sourcePrefixToDirectoryName,
    );
    return _fileForReference(sourceReference, directoryName);
  }

  Future<File> _resolveTargetFile(
    String targetReference,
    String targetDirectoryName,
  ) async {
    return _fileForReference(targetReference, targetDirectoryName);
  }

  Future<File> _resolveReadableFile(String imageReference) async {
    final directoryName = _directoryForReference(
      imageReference,
      {...sourcePrefixToDirectoryName, ...targetPrefixToDirectoryName},
    );
    return _fileForReference(imageReference, directoryName);
  }

  String _directoryForReference(
    String imageReference,
    Map<String, String> prefixToDirectory,
  ) {
    for (final entry in prefixToDirectory.entries) {
      if (imageReference.startsWith(entry.key)) {
        return entry.value;
      }
    }

    throw const InvalidImageReferenceException();
  }

  String _fileNameFromReference(String imageReference) {
    for (final prefix
        in {...sourcePrefixToDirectoryName.keys, ...targetPrefixToDirectoryName.keys}) {
      if (imageReference.startsWith(prefix)) {
        return imageReference.substring(prefix.length);
      }
    }

    throw const InvalidImageReferenceException();
  }

  Future<File> _fileForReference(
    String imageReference,
    String directoryName,
  ) async {
    final documentsDirectory = await _documentsDirectoryProvider();
    final fileName = _fileNameFromReference(imageReference);
    return File(p.join(documentsDirectory.path, directoryName, fileName));
  }
}
