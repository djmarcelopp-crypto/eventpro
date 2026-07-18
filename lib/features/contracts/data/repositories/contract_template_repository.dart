import 'package:eventpro/features/contracts/models/contract_template.dart';

/// Domain contract for persisting [ContractTemplate] records.
///
/// Storage-agnostic: no Drift implementation in this checkpoint.
abstract class ContractTemplateRepository {
  Future<List<ContractTemplate>> listAll();

  Future<ContractTemplate?> findById(String id);

  Future<void> insert(ContractTemplate template);

  Future<void> update(ContractTemplate template);

  Future<void> delete(String id);
}
