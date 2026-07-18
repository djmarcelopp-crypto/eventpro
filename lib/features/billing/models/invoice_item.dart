/// A line item belonging to an [Invoice].
///
/// Immutable domain entity. Persistence and pricing orchestration are out of
/// scope for the domain foundation checkpoint.
class InvoiceItem {
  const InvoiceItem({
    required this.id,
    required this.invoiceId,
    required this.description,
    required this.quantity,
    required this.unitPriceCents,
    required this.totalPriceCents,
  });

  final String id;
  final String invoiceId;
  final String description;
  final double quantity;
  final int unitPriceCents;
  final int totalPriceCents;

  InvoiceItem copyWith({
    String? id,
    String? invoiceId,
    String? description,
    double? quantity,
    int? unitPriceCents,
    int? totalPriceCents,
  }) {
    return InvoiceItem(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unitPriceCents: unitPriceCents ?? this.unitPriceCents,
      totalPriceCents: totalPriceCents ?? this.totalPriceCents,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is InvoiceItem &&
            other.id == id &&
            other.invoiceId == invoiceId &&
            other.description == description &&
            other.quantity == quantity &&
            other.unitPriceCents == unitPriceCents &&
            other.totalPriceCents == totalPriceCents;
  }

  @override
  int get hashCode => Object.hash(
        id,
        invoiceId,
        description,
        quantity,
        unitPriceCents,
        totalPriceCents,
      );
}
