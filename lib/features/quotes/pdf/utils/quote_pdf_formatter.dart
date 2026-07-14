import '../../../clients/utils/client_display_formatter.dart';
import '../../models/quote_client_snapshot.dart';
import '../../models/quote_client_type.dart';
import '../../models/quote_company_snapshot.dart';
import '../../models/quote_pix_key_type.dart';
import '../../utils/quote_detail_presenter.dart';
import '../models/quote_pdf_signature_block.dart';

abstract class QuotePdfFormatter {
  static const proposalDateLabel = 'Data da proposta';
  static const proposalNotesLabel = 'Observações da proposta';

  static const acceptanceDeclarationText =
      'Declaro que li e estou de acordo com os itens, valores, '
      'condições e observações desta proposta.';

  static const acceptanceLocalAndDateLine =
      'Local e data: __________________________________________';

  static const acceptanceDisclaimerText =
      'Os status registrados no EventPro servem apenas ao controle interno '
      'e não substituem as assinaturas do contratante e da contratada.';

  static const contractorRoleLabel = 'Contratante';
  static const contracteeRoleLabel = 'Contratada';
  static const contracteeRepresentativeRoleLabel = 'Representante da contratada';

  static String formatProposalDate(DateTime createdAt) {
    return _formatLongDate(createdAt);
  }

  static String formatApprovedAtSystemLabel(DateTime approvedAt) {
    return 'Aprovado no sistema em: ${_formatLongDate(approvedAt)} '
        'às ${_formatTime(approvedAt)}';
  }

  static QuotePdfSignatureBlock buildContractorSignatureBlock(
    QuoteClientSnapshot client,
  ) {
    return QuotePdfSignatureBlock(
      roleLabel: contractorRoleLabel,
      identificationLines: contractorIdentificationLines(client),
    );
  }

  static QuotePdfSignatureBlock buildContracteeSignatureBlock(
    QuoteCompanySnapshot company,
  ) {
    final representative = company.legalRepresentative;
    final hasRepresentative =
        representative != null && !representative.isEmpty;

    if (hasRepresentative) {
      return QuotePdfSignatureBlock(
        roleLabel: contracteeRoleLabel,
        identificationLines: contracteeIdentificationWithRepresentative(
          company: company,
          representative: representative,
        ),
      );
    }

    return QuotePdfSignatureBlock(
      roleLabel: contracteeRepresentativeRoleLabel,
      identificationLines: contracteeIdentificationWithoutRepresentative(
        company.identification,
      ),
    );
  }

  static List<String> contractorIdentificationLines(
    QuoteClientSnapshot client,
  ) {
    final lines = <String>[];

    switch (client.type) {
      case QuoteClientType.individual:
        lines.add(client.displayName.trim());
        final cpf = _formattedClientDocument(client);
        if (cpf != null) {
          lines.add('CPF $cpf');
        }
      case QuoteClientType.company:
        final name = optionalText(client.legalName) ?? client.displayName.trim();
        lines.add(name);
        final cnpj = _formattedClientDocument(client);
        if (cnpj != null) {
          lines.add('CNPJ $cnpj');
        }
    }

    return List.unmodifiable(lines);
  }

  static List<String> contracteeIdentificationWithRepresentative({
    required QuoteCompanySnapshot company,
    required QuoteCompanyLegalRepresentative representative,
  }) {
    final lines = <String>[];

    final representativeName = optionalText(representative.fullName);
    if (representativeName != null) {
      lines.add(representativeName);
    }

    final cpf = _formattedRepresentativeCpf(representative.cpfDigits);
    if (cpf != null) {
      lines.add('CPF $cpf');
    }

    final role = optionalText(representative.role);
    if (role != null) {
      lines.add(role);
    }

    lines.addAll(
      _companyIdentificationLines(company.identification),
    );

    return List.unmodifiable(lines);
  }

  static List<String> contracteeIdentificationWithoutRepresentative(
    QuoteCompanyIdentification identification,
  ) {
    return List.unmodifiable(_companyIdentificationLines(identification));
  }

  static String companyDisplayName(QuoteCompanyIdentification identification) {
    return optionalText(identification.legalName) ??
        identification.tradeName.trim();
  }

  static List<String> _companyIdentificationLines(
    QuoteCompanyIdentification identification,
  ) {
    final lines = <String>[companyDisplayName(identification)];

    final cnpj = formatCompanyCnpj(identification.cnpjDigits);
    if (cnpj != null) {
      lines.add('CNPJ $cnpj');
    }

    return lines;
  }

  static String? _formattedClientDocument(QuoteClientSnapshot client) {
    final digits = client.document?.trim() ?? '';
    if (digits.isEmpty) {
      return null;
    }

    final formatted = formatClientDocument(client);
    if (formatted == '—') {
      return null;
    }

    return formatted;
  }

  static String? _formattedRepresentativeCpf(String? digits) {
    final normalized = digits?.trim() ?? '';
    if (normalized.isEmpty) {
      return null;
    }

    return _maskDigits(normalized, '###.###.###-##');
  }

  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String? formatCompanyLegalLine({
    required String tradeName,
    String? legalName,
    String? cnpj,
    String? stateRegistration,
  }) {
    final parts = <String>[];
    final normalizedLegal = legalName?.trim();
    final normalizedTrade = tradeName.trim();

    if (normalizedLegal != null &&
        normalizedLegal.isNotEmpty &&
        normalizedLegal.toLowerCase() != normalizedTrade.toLowerCase()) {
      parts.add(normalizedLegal);
    }

    if (cnpj != null && cnpj.isNotEmpty) {
      parts.add('CNPJ $cnpj');
    }

    if (stateRegistration != null && stateRegistration.isNotEmpty) {
      parts.add('IE $stateRegistration');
    }

    return parts.isEmpty ? null : parts.join(' • ');
  }

  static String? formatCompanyContactsInline(QuoteCompanyContact contact) {
    final parts = <String>[];
    final whatsAppDigits = _digitsOnly(contact.whatsAppDigits);
    final phoneDigits = _digitsOnly(contact.phoneDigits);

    if (whatsAppDigits.isNotEmpty) {
      parts.add(_formatWhatsApp(contact.whatsAppDigits!));
    }

    if (phoneDigits.isNotEmpty && phoneDigits != whatsAppDigits) {
      parts.add(_formatPhone(contact.phoneDigits!));
    }

    final email = contact.email?.trim();
    if (email != null && email.isNotEmpty) {
      parts.add(email);
    }

    final website = contact.website?.trim();
    if (website != null && website.isNotEmpty) {
      parts.add(website);
    }

    final instagram = contact.instagram?.trim();
    if (instagram != null && instagram.isNotEmpty) {
      parts.add(instagram);
    }

    return parts.isEmpty ? null : parts.join(' • ');
  }

  static String? joinInlineParts(List<String?> parts) {
    final normalized = [
      for (final part in parts)
        if (part != null && part.trim().isNotEmpty) part.trim(),
    ];

    return normalized.isEmpty ? null : normalized.join(' • ');
  }

  static String formatMoney(int cents) {
    return QuoteDetailPresenter.formatMoney(cents);
  }

  static String formatQuantity(double quantity) {
    return QuoteDetailPresenter.formatQuantity(quantity);
  }

  static String formatClientDocument(QuoteClientSnapshot client) {
    return QuoteDetailPresenter.formatDocument(client);
  }

  static String clientDocumentLabel(QuoteClientType type) {
    return QuoteDetailPresenter.documentLabel(type);
  }

  static String? formatCompanyCnpj(String? digits) {
    final formatted = QuoteDetailPresenter.formatCompanyCnpj(digits);
    if (formatted == '—') {
      return null;
    }
    return formatted;
  }

  static String? formatCompanyAddress(QuoteCompanyAddress address) {
    return QuoteDetailPresenter.formatCompanyAddress(address);
  }

  static List<String> companyContactLines(QuoteCompanyContact contact) {
    final lines = <String>[];

    final whatsApp = contact.whatsAppDigits;
    if (whatsApp != null && whatsApp.isNotEmpty) {
      lines.add(_formatWhatsApp(whatsApp));
    }

    final phone = contact.phoneDigits;
    if (phone != null && phone.isNotEmpty) {
      lines.add(_formatPhone(phone));
    }

    final email = contact.email?.trim();
    if (email != null && email.isNotEmpty) {
      lines.add(email);
    }

    return lines;
  }

  static List<String> clientContactLines(QuoteClientSnapshot client) {
    final lines = <String>[];

    final whatsApp = client.whatsApp;
    if (whatsApp != null && whatsApp.isNotEmpty) {
      lines.add(_formatWhatsApp(whatsApp));
    }

    final phone = client.phone;
    if (phone != null && phone.isNotEmpty) {
      lines.add(_formatPhone(phone));
    }

    final email = client.email?.trim();
    if (email != null && email.isNotEmpty) {
      lines.add(email);
    }

    return lines;
  }

  static String composeFooterProfessionalText({
    required String tradeName,
    String? website,
    String? instagram,
  }) {
    final normalizedWebsite = website?.trim();
    if (normalizedWebsite != null && normalizedWebsite.isNotEmpty) {
      return normalizedWebsite;
    }

    final normalizedInstagram = instagram?.trim();
    if (normalizedInstagram != null && normalizedInstagram.isNotEmpty) {
      return normalizedInstagram;
    }

    return '$tradeName · Proposta comercial';
  }

  static String? formatPixKey({
    required QuotePixKeyType? type,
    required String? key,
  }) {
    final normalizedKey = key?.trim();
    if (type == null || normalizedKey == null || normalizedKey.isEmpty) {
      return null;
    }

    return switch (type) {
      QuotePixKeyType.cpf => _maskDigits(normalizedKey, '###.###.###-##'),
      QuotePixKeyType.cnpj => _maskDigits(normalizedKey, '##.###.###/####-##'),
      QuotePixKeyType.phone => _formatPhone(normalizedKey),
      QuotePixKeyType.email || QuotePixKeyType.random => normalizedKey,
    };
  }

  static String? formatEventTimeRange({
    String? startTime,
    String? endTime,
  }) {
    final start = startTime?.trim();
    final end = endTime?.trim();

    if (start != null && start.isNotEmpty && end != null && end.isNotEmpty) {
      return '$start – $end';
    }

    if (start != null && start.isNotEmpty) {
      return start;
    }

    if (end != null && end.isNotEmpty) {
      return end;
    }

    return null;
  }

  static String? optionalText(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  static String? positiveMoneyLabel(int cents) {
    if (cents <= 0) {
      return null;
    }
    return formatMoney(cents);
  }

  /// Compact billing-unit labels for PDF table layout only.
  /// Stored quote values remain unchanged.
  static String formatCompactUnitForPdf(String unit) {
    final normalized = unit.trim();
    if (normalized.isEmpty) {
      return normalized;
    }

    return switch (normalized) {
      'Unidade' => 'un.',
      'Diária' => 'diária',
      'Hora' => 'hora',
      'Metro' => 'm',
      'Metro quadrado' => 'm²',
      'Evento' => 'evento',
      'Serviço' => 'serviço',
      _ => normalized,
    };
  }

  static String _formatWhatsApp(String digits) {
    final formatted = ClientDisplayFormatter.formatWhatsApp(digits);
    return formatted.isEmpty ? digits : formatted;
  }

  static String _formatPhone(String digits) {
    final formatted = ClientDisplayFormatter.formatPhone(digits);
    return formatted.isEmpty ? digits : formatted;
  }

  static String _formatLongDate(DateTime date) {
    const monthNames = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro',
    ];
    final normalized = DateTime(date.year, date.month, date.day);
    return '${normalized.day} de ${monthNames[normalized.month - 1]} de ${normalized.year}';
  }

  static String _digitsOnly(String? value) {
    if (value == null) {
      return '';
    }

    return value.replaceAll(RegExp(r'\D'), '');
  }

  static String _maskDigits(String digits, String mask) {
    final buffer = StringBuffer();
    var digitIndex = 0;
    for (var i = 0; i < mask.length; i++) {
      if (mask[i] == '#') {
        if (digitIndex >= digits.length) {
          break;
        }
        buffer.write(digits[digitIndex]);
        digitIndex++;
      } else {
        buffer.write(mask[i]);
      }
    }
    return buffer.toString();
  }
}
