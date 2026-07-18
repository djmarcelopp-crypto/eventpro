import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/logistics/data/mappers/quote_vehicle_mapper.dart';
import 'package:eventpro/features/logistics/data/repositories/quote_vehicle_repository.dart';
import 'package:eventpro/features/logistics/models/quote_vehicle.dart';

class DriftQuoteVehicleRepository implements QuoteVehicleRepository {
  DriftQuoteVehicleRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<QuoteVehicle>> listAll() async {
    final rows = await _database.quoteVehiclesDao.getAllOrdered();
    return rows.map(QuoteVehicleMapper.toDomain).toList(growable: false);
  }

  @override
  Future<QuoteVehicle?> findById(String id) async {
    final row = await _database.quoteVehiclesDao.getById(id);
    if (row == null) {
      return null;
    }
    return QuoteVehicleMapper.toDomain(row);
  }

  @override
  Future<List<QuoteVehicle>> listByQuoteId(String quoteId) async {
    final rows = await _database.quoteVehiclesDao.getByQuoteId(quoteId);
    return rows.map(QuoteVehicleMapper.toDomain).toList(growable: false);
  }

  @override
  Future<void> insert(QuoteVehicle item) async {
    await _database.quoteVehiclesDao.insertRow(
      QuoteVehicleMapper.toInsertCompanion(item),
    );
  }

  @override
  Future<void> update(QuoteVehicle item) async {
    final updated = await _database.quoteVehiclesDao.updateRow(
      QuoteVehicleMapper.toUpdateCompanion(item),
    );
    if (!updated) {
      throw StateError('QuoteVehicle not found for update: ${item.id}');
    }
  }

  @override
  Future<void> delete(String id) async {
    final deleted = await _database.quoteVehiclesDao.deleteById(id);
    if (!deleted) {
      throw StateError('QuoteVehicle not found for delete: $id');
    }
  }
}
