part of '../app_database.dart';

@DriftAccessor(tables: [QuoteEquipmentItems])
class QuoteEquipmentDao extends DatabaseAccessor<AppDatabase>
    with _$QuoteEquipmentDaoMixin {
  QuoteEquipmentDao(super.db);

  Future<List<QuoteEquipmentRow>> getAllOrdered() {
    return (select(quoteEquipmentItems)..orderBy([
          (row) => OrderingTerm.asc(row.createdAt),
        ]))
        .get();
  }

  Future<QuoteEquipmentRow?> getById(String id) {
    return (select(
      quoteEquipmentItems,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<List<QuoteEquipmentRow>> getAllByQuoteId(String quoteId) {
    return (select(quoteEquipmentItems)
          ..where((row) => row.quoteId.equals(quoteId))
          ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
        .get();
  }

  Future<void> insertRow(QuoteEquipmentItemsCompanion row) {
    return into(quoteEquipmentItems).insert(row);
  }

  Future<bool> updateRow(QuoteEquipmentItemsCompanion row) {
    return update(quoteEquipmentItems).replace(row);
  }

  Future<bool> deleteById(String id) {
    return (delete(
      quoteEquipmentItems,
    )..where((row) => row.id.equals(id))).go().then((rows) => rows > 0);
  }
}
