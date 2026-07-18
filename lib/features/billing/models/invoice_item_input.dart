/// Draft line used when creating or replacing invoice items.
class InvoiceItemInput {
  const InvoiceItemInput({
    required this.description,
    required this.quantity,
    required this.unitPriceCents,
  });

  final String description;
  final double quantity;
  final int unitPriceCents;
}
