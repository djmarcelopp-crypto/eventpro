import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'catalog_image_memory_cache.dart';
import 'catalog_image_storage_service.dart';

class LocalCatalogImageStorageService implements CatalogImageStorageService {
  LocalCatalogImageStorageService({
    required this.cache,
    Future<Directory> Function()? documentsDirectoryProvider,
  }) : _documentsDirectoryProvider =
            documentsDirectoryProvider ?? getApplicationDocumentsDirectory;

  static const stagedPrefix = 'catalog/images/staged/';
  static const committedPrefix = 'catalog/images/';

  final CatalogImageMemoryCache cache;
  final Future<Directory> Function() _documentsDirectoryProvider;

  @override
  Future<String> stageFromPick({
    required Uint8List bytes,
    required String extension,
  }) async {
    final normalizedExtension = _normalizeExtension(extension);
    final fileName = '${DateTime.now().microsecondsSinceEpoch}.$normalizedExtension';
    final stagedReference = '$stagedPrefix$fileName';
    final file = await _resolveFile(stagedReference, isStaged: true);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    cache.put(stagedReference, bytes);
    return stagedReference;
  }

  @override
  Future<String> commitStaged({
    required String stagedReference,
    required String itemId,
  }) async {
    final stagedFile = await _resolveFile(stagedReference, isStaged: true);
    if (!await stagedFile.exists()) {
      throw StateError('Staged image not found: $stagedReference');
    }

    final extension = p.extension(stagedFile.path).replaceFirst('.', '');
    final committedName = '${itemId}_${DateTime.now().microsecondsSinceEpoch}.$extension';
    final committedReference = '$committedPrefix$committedName';
    final committedFile = await _resolveFile(committedReference, isStaged: false);

    await committedFile.parent.create(recursive: true);
    await stagedFile.rename(committedFile.path);

    final bytes = await committedFile.readAsBytes();
    cache.invalidate(stagedReference);
    cache.put(committedReference, bytes);
    return committedReference;
  }

  @override
  Future<void> discardStaged(String? stagedReference) async {
    if (stagedReference == null || !_isStagedReference(stagedReference)) {
      return;
    }

    final file = await _resolveFile(stagedReference, isStaged: true);
    if (await file.exists()) {
      await file.delete();
    }
    cache.invalidate(stagedReference);
  }

  @override
  Future<void> deleteCommitted(String? imageReference) async {
    if (imageReference == null || _isStagedReference(imageReference)) {
      return;
    }

    final file = await _resolveFile(imageReference, isStaged: false);
    if (await file.exists()) {
      await file.delete();
    }
    cache.invalidate(imageReference);
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

    final file = await _resolveFile(
      imageReference,
      isStaged: _isStagedReference(imageReference),
    );
    final bytes = await file.readAsBytes();
    cache.put(imageReference, bytes);
    return bytes;
  }

  @override
  Future<bool> exists(String imageReference) async {
    final file = await _resolveFile(
      imageReference,
      isStaged: _isStagedReference(imageReference),
    );
    return file.exists();
  }

  bool _isStagedReference(String imageReference) {
    return imageReference.startsWith(stagedPrefix);
  }

  Future<File> _resolveFile(String imageReference, {required bool isStaged}) async {
    final documentsDirectory = await _documentsDirectoryProvider();
    final relativePath = _referenceToRelativePath(imageReference, isStaged: isStaged);
    return File(p.join(documentsDirectory.path, relativePath));
  }

  String _referenceToRelativePath(String imageReference, {required bool isStaged}) {
    if (isStaged) {
      final fileName = imageReference.substring(stagedPrefix.length);
      return p.join('catalog_images_staged', fileName);
    }

    final fileName = imageReference.substring(committedPrefix.length);
    return p.join('catalog_images', fileName);
  }

  String _normalizeExtension(String extension) {
    final normalized = extension.toLowerCase().replaceAll('.', '');
    if (normalized == 'jpeg') {
      return 'jpg';
    }
    return normalized;
  }
}
