import 'quote_pdf_signature_block.dart';

class QuotePdfAcceptanceSection {
  const QuotePdfAcceptanceSection({
    required this.title,
    required this.declarationText,
    required this.localAndDateLine,
    required this.contractorBlock,
    required this.contracteeBlock,
    required this.disclaimerText,
    this.approvedAtLabel,
  });

  final String title;
  final String declarationText;
  final String localAndDateLine;
  final QuotePdfSignatureBlock contractorBlock;
  final QuotePdfSignatureBlock contracteeBlock;
  final String disclaimerText;
  final String? approvedAtLabel;
}
