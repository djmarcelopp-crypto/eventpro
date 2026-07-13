import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/core/media/exceptions/app_image_storage_exception.dart';
import 'package:eventpro/core/media/services/app_image_memory_cache.dart';
import 'package:eventpro/core/media/services/local_app_image_copy_service.dart';
import 'package:eventpro/features/quotes/data/services/local_quote_company_logo_storage_service.dart';
import 'package:eventpro/features/settings/data/services/local_company_logo_storage_service.dart';

final Uint8List _minimalPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

final Uint8List _minimalJpg = base64Decode(
  '/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0a'
  'HBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIy'
  'MjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAABAAEDASIAAhEB'
  'AxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAn/xAAUEAEAAAAAAAAAAAAAAAAAAAAA/8QAFQEBAQAAAAAA'
  'AAAAAAAAAAAAAAf/xAAUEQEAAAAAAAAAAAAAAAAAAAAA/9oADAMBAAIRAxEAPwCwAB//2Q==',
);

void main() {
  group('LocalQuoteCompanyLogoStorageService', () {
    late Directory tempDir;
    late AppImageMemoryCache cache;
    late LocalAppImageCopyService copyService;
    late LocalQuoteCompanyLogoStorageService service;
    final fixedTimestamp = DateTime(2026, 7, 13, 10, 0, 0, 0, 123456);

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('quote_logo_test');
      cache = AppImageMemoryCache();
      copyService = LocalAppImageCopyService(
        cache: cache,
        sourcePrefixToDirectoryName: {
          LocalCompanyLogoStorageService.committedPrefix: 'settings_logo',
        },
        targetPrefixToDirectoryName: {
          LocalQuoteCompanyLogoStorageService.committedPrefix:
              LocalQuoteCompanyLogoStorageService.committedDirectoryName,
        },
        documentsDirectoryProvider: () async => tempDir,
      );
      service = LocalQuoteCompanyLogoStorageService(
        cache: cache,
        copyService: copyService,
        documentsDirectoryProvider: () async => tempDir,
      );
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    Future<void> seedSettingsLogo(
      String fileName,
      Uint8List bytes,
    ) async {
      final reference =
          '${LocalCompanyLogoStorageService.committedPrefix}$fileName';
      final file = File('${tempDir.path}/settings_logo/$fileName');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes, flush: true);
      cache.put(reference, bytes);
    }

    test('copia PNG preservando extensão e bytes', () async {
      await seedSettingsLogo('profile_1.png', _minimalPng);

      final copied = await service.copyFromSettingsLogo(
        settingsLogoReference: 'settings/logo/profile_1.png',
        quoteId: 'quote-1',
        timestamp: fixedTimestamp,
      );

      expect(copied, isNotNull);
      expect(
        copied,
        'quotes/company-assets/quote-1_${fixedTimestamp.microsecondsSinceEpoch}.png',
      );

      final bytes = await service.readBytes(copied!);
      expect(bytes, _minimalPng);
    });

    test('copia JPG preservando extensão e bytes', () async {
      await seedSettingsLogo('profile_2.jpg', _minimalJpg);

      final copied = await service.copyFromSettingsLogo(
        settingsLogoReference: 'settings/logo/profile_2.jpg',
        quoteId: 'quote-2',
        timestamp: fixedTimestamp,
      );

      expect(copied, isNotNull);
      expect(copied!.endsWith('.jpg'), isTrue);

      final bytes = await service.readBytes(copied);
      expect(bytes, _minimalJpg);
    });

    test('normaliza JPEG para jpg na cópia', () async {
      await seedSettingsLogo('profile_3.jpeg', _minimalJpg);

      final copied = await service.copyFromSettingsLogo(
        settingsLogoReference: 'settings/logo/profile_3.jpeg',
        quoteId: 'quote-3',
        timestamp: fixedTimestamp,
      );

      expect(copied, isNotNull);
      expect(copied!.endsWith('.jpg'), isTrue);
    });

    test('timestamp do nome usa valor injetado', () async {
      await seedSettingsLogo('profile_4.png', _minimalPng);
      final customTimestamp = DateTime(2025, 12, 25, 8, 30, 0, 0, 999999);

      final copied = await service.copyFromSettingsLogo(
        settingsLogoReference: 'settings/logo/profile_4.png',
        quoteId: 'quote-4',
        timestamp: customTimestamp,
      );

      expect(
        copied,
        'quotes/company-assets/quote-4_${customTimestamp.microsecondsSinceEpoch}.png',
      );
    });

    test('logo ausente retorna null sem erro', () async {
      final copied = await service.copyFromSettingsLogo(
        settingsLogoReference: 'settings/logo/missing.png',
        quoteId: 'quote-5',
        timestamp: fixedTimestamp,
      );

      expect(copied, isNull);
    });

    test('rejeita referência staged de settings', () async {
      expect(
        () => service.copyFromSettingsLogo(
          settingsLogoReference: 'settings/logo/staged/temp.png',
          quoteId: 'quote-6',
          timestamp: fixedTimestamp,
        ),
        throwsA(isA<InvalidImageReferenceException>()),
      );
    });

    test('rejeita path traversal sem expor caminho físico', () async {
      try {
        await service.copyFromSettingsLogo(
          settingsLogoReference: 'settings/logo/../secrets.png',
          quoteId: 'quote-7',
          timestamp: fixedTimestamp,
        );
        fail('Esperava exceção');
      } on InvalidImageReferenceException catch (error) {
        expect(error.toString(), 'Referência de imagem inválida');
        expect(error.toString(), isNot(contains(tempDir.path)));
        expect(error.toString(), isNot(contains('secrets')));
      }
    });

    test('rejeita prefixo inválido', () async {
      expect(
        () => service.copyFromSettingsLogo(
          settingsLogoReference: 'catalog/images/item.png',
          quoteId: 'quote-8',
          timestamp: fixedTimestamp,
        ),
        throwsA(isA<InvalidImageReferenceException>()),
      );
    });

    test('deleteCommitted em settings não remove cópia do orçamento', () async {
      await seedSettingsLogo('profile_9.png', _minimalPng);

      final copied = await service.copyFromSettingsLogo(
        settingsLogoReference: 'settings/logo/profile_9.png',
        quoteId: 'quote-9',
        timestamp: fixedTimestamp,
      );

      final settingsFile = File('${tempDir.path}/settings_logo/profile_9.png');
      await settingsFile.delete();

      expect(await service.exists(copied!), isTrue);
      expect(await copyService.exists('settings/logo/profile_9.png'), isFalse);
    });

    test('deleteCommitted remove cópia do orçamento', () async {
      await seedSettingsLogo('profile_10.png', _minimalPng);

      final copied = await service.copyFromSettingsLogo(
        settingsLogoReference: 'settings/logo/profile_10.png',
        quoteId: 'quote-10',
        timestamp: fixedTimestamp,
      );

      await service.deleteCommitted(copied);

      expect(await service.exists(copied!), isFalse);
    });
  });
}
