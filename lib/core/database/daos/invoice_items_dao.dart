part of '../app_database.dart';

@DriftAccessor(tables: [InvoiceItems])
class InvoiceItemsDao extends DatabaseAccessor<AppDatabase>
    with _$InvoiceItemsDaoMixin {
  InvoiceItemsDao(super.db);

  Future<List<InvoiceItemRow>> getAll() {
    return select(invoiceItems).get();
  }

  Future<InvoiceItemRow?> getById(String id) {
    return (select(
      invoiceItems,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<List<InvoiceItemRow>> getByInvoiceId(String invoiceId) {
    return (select(
      invoiceItems,
    )..where((row) => row.invoiceId.equals(invoiceId)))
        .get();
  }

  Future<void> insertRow(InvoiceItemsCompanion row) {
    return into(invoiceItems).insert(row);
  }

  Future<bool> updateRow(InvoiceItemsCompanion row) {
    return update(invoiceItems).replace(row);
  }

  Future<bool> deleteById(String id) {
    return (delete(
      invoiceItems,
    )..where((row) => row.id.equals(id))).go().then((rows) => rows > 0);
  }

  Future<int> deleteByInvoiceId(String invoiceId) {
    return (delete(
      invoiceItems,
    )..where((row) => row.invoiceId.equals(invoiceId)))
        .go();
  }
}
