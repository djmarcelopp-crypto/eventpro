import '../../models/quote.dart';
import '../../models/quote_client_snapshot.dart';
import '../../models/quote_client_type.dart';
import '../../models/quote_company_snapshot.dart';
import '../../models/quote_event_snapshot.dart';
import '../../models/quote_line_item.dart';
import '../../models/quote_pix_key_type.dart';
import '../../models/quote_status.dart';
import '../models/quote_pdf_acceptance_section.dart';
import '../models/quote_pdf_client_section.dart';
import '../models/quote_pdf_company_section.dart';
import '../models/quote_pdf_document_data.dart';
import '../models/quote_pdf_event_section.dart';
import '../models/quote_pdf_financial_summary.dart';
import '../models/quote_pdf_line_row.dart';
import '../models/quote_pdf_payment_section.dart';
import 'quote_pdf_acceptance_policy.dart';
import 'quote_pdf_acceptance_section_assembler.dart';
import 'quote_pdf_eligibility.dart';
import 'quote_pdf_formatter.dart';
import 'quote_pdf_status_policy.dart';

sealed class QuotePdfBuildResult {
  const QuotePdfBuildResult();
}

class QuotePdfBuildBlocked extends QuotePdfBuildResult {
  const QuotePdfBuildBlocked(this.message);

  final String message;
}

class QuotePdfBuildSuccess extends QuotePdfBuildResult {
  const QuotePdfBuildSuccess(this.data);

  final QuotePdfDocumentData data;
}

abstract class QuotePdfDocumentBuilder {
  static QuotePdfBuildResult build(Quote quote) {
    final eligibility = QuotePdfEligibility.evaluate(quote);
    if (eligibility is QuotePdfEligibilityBlocked) {
      return QuotePdfBuildBlocked(eligibility.message);
    }

    final companySnapshot = quote.companySnapshot!;
    final proposalDateLabel = QuotePdfFormatter.formatProposalDate(
      quote.createdAt,
    );

    return QuotePdfBuildSuccess(
      QuotePdfDocumentData(
        quoteNumber: quote.number,
        proposalDateLabel: proposalDateLabel,
        validityDateLabel: quote.validUntil == null
            ? null
            : QuotePdfFormatter.formatProposalDate(quote.validUntil!),
        statusLabel: quote.status.label,
        statusOverlay: QuotePdfStatusPolicy.overlayFor(quote.status),
        company: _buildCompanySection(companySnapshot),
        client: _buildClientSection(quote.clientSnapshot),
        event: _buildEventSection(quote.eventSnapshot),
        lines: _buildLineRows(quote.items),
        financial: QuotePdfFinancialSummary(
          subtotalLabel: QuotePdfFormatter.formatMoney(quote.subtotalCents),
          discountLabel: QuotePdfFormatter.positiveMoneyLabel(
            quote.discountCents,
          ),
          freightLabel: QuotePdfFormatter.positiveMoneyLabel(quote.freightCents),
          totalLabel: QuotePdfFormatter.formatMoney(quote.totalCents),
        ),
        payment: _buildPaymentSection(companySnapshot.payment),
        proposalNotes: QuotePdfFormatter.optionalText(quote.notes),
        acceptanceSection: _buildAcceptanceSection(quote),
        footerProfessionalText: QuotePdfFormatter.composeFooterProfessionalText(
          tradeName: companySnapshot.identification.tradeName,
          website: companySnapshot.contact.website,
          instagram: companySnapshot.contact.instagram,
        ),
        footerProposalDateLabel: proposalDateLabel,
      ),
    );
  }

  static QuotePdfCompanySection _buildCompanySection(
    QuoteCompanySnapshot companySnapshot,
  ) {
    final identification = companySnapshot.identification;
    final contact = companySnapshot.contact;
    final address = companySnapshot.address;

    final contactsInline = QuotePdfFormatter.formatCompanyContactsInline(contact);

    return QuotePdfCompanySection(
      tradeName: identification.tradeName,
      legalName: QuotePdfFormatter.optionalText(identification.legalName),
      cnpj: QuotePdfFormatter.formatCompanyCnpj(identification.cnpjDigits),
      stateRegistration: QuotePdfFormatter.optionalText(
        identification.stateRegistration,
      ),
      contactLines: contactsInline == null ? const [] : [contactsInline],
      address: QuotePdfFormatter.formatCompanyAddress(address),
      logoReference: QuotePdfFormatter.optionalText(companySnapshot.logoReference),
    );
  }

  static QuotePdfClientSection _buildClientSection(
    QuoteClientSnapshot clientSnapshot,
  ) {
    final document = clientSnapshot.document;
    final hasDocument = document != null && document.isNotEmpty;

    return QuotePdfClientSection(
      typeLabel: clientSnapshot.type.label,
      name: clientSnapshot.displayName,
      legalName: QuotePdfFormatter.optionalText(clientSnapshot.legalName),
      documentLabel: hasDocument
          ? QuotePdfFormatter.clientDocumentLabel(clientSnapshot.type)
          : null,
      documentValue: hasDocument
          ? QuotePdfFormatter.formatClientDocument(clientSnapshot)
          : null,
      contactLines: QuotePdfFormatter.clientContactLines(clientSnapshot),
      address: QuotePdfFormatter.optionalText(clientSnapshot.addressSummary),
    );
  }

  static QuotePdfEventSection? _buildEventSection(
    QuoteEventSnapshot eventSnapshot,
  ) {
    final section = QuotePdfEventSection(
      name: QuotePdfFormatter.optionalText(eventSnapshot.name),
      type: QuotePdfFormatter.optionalText(eventSnapshot.type),
      dateLabel: eventSnapshot.date == null
          ? null
          : QuotePdfFormatter.formatProposalDate(eventSnapshot.date!),
      timeLabel: QuotePdfFormatter.formatEventTimeRange(
        startTime: eventSnapshot.startTime,
        endTime: eventSnapshot.endTime,
      ),
      venueName: QuotePdfFormatter.optionalText(eventSnapshot.venueName),
      address: QuotePdfFormatter.optionalText(eventSnapshot.addressSummary),
      guestCountLabel: eventSnapshot.guestCount?.toString(),
    );

    return section.isEmpty ? null : section;
  }

  static List<QuotePdfLineRow> _buildLineRows(List<QuoteLineItem> items) {
    return [
      for (final item in items)
        QuotePdfLineRow(
          itemName: item.name,
          description: QuotePdfFormatter.optionalText(item.description),
          quantityLabel: QuotePdfFormatter.formatQuantity(item.quantity),
          unit: QuotePdfFormatter.formatCompactUnitForPdf(item.unit),
          unitPriceLabel: QuotePdfFormatter.formatMoney(item.unitPriceCents),
          lineTotalLabel: QuotePdfFormatter.formatMoney(item.lineTotalCents),
        ),
    ];
  }

  static QuotePdfPaymentSection? _buildPaymentSection(
    QuoteCompanyPayment? payment,
  ) {
    if (payment == null) {
      return null;
    }

    final section = QuotePdfPaymentSection(
      paymentTerms: QuotePdfFormatter.optionalText(payment.paymentTerms),
      pixKeyTypeLabel: payment.pixKeyType?.label,
      pixKey: QuotePdfFormatter.formatPixKey(
        type: payment.pixKeyType,
        key: payment.pixKey,
      ),
      beneficiaryName: QuotePdfFormatter.optionalText(payment.beneficiaryName),
    );

    return section.isEmpty ? null : section;
  }

  static QuotePdfAcceptanceSection? _buildAcceptanceSection(Quote quote) {
    if (!QuotePdfAcceptancePolicy.shouldIncludeAcceptanceSection(quote.status)) {
      return null;
    }

    final approvedAt = quote.status == QuoteStatus.approved
        ? quote.approvedAt
        : null;

    return QuotePdfAcceptanceSectionAssembler.assemble(
      clientSnapshot: quote.clientSnapshot,
      companySnapshot: quote.companySnapshot!,
      approvedAt: approvedAt,
    );
  }
}
