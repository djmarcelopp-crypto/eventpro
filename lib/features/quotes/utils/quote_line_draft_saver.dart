import '../../catalog/models/catalog_item.dart';
import '../models/quote_line_draft.dart';
import '../models/quote_line_item.dart';
import 'quote_money_display.dart';
import 'quote_quantity_parser.dart';

class QuoteLineDraftSaverResult {
  const QuoteLineDraftSaverResult({
    this.items,
    this.errorMessage,
  });

  final List<QuoteLineItem>? items;
  final String? errorMessage;

  bool get isSuccess => items != null && errorMessage == null;
}

abstract class QuoteLineDraftSaver {
  static QuoteLineDraftSaverResult buildLineItems({
    required List<QuoteLineDraft> drafts,
    required CatalogItem? Function(String id) findCatalogItem,
  }) {
    final result = <QuoteLineItem>[];

    for (final draft in drafts) {
      final quantity = QuoteQuantityParser.tryParse(draft.quantityText);
      final unitPriceCents = QuoteMoneyDisplay.parseToCents(draft.priceText);
      if (quantity == null || unitPriceCents == null) {
        return const QuoteLineDraftSaverResult(
          errorMessage: 'Revise as quantidades e preços antes de salvar.',
        );
      }

      if (draft.isExistingLine) {
        result.add(
          QuoteLineItem(
            catalogItemId:
                draft.catalogItemId.isEmpty ? null : draft.catalogItemId,
            name: draft.name,
            description: draft.description,
            unit: draft.unit,
            quantity: quantity,
            unitPriceCents: unitPriceCents,
            lineTotalCents: 0,
          ),
        );
        continue;
      }

      final item = findCatalogItem(draft.catalogItemId);
      if (item == null) {
        return QuoteLineDraftSaverResult(
          errorMessage:
              'O item "${draft.name}" não está mais disponível.',
        );
      }

      if (!item.active) {
        return QuoteLineDraftSaverResult(
          errorMessage:
              'O item "${draft.name}" está inativo e não pode ser incluído.',
        );
      }

      result.add(
        QuoteLineItem(
          catalogItemId: item.id,
          name: item.name,
          description: item.description,
          unit: item.unit,
          quantity: quantity,
          unitPriceCents: unitPriceCents,
          lineTotalCents: 0,
        ),
      );
    }

    return QuoteLineDraftSaverResult(items: result);
  }
}
