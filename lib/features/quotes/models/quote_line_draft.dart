class QuoteLineDraft {
  QuoteLineDraft({
    required this.draftId,
    required this.catalogItemId,
    required this.name,
    this.description,
    required this.unit,
    required this.quantityText,
    required this.priceText,
    required this.isExistingLine,
  });

  final String draftId;
  final String catalogItemId;
  final String name;
  final String? description;
  final String unit;
  final String quantityText;
  final String priceText;
  final bool isExistingLine;

  QuoteLineDraft copyWith({
    String? quantityText,
    String? priceText,
  }) {
    return QuoteLineDraft(
      draftId: draftId,
      catalogItemId: catalogItemId,
      name: name,
      description: description,
      unit: unit,
      quantityText: quantityText ?? this.quantityText,
      priceText: priceText ?? this.priceText,
      isExistingLine: isExistingLine,
    );
  }
}
