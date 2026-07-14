class QuotePdfLineRow {
  const QuotePdfLineRow({
    required this.itemName,
    this.description,
    required this.quantityLabel,
    required this.unit,
    required this.unitPriceLabel,
    required this.lineTotalLabel,
  });

  final String itemName;
  final String? description;
  final String quantityLabel;
  final String unit;
  final String unitPriceLabel;
  final String lineTotalLabel;
}
