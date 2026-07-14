import 'dart:io';

import 'package:eventpro/features/quotes/pdf/services/quote_pdf_generator_service.dart';
import 'package:eventpro/features/quotes/pdf/theme/quote_pdf_font_loader.dart';
import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_document_builder.dart';

import 'quote_pdf_demo_fixtures.dart';

Future<void> main() async {
  final fonts = await QuotePdfFontLoader.loadFromProjectFiles();
  const generator = QuotePdfGeneratorService();
  final quote = buildDemoQuote();

  final buildResult = QuotePdfDocumentBuilder.build(quote);
  if (buildResult is! QuotePdfBuildSuccess) {
    stderr.writeln('Não foi possível montar o PDF de demonstração.');
    exitCode = 1;
    return;
  }

  final bytes = await generator.generate(
    data: buildResult.data,
    fonts: fonts,
    logoBytes: await loadDemoLogoPngBytes(),
  );

  final output = File('build/quote_pdf_demo.pdf');
  await output.parent.create(recursive: true);
  await output.writeAsBytes(bytes, flush: true);

  stdout.writeln('PDF de demonstração gerado em: ${output.path}');
}
