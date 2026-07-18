import 'package:eventpro/features/contracts/models/contract.dart';

/// Domain contract for persisting [Contract] records.
///
/// Storage-agnostic: no Drift implementation in this checkpoint.
abstract class ContractRepository {
  Future<List<Contract>> listAll();

  Future<Contract?> findById(String id);

  Future<List<Contract>> listByQuoteId(String quoteId);

  Future<void> insert(Contract contract);

  Future<void> update(Contract contract);

  Future<void> delete(String id);
}
