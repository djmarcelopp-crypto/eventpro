import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/data/services/quote_company_logo_storage_service.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/pdf/theme/quote_pdf_fonts.dart';
import 'package:eventpro/features/quotes/pdf/services/quote_pdf_logo_loader.dart';
import 'package:eventpro/features/quotes/pdf/services/quote_pdf_generator_service.dart';

import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_status_policy.dart';

import '../fakes/fake_quote_company_logo_storage_service.dart';

import 'quote_pdf_test_helpers.dart';

void main() {
  group('QuotePdfGeneratorService', () {
    late QuotePdfGeneratorService generator;
    late QuotePdfFonts fonts;

    setUpAll(() async {
      fonts = await loadQuotePdfTestFonts();
    });

    setUp(() {
      generator = const QuotePdfGeneratorService();
    });

    Future<Uint8List> generateMinimal({Uint8List? logoBytes}) {
      final data = buildSamplePdfDocumentData();
      return generator.generate(
        data: data,
        fonts: fonts,
        logoBytes: logoBytes,
      );
    }

    test('gera bytes com assinatura PDF válida', () async {
      final bytes = await generateMinimal();

      expect(bytes, isNotEmpty);
      expect(hasPdfSignature(bytes), isTrue);
    });

    test('gera orçamento mínimo em uma página', () async {
      final bytes = await generateMinimal();

      expect(estimatePdfPageCount(bytes), greaterThanOrEqualTo(1));
    });

    test('gera orçamento com 30 itens e descrições longas em múltiplas páginas',
        () async {
      final data = buildSamplePdfDocumentData(
        items: buildManyQuoteLineItems(count: 30),
      );

      final bytes = await generator.generate(
        data: data,
        fonts: fonts,
      );

      expect(bytes, isNotEmpty);
      expect(hasPdfSignature(bytes), isTrue);
      expect(estimatePdfPageCount(bytes), greaterThan(1));
    });

    test('gera PDF com textos acentuados sem erro', () async {
      final data = buildSamplePdfDocumentData(
        proposalNotes: 'Proposta em São Paulo — condição especial à disposição.',
      );

      await expectLater(
        generator.generate(data: data, fonts: fonts),
        completes,
      );
    });

    test('gera PDF com logo PNG', () async {
      final bytes = await generateMinimal(logoBytes: minimalPngBytes());

      expect(hasPdfSignature(bytes), isTrue);
    });

    test('gera PDF com logo JPG', () async {
      final bytes = await generateMinimal(logoBytes: minimalJpegBytes());

      expect(hasPdfSignature(bytes), isTrue);
    });

    test('gera PDF sem logo quando bytes ausentes', () async {
      final bytes = await generateMinimal(logoBytes: null);

      expect(hasPdfSignature(bytes), isTrue);
    });

    test('gera PDF mesmo com logo ilegível', () async {
      final bytes = await generateMinimal(
        logoBytes: Uint8List.fromList([1, 2, 3, 4]),
      );

      expect(hasPdfSignature(bytes), isTrue);
    });
  });

  group('QuotePdfGeneratorService — overlays de status', () {
    late QuotePdfGeneratorService generator;
    late QuotePdfFonts fonts;

    setUpAll(() async {
      fonts = await loadQuotePdfTestFonts();
      generator = const QuotePdfGeneratorService();
    });

    for (final status in QuoteStatus.values) {
      test('gera PDF para status ${status.name}', () async {
        final data = buildSamplePdfDocumentData(status: status);
        final overlay = QuotePdfStatusPolicy.overlayFor(status);

        expect(data.statusOverlay.watermarkText, overlay.watermarkText);
        expect(data.statusOverlay.badgeText, overlay.badgeText);

        final bytes = await generator.generate(data: data, fonts: fonts);
        expect(hasPdfSignature(bytes), isTrue);
      });
    }
  });

  group('QuotePdfLogoLoader', () {
    test('carrega logo somente de quotes/company-assets/', () async {
      final storage = FakeQuoteCompanyLogoStorageService()
        ..seedQuoteLogo('quotes/company-assets/logo.png', minimalPngBytes());

      final bytes = await QuotePdfLogoLoader.load(
        storage: storage,
        logoReference: 'quotes/company-assets/logo.png',
      );

      expect(bytes, isNotNull);
    });

    test('rejeita referência de settings/logo/', () async {
      final storage = FakeQuoteCompanyLogoStorageService()
        ..seedSettingsLogo('settings/logo/profile.png', minimalPngBytes());

      final bytes = await QuotePdfLogoLoader.load(
        storage: storage,
        logoReference: 'settings/logo/profile.png',
      );

      expect(bytes, isNull);
    });

    test('retorna null quando leitura falha', () async {
      final storage = _FailingQuoteCompanyLogoStorageService();

      final bytes = await QuotePdfLogoLoader.load(
        storage: storage,
        logoReference: 'quotes/company-assets/broken.png',
      );

      expect(bytes, isNull);
    });
  });
}

class _FailingQuoteCompanyLogoStorageService
    implements QuoteCompanyLogoStorageService {
  @override
  Future<String?> copyFromSettingsLogo({
    required String settingsLogoReference,
    required String quoteId,
    required DateTime timestamp,
  }) async {
    return null;
  }

  @override
  Future<void> deleteCommitted(String? imageReference) async {}

  @override
  Future<bool> exists(String imageReference) async => true;

  @override
  Future<Uint8List?> readBytes(String imageReference) async {
    throw StateError('read failure');
  }
}
