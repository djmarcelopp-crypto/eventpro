import '../../catalog/models/catalog_item.dart';
import '../models/quote.dart';
import '../models/quote_line_draft.dart';
import '../models/quote_line_item.dart';
import 'quote_date_formatter.dart';
import 'quote_money_display.dart';
import 'quote_quantity_parser.dart';

class QuoteFormInitializerValues {
  const QuoteFormInitializerValues({
    required this.selectedClientId,
    required this.lines,
    required this.discountText,
    required this.freightText,
    required this.validUntilText,
    required this.eventName,
    required this.eventType,
    required this.eventDateText,
    required this.eventStartTimeText,
    required this.eventEndTimeText,
    required this.eventVenueName,
    required this.eventAddress,
    required this.guestCountText,
    required this.notes,
    required this.internalNotes,
    this.validUntil,
    this.eventDate,
  });

  final String? selectedClientId;
  final List<QuoteLineDraft> lines;
  final String discountText;
  final String freightText;
  final String validUntilText;
  final DateTime? validUntil;
  final String eventName;
  final String eventType;
  final String eventDateText;
  final DateTime? eventDate;
  final String eventStartTimeText;
  final String eventEndTimeText;
  final String eventVenueName;
  final String eventAddress;
  final String guestCountText;
  final String notes;
  final String internalNotes;
}

abstract class QuoteFormInitializer {
  static QuoteFormInitializerValues fromQuote(Quote quote) {
    final event = quote.eventSnapshot;

    return QuoteFormInitializerValues(
      selectedClientId: quote.clientSnapshot.sourceClientId,
      lines: [
        for (var i = 0; i < quote.items.length; i++)
          lineDraftFromItem(
            quote.items[i],
            draftId: 'line_${i + 1}',
          ),
      ],
      discountText: quote.discountCents > 0
          ? QuoteMoneyDisplay.formatForInput(quote.discountCents)
          : '',
      freightText: quote.freightCents > 0
          ? QuoteMoneyDisplay.formatForInput(quote.freightCents)
          : '',
      validUntil: quote.validUntil,
      validUntilText: quote.validUntil == null
          ? ''
          : QuoteDateFormatter.format(quote.validUntil!),
      eventName: event.name ?? '',
      eventType: event.type ?? '',
      eventDate: event.date,
      eventDateText:
          event.date == null ? '' : QuoteDateFormatter.format(event.date!),
      eventStartTimeText: event.startTime ?? '',
      eventEndTimeText: event.endTime ?? '',
      eventVenueName: event.venueName ?? '',
      eventAddress: event.addressSummary ?? '',
      guestCountText:
          event.guestCount == null ? '' : event.guestCount.toString(),
      notes: quote.notes ?? '',
      internalNotes: quote.internalNotes ?? '',
    );
  }

  static QuoteLineDraft lineDraftFromItem(
    QuoteLineItem item, {
    required String draftId,
  }) {
    return QuoteLineDraft(
      draftId: draftId,
      catalogItemId: item.catalogItemId ?? '',
      name: item.name,
      description: item.description,
      unit: item.unit,
      quantityText: QuoteQuantityParser.formatForInput(item.quantity),
      priceText: QuoteMoneyDisplay.formatForInput(item.unitPriceCents),
      isExistingLine: true,
      packageComponents: item.packageComponents,
    );
  }
}

enum QuoteLineCatalogAvailability {
  active,
  inactive,
  missing,
}

abstract class QuoteLineCatalogStatus {
  static QuoteLineCatalogAvailability resolve({
    required bool isExistingLine,
    required String catalogItemId,
    required CatalogItem? catalogItem,
  }) {
    if (catalogItem == null) {
      return QuoteLineCatalogAvailability.missing;
    }
    if (!catalogItem.active) {
      return QuoteLineCatalogAvailability.inactive;
    }
    return QuoteLineCatalogAvailability.active;
  }

  static String? warningMessage(QuoteLineCatalogAvailability availability) {
    return switch (availability) {
      QuoteLineCatalogAvailability.active => null,
      QuoteLineCatalogAvailability.inactive =>
        'Item inativo no catálogo. Você pode manter, editar valores ou remover '
        'manualmente. Para atualizar pelo catálogo, remova e adicione novamente.',
      QuoteLineCatalogAvailability.missing =>
        'Item não encontrado no catálogo. Você pode manter, editar valores ou '
        'remover manualmente. Para atualizar pelo catálogo, remova e adicione '
        'novamente.',
    };
  }
}
