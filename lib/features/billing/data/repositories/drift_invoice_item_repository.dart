import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/billing/data/mappers/invoice_item_mapper.dart';
import 'package:eventpro/features/billing/data/repositories/invoice_item_repository.dart';
import 'package:eventpro/features/billing/models/invoice_item.dart';

/// Drift-backed persistence for [InvoiceItem]. CRUD only.
class DriftInvoiceItemRepository implements InvoiceItemRepository {
  DriftInvoiceItemRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<InvoiceItem>> listAll() async {
    final rows = await _database.invoiceItemsDao.getAll();
    return rows.map(InvoiceItemMapper.toDomain).toList(growable: false);
  }

  @override
  Future<InvoiceItem?> findById(String id) async {
    final row = await _database.invoiceItemsDao.getById(id);
    if (row == null) return null;
    return InvoiceItemMapper.toDomain(row);
  }

  @override
  Future<List<InvoiceItem>> listByInvoiceId(String invoiceId) async {
    final rows = await _database.invoiceItemsDao.getByInvoiceId(invoiceId);
    return rows.map(InvoiceItemMapper.toDomain).toList(growable: false);
  }

  @override
  Future<void> insert(InvoiceItem item) async {
    await _database.invoiceItemsDao.insertRow(
      InvoiceItemMapper.toInsertCompanion(item),
    );
  }

  @override
  Future<void> update(InvoiceItem item) async {
    final updated = await _database.invoiceItemsDao.updateRow(
      InvoiceItemMapper.toUpdateCompanion(item),
    );
    if (!updated) {
      throw StateError('InvoiceItem not found for update: ${item.id}');
    }
  }

  @override
  Future<void> delete(String id) async {
    final deleted = await _database.invoiceItemsDao.deleteById(id);
    if (!deleted) {
      throw StateError('InvoiceItem not found for delete: $id');
    }
  }

  @override
  Future<void> deleteByInvoiceId(String invoiceId) async {
    await _database.invoiceItemsDao.deleteByInvoiceId(invoiceId);
  }
}
