part of '../app_database.dart';

@DriftAccessor(tables: [Invoices])
class InvoicesDao extends DatabaseAccessor<AppDatabase>
    with _$InvoicesDaoMixin {
  InvoicesDao(super.db);

  Future<List<InvoiceRow>> getAllOrdered() {
    return (select(invoices)..orderBy([
          (row) => OrderingTerm.desc(row.createdAt),
        ]))
        .get();
  }

  Future<InvoiceRow?> getById(String id) {
    return (select(
      invoices,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<List<InvoiceRow>> getByQuoteId(String quoteId) {
    return (select(invoices)
          ..where((row) => row.quoteId.equals(quoteId))
          ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]))
        .get();
  }

  Future<void> insertRow(InvoicesCompanion row) {
    return into(invoices).insert(row);
  }

  Future<bool> updateRow(InvoicesCompanion row) {
    return update(invoices).replace(row);
  }

  Future<bool> deleteById(String id) {
    return (delete(
      invoices,
    )..where((row) => row.id.equals(id))).go().then((rows) => rows > 0);
  }
}
