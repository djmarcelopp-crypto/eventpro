import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/contracts/data/mappers/contract_template_mapper.dart';
import 'package:eventpro/features/contracts/data/repositories/contract_template_repository.dart';
import 'package:eventpro/features/contracts/models/contract_template.dart';

/// Drift-backed persistence for [ContractTemplate]. CRUD only.
class DriftContractTemplateRepository implements ContractTemplateRepository {
  DriftContractTemplateRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<ContractTemplate>> listAll() async {
    final rows = await _database.contractTemplatesDao.getAllOrdered();
    return rows.map(ContractTemplateMapper.toDomain).toList(growable: false);
  }

  @override
  Future<ContractTemplate?> findById(String id) async {
    final row = await _database.contractTemplatesDao.getById(id);
    if (row == null) return null;
    return ContractTemplateMapper.toDomain(row);
  }

  @override
  Future<void> insert(ContractTemplate template) async {
    await _database.contractTemplatesDao.insertRow(
      ContractTemplateMapper.toInsertCompanion(template),
    );
  }

  @override
  Future<void> update(ContractTemplate template) async {
    final updated = await _database.contractTemplatesDao.updateRow(
      ContractTemplateMapper.toUpdateCompanion(template),
    );
    if (!updated) {
      throw StateError('ContractTemplate not found for update: ${template.id}');
    }
  }

  @override
  Future<void> delete(String id) async {
    final deleted = await _database.contractTemplatesDao.deleteById(id);
    if (!deleted) {
      throw StateError('ContractTemplate not found for delete: $id');
    }
  }
}
