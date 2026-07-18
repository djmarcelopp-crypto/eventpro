/// A line linking an [Equipment] unit quantity to a quote/event.
///
/// Does **not** reserve stock or change [Equipment.status] — it only records
/// that the quote plans to use [quantity] units of [equipmentId].
class QuoteEquipment {
  const QuoteEquipment({
    required this.id,
    required this.quoteId,
    required this.equipmentId,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String quoteId;
  final String equipmentId;

  /// Planned quantity for this quote line. Must be greater than zero.
  final int quantity;

  final DateTime createdAt;
  final DateTime updatedAt;

  QuoteEquipment copyWith({
    String? id,
    String? quoteId,
    String? equipmentId,
    int? quantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuoteEquipment(
      id: id ?? this.id,
      quoteId: quoteId ?? this.quoteId,
      equipmentId: equipmentId ?? this.equipmentId,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is QuoteEquipment &&
            other.id == id &&
            other.quoteId == quoteId &&
            other.equipmentId == equipmentId &&
            other.quantity == quantity &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        quoteId,
        equipmentId,
        quantity,
        createdAt,
        updatedAt,
      );
}
