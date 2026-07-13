import 'dart:typed_data';

import 'package:eventpro/features/catalog/data/services/catalog_image_memory_cache.dart';
import 'package:eventpro/features/catalog/data/services/catalog_image_storage_service.dart';
import 'package:eventpro/features/catalog/data/services/local_catalog_image_storage_service.dart';

class FakeCatalogImageStorageService implements CatalogImageStorageService {
  FakeCatalogImageStorageService({CatalogImageMemoryCache? cache})
      : _cache = cache ?? CatalogImageMemoryCache();

  final CatalogImageMemoryCache _cache;
  final Map<String, Uint8List> _staged = {};
  final Map<String, Uint8List> _committed = {};
  final List<String> _discardLog = [];
  final List<String> _deleteLog = [];

  List<String> get discardLog => List.unmodifiable(_discardLog);
  List<String> get deleteLog => List.unmodifiable(_deleteLog);

  void seedCommitted(String reference, Uint8List bytes) {
    _committed[reference] = bytes;
    _cache.put(reference, bytes);
  }

  var stageCallCount = 0;
  String? lastStagedReference;

  @override
  Future<String> stageFromPick({
    required Uint8List bytes,
    required String extension,
  }) async {
    stageCallCount++;
    final reference =
        '${LocalCatalogImageStorageService.stagedPrefix}test_$extension.${extension == 'jpeg' ? 'jpg' : extension}';
    _staged[reference] = bytes;
    _cache.put(reference, bytes);
    lastStagedReference = reference;
    return reference;
  }

  @override
  Future<String> commitStaged({
    required String stagedReference,
    required String itemId,
  }) async {
    final bytes = _staged.remove(stagedReference);
    if (bytes == null) {
      throw StateError('Staged image not found: $stagedReference');
    }

    final committedReference =
        '${LocalCatalogImageStorageService.committedPrefix}${itemId}_test.jpg';
    _committed[committedReference] = bytes;
    _cache.invalidate(stagedReference);
    _cache.put(committedReference, bytes);
    return committedReference;
  }

  @override
  Future<void> discardStaged(String? stagedReference) async {
    if (stagedReference == null) {
      return;
    }

    _discardLog.add(stagedReference);
    _staged.remove(stagedReference);
    _cache.invalidate(stagedReference);
  }

  @override
  Future<void> deleteCommitted(String? imageReference) async {
    if (imageReference == null) {
      return;
    }

    _deleteLog.add(imageReference);
    _committed.remove(imageReference);
    _cache.invalidate(imageReference);
  }

  @override
  Future<Uint8List?> readBytes(String imageReference) async {
    final cached = _cache.get(imageReference);
    if (cached != null) {
      return cached;
    }

    return _committed[imageReference] ?? _staged[imageReference];
  }

  @override
  Future<bool> exists(String imageReference) async {
    return _committed.containsKey(imageReference) ||
        _staged.containsKey(imageReference);
  }
}
