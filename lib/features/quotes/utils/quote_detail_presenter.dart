import '../../clients/utils/client_display_formatter.dart';
import '../models/quote.dart';
import '../models/quote_client_snapshot.dart';
import '../models/quote_client_type.dart';
import '../models/quote_company_capture_status.dart';
import '../models/quote_company_snapshot.dart';
import '../models/quote_event_snapshot.dart';
import '../models/quote_line_item.dart';
import '../models/quote_status.dart';
import '../models/quote_status_history_entry.dart';
import 'quote_date_formatter.dart';
import 'quote_datetime_formatter.dart';
import 'quote_money_display.dart';

class QuoteDetailItem {
  const QuoteDetailItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

abstract class QuoteDetailPresenter {
  static String formatDate(DateTime? date) {
    if (date == null) {
      return '—';
    }
    return QuoteDateFormatter.format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return QuoteDateTimeFormatter.format(dateTime);
  }

  static String formatMoney(int cents) {
    return QuoteMoneyDisplay.format(cents);
  }

  static String formatQuantity(double quantity) {
    if (quantity == quantity.roundToDouble()) {
      return quantity.toInt().toString();
    }

    for (var places = 1; places <= 3; places++) {
      final factor = _pow10(places);
      final scaled = quantity * factor;
      final nearest = scaled.roundToDouble();
      if ((scaled - nearest).abs() < 1e-9) {
        final text = quantity.toStringAsFixed(places);
        return text.replaceAll('.', ',');
      }
    }

    return quantity.toString().replaceAll('.', ',');
  }

  static int _pow10(int exponent) {
    var result = 1;
    for (var i = 0; i < exponent; i++) {
      result *= 10;
    }
    return result;
  }

  static String formatDocument(QuoteClientSnapshot client) {
    final digits = client.document ?? '';
    if (digits.isEmpty) {
      return '—';
    }

    return switch (client.type) {
      QuoteClientType.individual => _maskDigits(digits, '###.###.###-##'),
      QuoteClientType.company => _maskDigits(digits, '##.###.###/####-##'),
    };
  }

  static String documentLabel(QuoteClientType type) {
    return switch (type) {
      QuoteClientType.individual => 'CPF',
      QuoteClientType.company => 'CNPJ',
    };
  }

  static String? formatPrimaryContact(QuoteClientSnapshot client) {
    final whatsApp = client.whatsApp;
    if (whatsApp != null && whatsApp.isNotEmpty) {
      return _formatContactDigits(
        whatsApp,
        ClientDisplayFormatter.formatWhatsApp,
      );
    }

    final phone = client.phone;
    if (phone != null && phone.isNotEmpty) {
      return _formatContactDigits(
        phone,
        ClientDisplayFormatter.formatPhone,
      );
    }

    final email = client.email?.trim();
    if (email != null && email.isNotEmpty) {
      return email;
    }

    return null;
  }

  static String _formatContactDigits(
    String digits,
    String Function(String) formatter,
  ) {
    final formatted = formatter(digits);
    if (formatted.isEmpty) {
      return digits;
    }
    return formatted;
  }

  static String formatCompanyCnpj(String? digits) {
    final normalized = digits?.trim() ?? '';
    if (normalized.isEmpty) {
      return '—';
    }
    return _maskDigits(normalized, '##.###.###/####-##');
  }

  static String? formatCompanyPrimaryContact(QuoteCompanyContact contact) {
    final whatsApp = contact.whatsAppDigits;
    if (whatsApp != null && whatsApp.isNotEmpty) {
      return _formatContactDigits(
        whatsApp,
        ClientDisplayFormatter.formatWhatsApp,
      );
    }

    final phone = contact.phoneDigits;
    if (phone != null && phone.isNotEmpty) {
      return _formatContactDigits(
        phone,
        ClientDisplayFormatter.formatPhone,
      );
    }

    final email = contact.email?.trim();
    if (email != null && email.isNotEmpty) {
      return email;
    }

    return null;
  }

  static String? formatCompanyAddress(QuoteCompanyAddress address) {
    if (address.isEmpty) {
      return null;
    }

    final parts = <String>[];

    final street = address.street?.trim();
    final number = address.number?.trim();
    if (street != null && street.isNotEmpty) {
      if (number != null && number.isNotEmpty) {
        parts.add('$street, $number');
      } else {
        parts.add(street);
      }
    }

    final complement = address.complement?.trim();
    if (complement != null && complement.isNotEmpty) {
      parts.add(complement);
    }

    final neighborhood = address.neighborhood?.trim();
    if (neighborhood != null && neighborhood.isNotEmpty) {
      parts.add(neighborhood);
    }

    final city = address.city?.trim();
    final state = address.state?.trim();
    if (city != null && city.isNotEmpty) {
      if (state != null && state.isNotEmpty) {
        parts.add('$city - $state');
      } else {
        parts.add(city);
      }
    } else if (state != null && state.isNotEmpty) {
      parts.add(state);
    }

    if (parts.isEmpty) {
      return null;
    }

    return parts.join(' • ');
  }

  static String companyIssuerStatusLabel(QuoteCompanyCaptureStatus status) {
    return switch (status) {
      QuoteCompanyCaptureStatus.configured =>
        'Dados completos no momento da criação',
      QuoteCompanyCaptureStatus.incomplete =>
        'Dados incompletos no momento da criação',
    };
  }

  static List<QuoteDetailItem> companyIssuerItems(
    QuoteCompanySnapshot snapshot,
  ) {
    final items = <QuoteDetailItem>[
      QuoteDetailItem(
        label: 'Nome comercial',
        value: snapshot.identification.tradeName,
      ),
    ];

    final legalName = snapshot.identification.legalName?.trim();
    if (legalName != null && legalName.isNotEmpty) {
      items.add(QuoteDetailItem(label: 'Razão social', value: legalName));
    }

    final cnpjDigits = snapshot.identification.cnpjDigits;
    if (cnpjDigits != null && cnpjDigits.isNotEmpty) {
      items.add(
        QuoteDetailItem(
          label: 'CNPJ',
          value: formatCompanyCnpj(cnpjDigits),
        ),
      );
    }

    final stateRegistration =
        snapshot.identification.stateRegistration?.trim();
    if (stateRegistration != null && stateRegistration.isNotEmpty) {
      items.add(
        QuoteDetailItem(
          label: 'Inscrição estadual',
          value: stateRegistration,
        ),
      );
    }

    final contact = formatCompanyPrimaryContact(snapshot.contact);
    if (contact != null) {
      items.add(QuoteDetailItem(label: 'Contato', value: contact));
    }

    final address = formatCompanyAddress(snapshot.address);
    if (address != null) {
      items.add(QuoteDetailItem(label: 'Endereço', value: address));
    }

    items.add(
      QuoteDetailItem(
        label: 'Status dos dados',
        value: companyIssuerStatusLabel(snapshot.captureStatus),
      ),
    );

    return items;
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

  static List<QuoteDetailItem> headerItems(Quote quote) {
    return [
      QuoteDetailItem(label: 'Criado em', value: formatDateTime(quote.createdAt)),
      QuoteDetailItem(label: 'Atualizado em', value: formatDateTime(quote.updatedAt)),
      if (quote.approvedAt != null)
        QuoteDetailItem(
          label: 'Aprovado em',
          value: formatDateTime(quote.approvedAt!),
        ),
      QuoteDetailItem(
        label: 'Validade',
        value: formatDate(quote.validUntil),
      ),
    ];
  }

  static List<QuoteDetailItem> clientItems(QuoteClientSnapshot client) {
    final items = <QuoteDetailItem>[
      QuoteDetailItem(label: 'Tipo', value: client.type.label),
      QuoteDetailItem(label: 'Nome', value: client.displayName),
    ];

    final legalName = client.legalName?.trim();
    if (legalName != null && legalName.isNotEmpty) {
      items.add(QuoteDetailItem(label: 'Razão social', value: legalName));
    }

    final document = client.document;
    if (document != null && document.isNotEmpty) {
      items.add(
        QuoteDetailItem(
          label: documentLabel(client.type),
          value: formatDocument(client),
        ),
      );
    }

    final contact = formatPrimaryContact(client);
    if (contact != null) {
      items.add(QuoteDetailItem(label: 'Contato', value: contact));
    }

    final address = client.addressSummary?.trim();
    if (address != null && address.isNotEmpty) {
      items.add(QuoteDetailItem(label: 'Endereço', value: address));
    }

    return items;
  }

  static List<QuoteDetailItem> eventItems(QuoteEventSnapshot event) {
    final items = <QuoteDetailItem>[];

    _addIfPresent(items, 'Nome', event.name);
    _addIfPresent(items, 'Tipo', event.type);
    if (event.date != null) {
      items.add(
        QuoteDetailItem(label: 'Data', value: formatDate(event.date)),
      );
    }
    _addIfPresent(items, 'Horário inicial', event.startTime);
    _addIfPresent(items, 'Horário final', event.endTime);
    _addIfPresent(items, 'Local', event.venueName);
    _addIfPresent(items, 'Endereço', event.addressSummary);
    if (event.guestCount != null) {
      items.add(
        QuoteDetailItem(
          label: 'Convidados',
          value: event.guestCount.toString(),
        ),
      );
    }

    return items;
  }

  static List<QuoteDetailItem> financialItems(Quote quote) {
    return [
      QuoteDetailItem(label: 'Subtotal', value: formatMoney(quote.subtotalCents)),
      QuoteDetailItem(label: 'Desconto', value: formatMoney(quote.discountCents)),
      QuoteDetailItem(label: 'Frete', value: formatMoney(quote.freightCents)),
      QuoteDetailItem(label: 'Total', value: formatMoney(quote.totalCents)),
    ];
  }

  static String historyEntryLabel(QuoteStatusHistoryEntry entry) {
    if (entry.previousStatus == null) {
      return 'Orçamento criado como ${entry.newStatus.label}';
    }
    return '${entry.previousStatus!.label} → ${entry.newStatus.label}';
  }

  static void _addIfPresent(
    List<QuoteDetailItem> items,
    String label,
    String? value,
  ) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return;
    }
    items.add(QuoteDetailItem(label: label, value: trimmed));
  }
}

abstract class QuoteLinePresenter {
  static String lineTitle(QuoteLineItem item) {
    return item.name;
  }

  static List<QuoteDetailItem> lineItems(QuoteLineItem item) {
    final items = <QuoteDetailItem>[
      QuoteDetailItem(label: 'Unidade', value: item.unit),
      QuoteDetailItem(
        label: 'Quantidade',
        value: QuoteDetailPresenter.formatQuantity(item.quantity),
      ),
      QuoteDetailItem(
        label: 'Preço unitário',
        value: QuoteDetailPresenter.formatMoney(item.unitPriceCents),
      ),
      QuoteDetailItem(
        label: 'Total da linha',
        value: QuoteDetailPresenter.formatMoney(item.lineTotalCents),
      ),
    ];

    final description = item.description?.trim();
    if (description != null && description.isNotEmpty) {
      items.insert(
        1,
        QuoteDetailItem(label: 'Descrição', value: description),
      );
    }

    return items;
  }
}
