part of '../app_database.dart';

@DriftAccessor(tables: [QuoteVehicles])
class QuoteVehiclesDao extends DatabaseAccessor<AppDatabase>
    with _$QuoteVehiclesDaoMixin {
  QuoteVehiclesDao(super.db);

  Future<List<QuoteVehicleRow>> getAllOrdered() {
    return (select(quoteVehicles)..orderBy([
          (row) => OrderingTerm.asc(row.createdAt),
        ]))
        .get();
  }

  Future<QuoteVehicleRow?> getById(String id) {
    return (select(
      quoteVehicles,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<List<QuoteVehicleRow>> getByQuoteId(String quoteId) {
    return (select(quoteVehicles)
          ..where((row) => row.quoteId.equals(quoteId))
          ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
        .get();
  }

  Future<void> insertRow(QuoteVehiclesCompanion row) {
    return into(quoteVehicles).insert(row);
  }

  Future<bool> updateRow(QuoteVehiclesCompanion row) {
    return update(quoteVehicles).replace(row);
  }

  Future<bool> deleteById(String id) {
    return (delete(
      quoteVehicles,
    )..where((row) => row.id.equals(id))).go().then((rows) => rows > 0);
  }
}
