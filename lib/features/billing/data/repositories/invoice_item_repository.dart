import 'package:eventpro/features/billing/models/invoice_item.dart';

/// Domain contract for persisting [InvoiceItem] records.
///
/// Storage-agnostic: no Drift implementation in this checkpoint.
abstract class InvoiceItemRepository {
  Future<List<InvoiceItem>> listAll();

  Future<InvoiceItem?> findById(String id);

  Future<List<InvoiceItem>> listByInvoiceId(String invoiceId);

  Future<void> insert(InvoiceItem item);

  Future<void> update(InvoiceItem item);

  Future<void> delete(String id);

  Future<void> deleteByInvoiceId(String invoiceId);
}
