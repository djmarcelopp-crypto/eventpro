import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;

import '../models/quote_pdf_acceptance_section.dart';
import '../models/quote_pdf_client_section.dart';
import '../models/quote_pdf_document_data.dart';
import '../models/quote_pdf_event_section.dart';
import '../models/quote_pdf_financial_summary.dart';
import '../models/quote_pdf_line_row.dart';
import '../models/quote_pdf_payment_section.dart';
import '../models/quote_pdf_signature_block.dart';
import '../theme/quote_pdf_fonts.dart';
import '../theme/quote_pdf_theme.dart';
import '../utils/quote_pdf_formatter.dart';

abstract class QuotePdfGenerator {
  Future<Uint8List> generate({
    required QuotePdfDocumentData data,
    required QuotePdfFonts fonts,
    Uint8List? logoBytes,
  });
}

class QuotePdfGeneratorService implements QuotePdfGenerator {
  const QuotePdfGeneratorService();

  @override
  Future<Uint8List> generate({
    required QuotePdfDocumentData data,
    required QuotePdfFonts fonts,
    Uint8List? logoBytes,
  }) async {
    final theme = QuotePdfTheme.create(fonts);
    final doc = pw.Document(theme: theme.themeData);

    doc.addPage(
      pw.MultiPage(
        maxPages: 100,
        pageTheme: pw.PageTheme(
          pageFormat: QuotePdfTheme.pageFormat,
          margin: QuotePdfTheme.pageMargin,
          theme: theme.themeData,
          buildBackground: (context) => _buildWatermark(data, theme),
        ),
        header: (context) => context.pageNumber <= 1
            ? pw.SizedBox.shrink()
            : _buildCompactPageHeader(data, theme),
        footer: (context) => _buildFooter(context, data, theme),
        build: (context) => [
          _buildFullCompanyHeader(data, theme, logoBytes),
          pw.SizedBox(height: QuotePdfTheme.sectionSpacing),
          _buildProposalIdentification(data, theme),
          pw.SizedBox(height: QuotePdfTheme.sectionSpacing),
          _buildClientEventSection(data, theme),
          pw.SizedBox(height: QuotePdfTheme.sectionSpacing),
          _sectionTitle('Itens da proposta', theme),
          _buildItemsTable(context, data.lines, theme),
          pw.SizedBox(height: QuotePdfTheme.sectionSpacing),
          _buildFinancialSection(data.financial, theme),
          if (data.payment != null) ...[
            pw.SizedBox(height: QuotePdfTheme.sectionSpacing),
            pw.Inseparable(
              child: _buildLightSection(
                title: 'Pagamento',
                lines: _paymentLines(data.payment!),
                theme: theme,
              ),
            ),
          ],
          if (data.proposalNotes != null) ...[
            pw.SizedBox(height: QuotePdfTheme.sectionSpacing),
            pw.Inseparable(
              child: _buildLightSection(
                title: QuotePdfFormatter.proposalNotesLabel,
                lines: [data.proposalNotes!],
                theme: theme,
              ),
            ),
          ],
          if (data.acceptanceSection != null) ...[
            pw.SizedBox(height: QuotePdfTheme.sectionSpacing),
            pw.Inseparable(
              child: _buildAcceptanceSection(data.acceptanceSection!, theme),
            ),
          ],
        ],
      ),
    );

    return doc.save();
  }

  pw.Widget _buildWatermark(QuotePdfDocumentData data, QuotePdfTheme theme) {
    final watermark = data.statusOverlay.watermarkText;
    if (watermark == null || watermark.isEmpty) {
      return pw.SizedBox.shrink();
    }

    return pw.FullPage(
      ignoreMargins: true,
      child: pw.Center(
        child: pw.Transform.rotate(
          angle: -0.55,
          child: pw.Text(
            watermark,
            style: theme.watermarkTextStyle,
            textAlign: pw.TextAlign.center,
          ),
        ),
      ),
    );
  }

  pw.Widget _buildFullCompanyHeader(
    QuotePdfDocumentData data,
    QuotePdfTheme theme,
    Uint8List? logoBytes,
  ) {
    final company = data.company;
    final legalLine = QuotePdfFormatter.formatCompanyLegalLine(
      tradeName: company.tradeName,
      legalName: company.legalName,
      cnpj: company.cnpj,
      stateRegistration: company.stateRegistration,
    );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        if (logoBytes != null && _isSupportedImage(logoBytes))
          pw.Container(
            height: QuotePdfTheme.logoMaxHeight,
            constraints: const pw.BoxConstraints(maxWidth: 220),
            alignment: pw.Alignment.center,
            child: pw.Image(
              pw.MemoryImage(logoBytes),
              fit: pw.BoxFit.contain,
            ),
          ),
        if (logoBytes != null && _isSupportedImage(logoBytes))
          pw.SizedBox(height: 8),
        pw.Text(
          company.tradeName,
          style: theme.tradeName,
          textAlign: pw.TextAlign.center,
        ),
        if (legalLine != null) ...[
          pw.SizedBox(height: 3),
          pw.Text(
            legalLine,
            style: theme.caption,
            textAlign: pw.TextAlign.center,
          ),
        ],
        if (company.contactLines.isNotEmpty) ...[
          pw.SizedBox(height: 3),
          pw.Text(
            company.contactLines.join(' • '),
            style: theme.caption,
            textAlign: pw.TextAlign.center,
          ),
        ],
        if (company.address != null) ...[
          pw.SizedBox(height: 3),
          pw.Text(
            company.address!,
            style: theme.caption,
            textAlign: pw.TextAlign.center,
          ),
        ],
        pw.SizedBox(height: 10),
        pw.Container(
          width: double.infinity,
          height: 1,
          color: QuotePdfTheme.gold,
        ),
      ],
    );
  }

  pw.Widget _buildCompactPageHeader(
    QuotePdfDocumentData data,
    QuotePdfTheme theme,
  ) {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Expanded(
              child: pw.Text(
                data.company.tradeName,
                style: theme.compactHeaderTitle,
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Text(data.quoteNumber, style: theme.caption),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Container(
          width: double.infinity,
          height: 0.6,
          color: QuotePdfTheme.gold,
        ),
        pw.SizedBox(height: 6),
      ],
    );
  }

  pw.Widget _buildProposalIdentification(
    QuotePdfDocumentData data,
    QuotePdfTheme theme,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          'PROPOSTA COMERCIAL',
          style: theme.proposalTitle,
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          data.quoteNumber,
          style: theme.quoteNumber,
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          children: [
            pw.Expanded(
              child: _metaColumn(
                label: QuotePdfFormatter.proposalDateLabel,
                value: data.proposalDateLabel,
                theme: theme,
              ),
            ),
            pw.Expanded(
              child: _metaColumn(
                label: 'Validade',
                value: data.validityDateLabel ?? '—',
                theme: theme,
              ),
            ),
            pw.Expanded(
              child: _metaColumn(
                label: 'Status',
                value: data.statusLabel,
                theme: theme,
                badge: data.statusOverlay.badgeText,
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _metaColumn({
    required String label,
    required String value,
    required QuotePdfTheme theme,
    String? badge,
  }) {
    return pw.Column(
      children: [
        pw.Text(label, style: theme.metaLabel, textAlign: pw.TextAlign.center),
        pw.SizedBox(height: 2),
        if (badge != null)
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: QuotePdfTheme.gold, width: 0.8),
              borderRadius: pw.BorderRadius.circular(3),
            ),
            child: pw.Text(
              badge,
              style: theme.badge,
              textAlign: pw.TextAlign.center,
            ),
          )
        else
          pw.Text(
            value,
            style: theme.metaValue,
            textAlign: pw.TextAlign.center,
          ),
      ],
    );
  }

  pw.Widget _buildClientEventSection(
    QuotePdfDocumentData data,
    QuotePdfTheme theme,
  ) {
    final event = data.event;

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: _infoBlock(
            title: 'Cliente',
            lines: _clientLines(data.client),
            theme: theme,
          ),
        ),
        if (event != null) ...[
          pw.SizedBox(width: 10),
          pw.Expanded(
            child: _infoBlock(
              title: 'Evento',
              lines: _eventLines(event),
              theme: theme,
            ),
          ),
        ],
      ],
    );
  }

  List<String> _clientLines(QuotePdfClientSection client) {
    final lines = <String>[
      '${client.name} (${client.typeLabel})',
    ];

    final document = QuotePdfFormatter.joinInlineParts([
      if (client.documentLabel != null && client.documentValue != null)
        '${client.documentLabel}: ${client.documentValue}',
    ]);
    if (document != null) {
      lines.add(document);
    }

    final contacts = client.contactLines.join(' • ');
    if (contacts.isNotEmpty) {
      lines.add(contacts);
    }

    if (client.legalName != null &&
        client.legalName!.trim().isNotEmpty &&
        client.legalName!.trim().toLowerCase() !=
            client.name.trim().toLowerCase()) {
      lines.add(client.legalName!);
    }

    if (client.address != null) {
      lines.add(client.address!);
    }

    return lines;
  }

  List<String> _eventLines(QuotePdfEventSection event) {
    final summary = QuotePdfFormatter.joinInlineParts([
      event.name,
      event.type,
      event.dateLabel,
      event.timeLabel,
      if (event.guestCountLabel != null) '${event.guestCountLabel} convidados',
    ]);
    final location = QuotePdfFormatter.joinInlineParts([
      event.venueName,
      event.address,
    ]);

    return [
      ?summary,
      ?location,
    ];
  }

  pw.Widget _infoBlock({
    required String title,
    required List<String> lines,
    required QuotePdfTheme theme,
  }) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(QuotePdfTheme.blockPadding),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: QuotePdfTheme.border, width: 0.6),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: theme.sectionTitle),
          pw.SizedBox(height: 4),
          for (final line in lines)
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: QuotePdfTheme.lineSpacing),
              child: pw.Text(line, style: theme.body),
            ),
        ],
      ),
    );
  }

  pw.Widget _sectionTitle(String title, QuotePdfTheme theme) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Text(title, style: theme.sectionTitle),
    );
  }

  pw.Widget _buildItemsTable(
    pw.Context context,
    List<QuotePdfLineRow> lines,
    QuotePdfTheme theme,
  ) {
    return pw.TableHelper.fromTextArray(
      context: context,
      headers: const [
        'Item',
        'Descrição',
        'Qtd',
        'Un.',
        'Preço unit.',
        'Subtotal',
      ],
      headerStyle: theme.tableHeader,
      headerDecoration: pw.BoxDecoration(color: QuotePdfTheme.gold),
      cellStyle: theme.tableCell,
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      border: pw.TableBorder(
        left: pw.BorderSide(color: QuotePdfTheme.border, width: 0.4),
        right: pw.BorderSide(color: QuotePdfTheme.border, width: 0.4),
        top: pw.BorderSide(color: QuotePdfTheme.border, width: 0.4),
        bottom: pw.BorderSide(color: QuotePdfTheme.border, width: 0.4),
        horizontalInside:
            pw.BorderSide(color: QuotePdfTheme.border, width: 0.3),
        verticalInside: pw.BorderSide(color: QuotePdfTheme.border, width: 0.3),
      ),
      cellAlignments: {
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
      },
      headerAlignments: {
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
      },
      columnWidths: {
        0: const pw.FlexColumnWidth(1.8),
        1: const pw.FlexColumnWidth(2.7),
        2: const pw.FlexColumnWidth(0.7),
        3: const pw.FlexColumnWidth(0.9),
        4: const pw.FlexColumnWidth(1.1),
        5: const pw.FlexColumnWidth(1.1),
      },
      data: [
        for (final line in lines)
          [
            line.itemName,
            line.description ?? '',
            line.quantityLabel,
            line.unit,
            line.unitPriceLabel,
            line.lineTotalLabel,
          ],
      ],
    );
  }

  pw.Widget _buildFinancialSection(
    QuotePdfFinancialSummary financial,
    QuotePdfTheme theme,
  ) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.SizedBox(
        width: 220,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            _financialRow('Subtotal', financial.subtotalLabel, theme),
            if (financial.discountLabel != null)
              _financialRow('Desconto', financial.discountLabel!, theme),
            if (financial.freightLabel != null)
              _financialRow('Frete', financial.freightLabel!, theme),
            pw.SizedBox(height: 4),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  top: pw.BorderSide(color: QuotePdfTheme.gold, width: 1.2),
                ),
              ),
              child: _financialRow('Total', financial.totalLabel, theme, bold: true),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _paymentLines(QuotePdfPaymentSection payment) {
    final lines = <String>[];

    if (payment.paymentTerms != null) {
      lines.add('Condições: ${payment.paymentTerms}');
    }

    final pix = QuotePdfFormatter.joinInlineParts([
      if (payment.pixKeyTypeLabel != null) 'PIX ${payment.pixKeyTypeLabel}',
      payment.pixKey,
    ]);
    if (pix != null) {
      lines.add(pix);
    }

    if (payment.beneficiaryName != null) {
      lines.add('Beneficiário: ${payment.beneficiaryName}');
    }

    return lines;
  }

  pw.Widget _buildLightSection({
    required String title,
    required List<String> lines,
    required QuotePdfTheme theme,
  }) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(QuotePdfTheme.blockPadding),
      decoration: pw.BoxDecoration(
        color: QuotePdfTheme.goldLight,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: theme.sectionTitle),
          pw.SizedBox(height: 4),
          for (final line in lines)
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: QuotePdfTheme.lineSpacing),
              child: pw.Text(line, style: theme.body),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildAcceptanceSection(
    QuotePdfAcceptanceSection section,
    QuotePdfTheme theme,
  ) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(QuotePdfTheme.blockPadding),
      decoration: pw.BoxDecoration(
        color: QuotePdfTheme.goldLight,
        border: pw.Border.all(color: QuotePdfTheme.border, width: 0.6),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Text(section.title, style: theme.sectionTitle),
          pw.SizedBox(height: 6),
          pw.Text(section.declarationText, style: theme.body),
          pw.SizedBox(height: 6),
          pw.Text(section.localAndDateLine, style: theme.body),
          if (section.approvedAtLabel != null) ...[
            pw.SizedBox(height: 4),
            pw.Text(section.approvedAtLabel!, style: theme.caption),
          ],
          pw.SizedBox(height: 10),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: _buildSignatureColumn(
                  block: section.contractorBlock,
                  theme: theme,
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: _buildSignatureColumn(
                  block: section.contracteeBlock,
                  theme: theme,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Text(section.disclaimerText, style: theme.disclaimer),
        ],
      ),
    );
  }

  pw.Widget _buildSignatureColumn({
    required QuotePdfSignatureBlock block,
    required QuotePdfTheme theme,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Text(block.roleLabel, style: theme.bodySemiBold),
        pw.SizedBox(height: 18),
        pw.Container(
          height: 22,
          decoration: pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(
                color: QuotePdfTheme.textPrimary,
                width: 0.8,
              ),
            ),
          ),
        ),
        pw.SizedBox(height: 6),
        for (final line in block.identificationLines)
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: QuotePdfTheme.lineSpacing),
            child: pw.Text(line, style: theme.caption),
          ),
      ],
    );
  }

  pw.Widget _buildFooter(
    pw.Context context,
    QuotePdfDocumentData data,
    QuotePdfTheme theme,
  ) {
    return pw.Column(
      children: [
        pw.Container(
          width: double.infinity,
          height: 0.5,
          color: QuotePdfTheme.border,
        ),
        pw.SizedBox(height: 4),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                data.quoteNumber,
                style: theme.caption,
              ),
            ),
            pw.Expanded(
              flex: 3,
              child: pw.Text(
                data.footerProfessionalText,
                style: theme.caption,
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                'Página ${context.pageNumber} de ${context.pagesCount}',
                style: theme.caption,
                textAlign: pw.TextAlign.right,
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _financialRow(
    String label,
    String value,
    QuotePdfTheme theme, {
    bool bold = false,
  }) {
    final valueStyle = bold ? theme.total : theme.bodySemiBold;

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: theme.body),
          pw.Text(value, style: valueStyle),
        ],
      ),
    );
  }

  bool _isSupportedImage(Uint8List bytes) {
    if (bytes.length < 4) {
      return false;
    }

    final isPng = bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47;
    final isJpeg = bytes[0] == 0xFF && bytes[1] == 0xD8;

    return isPng || isJpeg;
  }
}
