import 'package:eventpro/features/billing/models/invoice.dart';

/// Domain contract for persisting [Invoice] records.
///
/// Storage-agnostic CRUD. Uniqueness of [Invoice.invoiceNumber] is enforced
/// in [InvoiceService] via [listAll] (case-insensitive scan) — adequate for
/// the local SQLite MVP without a dedicated findByNumber API.
abstract class InvoiceRepository {
  Future<List<Invoice>> listAll();

  Future<Invoice?> findById(String id);

  Future<List<Invoice>> listByQuoteId(String quoteId);

  Future<void> insert(Invoice invoice);

  Future<void> update(Invoice invoice);

  Future<void> delete(String id);
}
