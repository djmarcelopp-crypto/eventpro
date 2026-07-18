import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/agenda/data/mappers/agenda_block_mapper.dart';
import 'package:eventpro/features/agenda/data/repositories/agenda_block_repository.dart';
import 'package:eventpro/features/agenda/models/agenda_block.dart';

class DriftAgendaBlockRepository implements AgendaBlockRepository {
  DriftAgendaBlockRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<AgendaBlock>> listAll() async {
    final rows = await _database.agendaBlocksDao.getAllOrdered();
    return rows.map(AgendaBlockMapper.toDomain).toList(growable: false);
  }

  @override
  Future<AgendaBlock?> findById(String id) async {
    final row = await _database.agendaBlocksDao.getById(id);
    if (row == null) {
      return null;
    }
    return AgendaBlockMapper.toDomain(row);
  }

  @override
  Future<void> insert(AgendaBlock block) async {
    await _database.agendaBlocksDao.insertRow(
      AgendaBlockMapper.toInsertCompanion(block),
    );
  }

  @override
  Future<void> update(AgendaBlock block) async {
    final updated = await _database.agendaBlocksDao.updateRow(
      AgendaBlockMapper.toUpdateCompanion(block),
    );
    if (!updated) {
      throw StateError('AgendaBlock not found for update: ${block.id}');
    }
  }

  @override
  Future<void> delete(String id) async {
    final deleted = await _database.agendaBlocksDao.deleteById(id);
    if (!deleted) {
      throw StateError('AgendaBlock not found for delete: $id');
    }
  }
}
