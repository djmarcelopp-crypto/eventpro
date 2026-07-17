/// A quote that plans to consume units of an equipment item in a period.
class EquipmentConsumingQuote {
  const EquipmentConsumingQuote({
    required this.quoteId,
    required this.quantity,
    required this.periodStart,
    required this.periodEnd,
    this.quoteNumber,
  });

  final String quoteId;
  final String? quoteNumber;
  final int quantity;
  final DateTime periodStart;
  final DateTime periodEnd;
}
