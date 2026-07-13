class QuoteLineDraft {
  QuoteLineDraft({
    required this.draftId,
    required this.catalogItemId,
    required this.name,
    required this.unit,
    required this.quantityText,
    required this.priceText,
  });

  final String draftId;
  final String catalogItemId;
  final String name;
  final String unit;
  final String quantityText;
  final String priceText;

  QuoteLineDraft copyWith({
    String? quantityText,
    String? priceText,
  }) {
    return QuoteLineDraft(
      draftId: draftId,
      catalogItemId: catalogItemId,
      name: name,
      unit: unit,
      quantityText: quantityText ?? this.quantityText,
      priceText: priceText ?? this.priceText,
    );
  }
}
