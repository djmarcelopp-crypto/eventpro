import 'contract.dart';
import 'contract_status.dart';

/// Aggregated contracts for a single quote (no UI — service/DTO only).
class QuoteContractSummary {
  QuoteContractSummary({
    required this.quoteId,
    required List<Contract> contracts,
  }) : contracts = List.unmodifiable(contracts);

  final String quoteId;
  final List<Contract> contracts;

  int get contractCount => contracts.length;

  bool get hasContracts => contracts.isNotEmpty;

  /// Most recently created contract, if any.
  Contract? get latestContract =>
      contracts.isEmpty ? null : contracts.first;

  ContractStatus? get latestStatus => latestContract?.status;

  bool get hasSigned =>
      contracts.any((contract) => contract.status == ContractStatus.signed);

  bool get hasCancellable => contracts.any(
        (contract) =>
            contract.status != ContractStatus.signed &&
            contract.status != ContractStatus.cancelled &&
            contract.status != ContractStatus.expired,
      );
}
