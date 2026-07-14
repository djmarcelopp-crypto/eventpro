import 'dart:convert';
import 'dart:typed_data';

import 'package:eventpro/features/quotes/models/quote_company_capture_status.dart';
import 'package:eventpro/features/quotes/models/quote_company_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_line_item.dart';
import 'package:eventpro/features/quotes/models/quote_pix_key_type.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/pdf/models/quote_pdf_document_data.dart';
import 'package:eventpro/features/quotes/pdf/theme/quote_pdf_font_loader.dart';
import 'package:eventpro/features/quotes/pdf/theme/quote_pdf_fonts.dart';
import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_document_builder.dart';

import '../quotes_test_helpers.dart';

const quotePdfFontRegularPath = 'assets/fonts/Inter-Regular.ttf';
const quotePdfFontSemiBoldPath = 'assets/fonts/Inter-SemiBold.ttf';

Future<QuotePdfFonts> loadQuotePdfTestFonts() {
  return QuotePdfFontLoader.loadFromProjectFiles(
    regularPath: quotePdfFontRegularPath,
    semiBoldPath: quotePdfFontSemiBoldPath,
  );
}

QuotePdfDocumentData buildSamplePdfDocumentData({
  QuoteStatus status = QuoteStatus.sent,
  List<QuoteLineItem>? items,
  String? proposalNotes,
  QuoteCompanySnapshot? companySnapshot,
}) {
  final quote = sampleQuoteDraft(
    status: status,
    companySnapshot: companySnapshot ?? sampleCompanySnapshot(),
    items: items ?? [sampleLineItem()],
  ).copyWith(
    number: 'ORC-2026-0001',
    notes: proposalNotes ?? 'Proposta válida em São Paulo — condição especial.',
    validUntil: DateTime(2026, 7, 20),
    createdAt: DateTime(2026, 7, 13),
    approvedAt: null,
    eventSnapshot: QuoteEventSnapshot(
      name: 'Ação beneficente',
      type: 'Corporativo',
      date: DateTime(2026, 9, 15),
      startTime: '18:00',
      endTime: '23:00',
      venueName: 'Espaço Garden',
      addressSummary: 'Rua das Flores, 100 • Campo Grande - MS',
      guestCount: 120,
    ),
    subtotalCents: 300_000,
    discountCents: 10_000,
    freightCents: 5_000,
    totalCents: 295_000,
  );

  return (QuotePdfDocumentBuilder.build(quote) as QuotePdfBuildSuccess).data;
}

List<QuoteLineItem> buildManyQuoteLineItems({
  int count = 30,
  String? description,
}) {
  return [
    for (var i = 1; i <= count; i++)
      QuoteLineItem(
        catalogItemId: 'item-$i',
        name: 'Item profissional $i',
        description: description ??
            'Descrição extensa do item $i com detalhes técnicos, '
                'especificações e observações para validar quebra de linha.',
        unit: 'Unidade',
        quantity: i % 3 == 0 ? 1.5 : 1,
        unitPriceCents: 10_000 + (i * 100),
        lineTotalCents: ((i % 3 == 0 ? 1.5 : 1) * (10_000 + (i * 100))).round(),
      ),
  ];
}

QuoteCompanySnapshot samplePdfCompanySnapshotWithPayment() {
  return QuoteCompanySnapshot(
    identification: const QuoteCompanyIdentification(
      tradeName: 'DJ Marcelo PP',
      legalName: 'Marcelo PP Festas LTDA',
      cnpjDigits: '11222333000181',
    ),
    contact: const QuoteCompanyContact(
      phoneDigits: '67999990000',
      whatsAppDigits: '67988887777',
      email: 'contato@djmarcelo.com',
      website: 'https://djmarcelo.com',
    ),
    address: const QuoteCompanyAddress(
      street: 'Rua Example',
      number: '100',
      city: 'Campo Grande',
      state: 'MS',
    ),
    payment: const QuoteCompanyPayment(
      pixKeyType: QuotePixKeyType.email,
      pixKey: 'pix@empresa.com',
      beneficiaryName: 'Empresa LTDA',
      paymentTerms: '50% na reserva',
    ),
    captureStatus: QuoteCompanyCaptureStatus.configured,
    capturedAt: DateTime(2026, 7, 13),
    logoReference: 'quotes/company-assets/quote_1.png',
  );
}

Uint8List minimalPngBytes() {
  return Uint8List.fromList(const [
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
    0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
    0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
  ]);
}

Uint8List minimalJpegBytes() {
  return Uint8List.fromList(const [
    0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46, 0x00, 0x01,
    0x01, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00, 0x00, 0xFF, 0xDB, 0x00, 0x43,
    0x00, 0x08, 0x06, 0x06, 0x07, 0x06, 0x05, 0x08, 0x07, 0x07, 0x07, 0x09,
    0x09, 0x08, 0x0A, 0x0C, 0x14, 0x0D, 0x0C, 0x0B, 0x0B, 0x0C, 0x19, 0x12,
    0x13, 0x0F, 0x14, 0x1D, 0x1A, 0x1F, 0x1E, 0x1D, 0x1A, 0x1C, 0x1C, 0x20,
    0x24, 0x2E, 0x27, 0x20, 0x22, 0x2C, 0x23, 0x1C, 0x1C, 0x28, 0x37, 0x29,
    0x2C, 0x30, 0x31, 0x34, 0x34, 0x34, 0x1F, 0x27, 0x39, 0x3D, 0x38, 0x32,
    0x3C, 0x2E, 0x33, 0x34, 0x32, 0xFF, 0xC0, 0x00, 0x0B, 0x08, 0x00, 0x01,
    0x00, 0x01, 0x01, 0x01, 0x11, 0x00, 0xFF, 0xC4, 0x00, 0x14, 0x00, 0x01,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x08, 0xFF, 0xC4, 0x00, 0x14, 0x10, 0x01, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0xFF, 0xDA, 0x00, 0x08, 0x01, 0x01, 0x00, 0x00, 0x3F, 0x00,
    0x7F, 0xFF, 0xD9,
  ]);
}

bool hasPdfSignature(Uint8List bytes) {
  return bytes.length > 4 &&
      bytes[0] == 0x25 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x44 &&
      bytes[3] == 0x46;
}

int estimatePdfPageCount(Uint8List bytes) {
  final content = latin1.decode(bytes, allowInvalid: true);
  return RegExp(r'/Type\s*/Page(?!s)').allMatches(content).length;
}
