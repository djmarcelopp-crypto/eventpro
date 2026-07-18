import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/contracts/data/mappers/contract_mapper.dart';
import 'package:eventpro/features/contracts/data/repositories/contract_repository.dart';
import 'package:eventpro/features/contracts/models/contract.dart';

/// Drift-backed persistence for [Contract]. CRUD only.
class DriftContractRepository implements ContractRepository {
  DriftContractRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<Contract>> listAll() async {
    final rows = await _database.contractsDao.getAllOrdered();
    return rows.map(ContractMapper.toDomain).toList(growable: false);
  }

  @override
  Future<Contract?> findById(String id) async {
    final row = await _database.contractsDao.getById(id);
    if (row == null) return null;
    return ContractMapper.toDomain(row);
  }

  @override
  Future<List<Contract>> listByQuoteId(String quoteId) async {
    final rows = await _database.contractsDao.getByQuoteId(quoteId);
    return rows.map(ContractMapper.toDomain).toList(growable: false);
  }

  @override
  Future<void> insert(Contract contract) async {
    await _database.contractsDao.insertRow(
      ContractMapper.toInsertCompanion(contract),
    );
  }

  @override
  Future<void> update(Contract contract) async {
    final updated = await _database.contractsDao.updateRow(
      ContractMapper.toUpdateCompanion(contract),
    );
    if (!updated) {
      throw StateError('Contract not found for update: ${contract.id}');
    }
  }

  @override
  Future<void> delete(String id) async {
    final deleted = await _database.contractsDao.deleteById(id);
    if (!deleted) {
      throw StateError('Contract not found for delete: $id');
    }
  }
}
