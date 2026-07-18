import 'package:eventpro/features/equipment/models/quote_equipment.dart';

/// Domain contract for persisting [QuoteEquipment] link rows.
abstract class QuoteEquipmentRepository {
  Future<List<QuoteEquipment>> listAll();

  Future<QuoteEquipment?> findById(String id);

  /// Lines for a given quote, ordered by [QuoteEquipment.createdAt].
  Future<List<QuoteEquipment>> listByQuoteId(String quoteId);

  Future<void> insert(QuoteEquipment item);

  Future<void> update(QuoteEquipment item);

  Future<void> delete(String id);
}
