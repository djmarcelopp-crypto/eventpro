import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/data/services/catalog_image_memory_cache.dart';
import 'package:eventpro/features/catalog/data/services/local_catalog_image_storage_service.dart';

final Uint8List _minimalPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

void main() {
  group('LocalCatalogImageStorageService', () {
    late Directory tempDir;
    late CatalogImageMemoryCache cache;
    late LocalCatalogImageStorageService service;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('catalog_image_test');
      cache = CatalogImageMemoryCache();
      service = LocalCatalogImageStorageService(
        cache: cache,
        documentsDirectoryProvider: () async => tempDir,
      );
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('stage, commit, exists e readBytes', () async {
      final staged = await service.stageFromPick(
        bytes: _minimalPng,
        extension: 'png',
      );

      expect(await service.exists(staged), isTrue);

      final committed = await service.commitStaged(
        stagedReference: staged,
        itemId: 'item-1',
      );

      expect(committed.startsWith('catalog/images/item-1_'), isTrue);
      expect(await service.exists(committed), isTrue);
      expect(await service.exists(staged), isFalse);

      final bytes = await service.readBytes(committed);
      expect(bytes, _minimalPng);
      expect(cache.get(committed), _minimalPng);
    });

    test('discardStaged remove arquivo staged', () async {
      final staged = await service.stageFromPick(
        bytes: _minimalPng,
        extension: 'png',
      );

      await service.discardStaged(staged);

      expect(await service.exists(staged), isFalse);
      expect(cache.get(staged), isNull);
    });

    test('deleteCommitted remove arquivo e cache', () async {
      final staged = await service.stageFromPick(
        bytes: _minimalPng,
        extension: 'png',
      );
      final committed = await service.commitStaged(
        stagedReference: staged,
        itemId: 'item-2',
      );

      await service.deleteCommitted(committed);

      expect(await service.exists(committed), isFalse);
      expect(cache.get(committed), isNull);
    });
  });
}
