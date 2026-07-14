import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'quote_pdf_fonts.dart';

class QuotePdfTheme {
  QuotePdfTheme._({
    required this.themeData,
    required this.tradeName,
    required this.proposalTitle,
    required this.quoteNumber,
    required this.sectionTitle,
    required this.body,
    required this.bodySemiBold,
    required this.caption,
    required this.metaLabel,
    required this.metaValue,
    required this.tableHeader,
    required this.tableCell,
    required this.badge,
    required this.watermarkTextStyle,
    required this.total,
    required this.compactHeaderTitle,
  });

  static const pageFormat = PdfPageFormat.a4;
  static const pageMargin = pw.EdgeInsets.symmetric(horizontal: 36, vertical: 32);

  static final background = PdfColors.white;
  static final textPrimary = PdfColor.fromInt(0xFF1A1A1A);
  static final textSecondary = PdfColor.fromInt(0xFF4A4A4A);
  static final gold = PdfColor.fromInt(0xFFB8962E);
  static final goldLight = PdfColor.fromInt(0xFFF8F4EA);
  static final border = PdfColor.fromInt(0xFFE6E6E6);
  static final watermarkColor = PdfColor.fromInt(0x22B8962E);
  static final tableHeaderText = PdfColors.white;

  static const double logoMaxHeight = 85;
  static const double sectionSpacing = 10;
  static const double lineSpacing = 2;
  static const double blockPadding = 8;

  final pw.ThemeData themeData;
  final pw.TextStyle tradeName;
  final pw.TextStyle proposalTitle;
  final pw.TextStyle quoteNumber;
  final pw.TextStyle sectionTitle;
  final pw.TextStyle body;
  final pw.TextStyle bodySemiBold;
  final pw.TextStyle caption;
  final pw.TextStyle metaLabel;
  final pw.TextStyle metaValue;
  final pw.TextStyle tableHeader;
  final pw.TextStyle tableCell;
  final pw.TextStyle badge;
  final pw.TextStyle watermarkTextStyle;
  final pw.TextStyle total;
  final pw.TextStyle compactHeaderTitle;

  static QuotePdfTheme create(QuotePdfFonts fonts) {
    final bodyStyle = pw.TextStyle(
      font: fonts.regular,
      fontSize: 9.5,
      color: textPrimary,
    );
    final captionStyle = pw.TextStyle(
      font: fonts.regular,
      fontSize: 8,
      color: textSecondary,
    );

    return QuotePdfTheme._(
      themeData: pw.ThemeData.withFont(
        base: fonts.regular,
        bold: fonts.semiBold,
      ),
      tradeName: pw.TextStyle(
        font: fonts.semiBold,
        fontSize: 18,
        color: textPrimary,
      ),
      proposalTitle: pw.TextStyle(
        font: fonts.semiBold,
        fontSize: 14,
        color: gold,
        letterSpacing: 1.2,
      ),
      quoteNumber: pw.TextStyle(
        font: fonts.semiBold,
        fontSize: 11,
        color: textPrimary,
      ),
      sectionTitle: pw.TextStyle(
        font: fonts.semiBold,
        fontSize: 10,
        color: gold,
      ),
      body: bodyStyle,
      bodySemiBold: pw.TextStyle(
        font: fonts.semiBold,
        fontSize: 9.5,
        color: textPrimary,
      ),
      caption: captionStyle,
      metaLabel: pw.TextStyle(
        font: fonts.regular,
        fontSize: 7.5,
        color: textSecondary,
      ),
      metaValue: pw.TextStyle(
        font: fonts.semiBold,
        fontSize: 9,
        color: textPrimary,
      ),
      tableHeader: pw.TextStyle(
        font: fonts.semiBold,
        fontSize: 8.5,
        color: tableHeaderText,
      ),
      tableCell: bodyStyle,
      badge: pw.TextStyle(
        font: fonts.semiBold,
        fontSize: 8.5,
        color: gold,
      ),
      watermarkTextStyle: pw.TextStyle(
        font: fonts.semiBold,
        fontSize: 60,
        color: watermarkColor,
      ),
      total: pw.TextStyle(
        font: fonts.semiBold,
        fontSize: 13,
        color: textPrimary,
      ),
      compactHeaderTitle: pw.TextStyle(
        font: fonts.semiBold,
        fontSize: 9,
        color: textPrimary,
      ),
    );
  }
}
