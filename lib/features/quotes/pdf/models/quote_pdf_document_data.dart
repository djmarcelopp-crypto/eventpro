import 'quote_pdf_acceptance_section.dart';
import 'quote_pdf_client_section.dart';
import 'quote_pdf_company_section.dart';
import 'quote_pdf_event_section.dart';
import 'quote_pdf_financial_summary.dart';
import 'quote_pdf_line_row.dart';
import 'quote_pdf_payment_section.dart';
import 'quote_pdf_status_overlay.dart';

class QuotePdfDocumentData {
  const QuotePdfDocumentData({
    required this.quoteNumber,
    required this.proposalDateLabel,
    this.validityDateLabel,
    required this.statusLabel,
    required this.statusOverlay,
    required this.company,
    required this.client,
    this.event,
    required this.lines,
    required this.financial,
    this.payment,
    this.proposalNotes,
    this.acceptanceSection,
    required this.footerProfessionalText,
    required this.footerProposalDateLabel,
  });

  final String quoteNumber;
  final String proposalDateLabel;
  final String? validityDateLabel;
  final String statusLabel;
  final QuotePdfStatusOverlay statusOverlay;
  final QuotePdfCompanySection company;
  final QuotePdfClientSection client;
  final QuotePdfEventSection? event;
  final List<QuotePdfLineRow> lines;
  final QuotePdfFinancialSummary financial;
  final QuotePdfPaymentSection? payment;
  final String? proposalNotes;
  final QuotePdfAcceptanceSection? acceptanceSection;
  final String footerProfessionalText;
  final String footerProposalDateLabel;
}
