import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_filename_builder.dart';

void main() {
  group('QuotePdfFilenameBuilder', () {
    test('gera nome seguro a partir do número do orçamento', () {
      expect(
        QuotePdfFilenameBuilder.build('ORC-2026-0001'),
        'orcamento_ORC-2026-0001.pdf',
      );
    });

    test('remove caracteres inválidos e espaços', () {
      expect(
        QuotePdfFilenameBuilder.build('ORC/2026:0001 teste'),
        'orcamento_ORC20260001teste.pdf',
      );
    });

    test('não inclui documentos sensíveis no nome do arquivo', () {
      final filename = QuotePdfFilenameBuilder.build('ORC-2026-0001');

      expect(filename.contains('52998224725'), isFalse);
      expect(filename.contains('pix@'), isFalse);
      expect(filename.contains('Maria'), isFalse);
    });

    test('usa fallback quando número sanitizado fica vazio', () {
      expect(
        QuotePdfFilenameBuilder.build('///'),
        'orcamento_orcamento.pdf',
      );
    });
  });
}
