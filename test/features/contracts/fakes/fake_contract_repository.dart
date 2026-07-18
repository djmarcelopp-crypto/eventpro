import 'package:eventpro/features/contracts/data/repositories/contract_repository.dart';
import 'package:eventpro/features/contracts/models/contract.dart';

class FakeContractRepository implements ContractRepository {
  FakeContractRepository({List<Contract>? initialContracts})
      : _contracts = List<Contract>.from(initialContracts ?? const []);

  final List<Contract> _contracts;
  var shouldFailOnNextOperation = false;

  @override
  Future<List<Contract>> listAll() async {
    return List<Contract>.unmodifiable(_contracts);
  }

  @override
  Future<Contract?> findById(String id) async {
    for (final contract in _contracts) {
      if (contract.id == id) return contract;
    }
    return null;
  }

  @override
  Future<List<Contract>> listByQuoteId(String quoteId) async {
    final matches =
        _contracts.where((contract) => contract.quoteId == quoteId).toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return List.unmodifiable(matches);
  }

  @override
  Future<void> insert(Contract contract) async {
    _failIfRequested();
    _contracts.add(contract);
  }

  @override
  Future<void> update(Contract contract) async {
    _failIfRequested();
    final index =
        _contracts.indexWhere((current) => current.id == contract.id);
    if (index == -1) {
      throw StateError('Contract not found for update: ${contract.id}');
    }
    _contracts[index] = contract;
  }

  @override
  Future<void> delete(String id) async {
    _failIfRequested();
    final lengthBefore = _contracts.length;
    _contracts.removeWhere((contract) => contract.id == id);
    if (_contracts.length == lengthBefore) {
      throw StateError('Contract not found for delete: $id');
    }
  }

  void _failIfRequested() {
    if (!shouldFailOnNextOperation) return;
    shouldFailOnNextOperation = false;
    throw StateError('Simulated repository failure');
  }
}
