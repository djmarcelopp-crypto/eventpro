import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;

import '../theme/quote_pdf_fonts.dart';

abstract class QuotePdfFontLoader {
  static const regularAsset = 'assets/fonts/Inter-Regular.ttf';
  static const semiBoldAsset = 'assets/fonts/Inter-SemiBold.ttf';

  static Future<QuotePdfFonts> loadFromAssets() async {
    final regular = await rootBundle.load(regularAsset);
    final semiBold = await rootBundle.load(semiBoldAsset);
    return QuotePdfFonts.fromByteData(
      regularData: regular,
      semiBoldData: semiBold,
    );
  }

  static Future<QuotePdfFonts> loadFromProjectFiles({
    String regularPath = regularAsset,
    String semiBoldPath = semiBoldAsset,
  }) async {
    final regularBytes = await File(regularPath).readAsBytes();
    final semiBoldBytes = await File(semiBoldPath).readAsBytes();
    return QuotePdfFonts.fromByteData(
      regularData: ByteData.sublistView(regularBytes),
      semiBoldData: ByteData.sublistView(semiBoldBytes),
    );
  }
}
