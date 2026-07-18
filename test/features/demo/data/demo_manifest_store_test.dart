import 'dart:io';

import 'package:eventpro/features/demo/data/demo_manifest_store.dart';
import 'package:eventpro/features/demo/models/demo_seed_manifest.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DemoManifestStore', () {
    late Directory tempDir;
    late DemoManifestStore store;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('demo_manifest_store_');
      store = DemoManifestStore(documentsDirectory: () async => tempDir);
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('read returns null when file is absent', () async {
      expect(await store.read(), isNull);
    });

    test('write, read and clearFile round-trip', () async {
      final manifest = DemoSeedManifest(
        clientIds: const ['demo-client-1'],
        quoteIds: const ['demo-quote-today'],
        seededAt: DateTime(2026, 7, 17, 12),
      );

      await store.write(manifest);
      final loaded = await store.read();
      expect(loaded, isNotNull);
      expect(loaded!.clientIds, ['demo-client-1']);
      expect(loaded.quoteIds, ['demo-quote-today']);

      await store.clearFile();
      expect(await store.read(), isNull);
    });

    test('corrupted file is treated as absent (no throw)', () async {
      final file = File('${tempDir.path}/${DemoManifestStore.fileName}');
      await file.writeAsString('{not-json');
      expect(await store.read(), isNull);
    });
  });
}
