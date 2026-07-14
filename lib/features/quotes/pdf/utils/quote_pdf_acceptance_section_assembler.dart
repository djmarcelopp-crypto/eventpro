import '../../models/quote_client_snapshot.dart';
import '../../models/quote_company_snapshot.dart';
import '../models/quote_pdf_acceptance_section.dart';
import 'quote_pdf_formatter.dart';

abstract class QuotePdfAcceptanceSectionAssembler {
  static const title = 'Aceite da proposta';

  static QuotePdfAcceptanceSection assemble({
    required QuoteClientSnapshot clientSnapshot,
    required QuoteCompanySnapshot companySnapshot,
    DateTime? approvedAt,
  }) {
    return QuotePdfAcceptanceSection(
      title: title,
      declarationText: QuotePdfFormatter.acceptanceDeclarationText,
      localAndDateLine: QuotePdfFormatter.acceptanceLocalAndDateLine,
      contractorBlock: QuotePdfFormatter.buildContractorSignatureBlock(
        clientSnapshot,
      ),
      contracteeBlock: QuotePdfFormatter.buildContracteeSignatureBlock(
        companySnapshot,
      ),
      disclaimerText: QuotePdfFormatter.acceptanceDisclaimerText,
      approvedAtLabel: approvedAt == null
          ? null
          : QuotePdfFormatter.formatApprovedAtSystemLabel(approvedAt),
    );
  }
}
