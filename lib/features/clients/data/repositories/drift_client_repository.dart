import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/clients/data/mappers/client_mapper.dart';
import 'package:eventpro/features/clients/data/repositories/client_repository.dart';
import 'package:eventpro/features/clients/models/client.dart';

class DriftClientRepository implements ClientRepository {
  DriftClientRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<Client>> listAll() async {
    final rows = await _database.clientsDao.getAllOrdered();
    return rows.map(ClientMapper.toDomain).toList(growable: false);
  }

  @override
  Future<Client?> findById(String id) async {
    final row = await _database.clientsDao.getById(id);
    if (row == null) {
      return null;
    }
    return ClientMapper.toDomain(row);
  }

  @override
  Future<void> insert(Client client) async {
    await _database.clientsDao.insertRow(
      ClientMapper.toInsertCompanion(client),
    );
  }

  @override
  Future<void> update(Client client) async {
    final updated = await _database.clientsDao.updateRow(
      ClientMapper.toUpdateCompanion(client),
    );
    if (!updated) {
      throw StateError('Client not found for update: ${client.id}');
    }
  }

  @override
  Future<void> delete(String id) async {
    final deleted = await _database.clientsDao.deleteById(id);
    if (!deleted) {
      throw StateError('Client not found for delete: $id');
    }
  }
}
