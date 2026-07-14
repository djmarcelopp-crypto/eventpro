import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;

class QuotePdfFonts {
  const QuotePdfFonts({
    required this.regular,
    required this.semiBold,
  });

  final pw.Font regular;
  final pw.Font semiBold;

  static QuotePdfFonts fromByteData({
    required ByteData regularData,
    required ByteData semiBoldData,
  }) {
    return QuotePdfFonts(
      regular: pw.Font.ttf(regularData),
      semiBold: pw.Font.ttf(semiBoldData),
    );
  }
}
