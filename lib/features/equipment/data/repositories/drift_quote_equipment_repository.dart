import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/equipment/data/mappers/quote_equipment_mapper.dart';
import 'package:eventpro/features/equipment/data/repositories/quote_equipment_repository.dart';
import 'package:eventpro/features/equipment/models/quote_equipment.dart';

/// Drift-backed persistence for [QuoteEquipment]. No business rules.
class DriftQuoteEquipmentRepository implements QuoteEquipmentRepository {
  DriftQuoteEquipmentRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<QuoteEquipment>> listAll() async {
    final rows = await _database.quoteEquipmentDao.getAllOrdered();
    return rows.map(QuoteEquipmentMapper.toDomain).toList(growable: false);
  }

  @override
  Future<QuoteEquipment?> findById(String id) async {
    final row = await _database.quoteEquipmentDao.getById(id);
    if (row == null) {
      return null;
    }
    return QuoteEquipmentMapper.toDomain(row);
  }

  @override
  Future<List<QuoteEquipment>> listByQuoteId(String quoteId) async {
    final rows = await _database.quoteEquipmentDao.getAllByQuoteId(quoteId);
    return rows.map(QuoteEquipmentMapper.toDomain).toList(growable: false);
  }

  @override
  Future<void> insert(QuoteEquipment item) async {
    await _database.quoteEquipmentDao.insertRow(
      QuoteEquipmentMapper.toInsertCompanion(item),
    );
  }

  @override
  Future<void> update(QuoteEquipment item) async {
    final updated = await _database.quoteEquipmentDao.updateRow(
      QuoteEquipmentMapper.toUpdateCompanion(item),
    );
    if (!updated) {
      throw StateError('QuoteEquipment not found for update: ${item.id}');
    }
  }

  @override
  Future<void> delete(String id) async {
    final deleted = await _database.quoteEquipmentDao.deleteById(id);
    if (!deleted) {
      throw StateError('QuoteEquipment not found for delete: $id');
    }
  }
}
