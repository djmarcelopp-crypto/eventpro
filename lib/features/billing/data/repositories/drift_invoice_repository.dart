import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/billing/data/mappers/invoice_mapper.dart';
import 'package:eventpro/features/billing/data/repositories/invoice_repository.dart';
import 'package:eventpro/features/billing/models/invoice.dart';

/// Drift-backed persistence for [Invoice]. CRUD only.
class DriftInvoiceRepository implements InvoiceRepository {
  DriftInvoiceRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<Invoice>> listAll() async {
    final rows = await _database.invoicesDao.getAllOrdered();
    return rows.map(InvoiceMapper.toDomain).toList(growable: false);
  }

  @override
  Future<Invoice?> findById(String id) async {
    final row = await _database.invoicesDao.getById(id);
    if (row == null) return null;
    return InvoiceMapper.toDomain(row);
  }

  @override
  Future<List<Invoice>> listByQuoteId(String quoteId) async {
    final rows = await _database.invoicesDao.getByQuoteId(quoteId);
    return rows.map(InvoiceMapper.toDomain).toList(growable: false);
  }

  @override
  Future<void> insert(Invoice invoice) async {
    await _database.invoicesDao.insertRow(
      InvoiceMapper.toInsertCompanion(invoice),
    );
  }

  @override
  Future<void> update(Invoice invoice) async {
    final updated = await _database.invoicesDao.updateRow(
      InvoiceMapper.toUpdateCompanion(invoice),
    );
    if (!updated) {
      throw StateError('Invoice not found for update: ${invoice.id}');
    }
  }

  @override
  Future<void> delete(String id) async {
    final deleted = await _database.invoicesDao.deleteById(id);
    if (!deleted) {
      throw StateError('Invoice not found for delete: $id');
    }
  }
}
