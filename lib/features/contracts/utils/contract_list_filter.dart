import '../models/contract.dart';
import '../models/contract_filters.dart';

abstract class ContractListFilter {
  static List<Contract> apply(
    List<Contract> contracts,
    ContractFilters filters,
  ) {
    final query = filters.numberQuery.trim().toLowerCase();
    return [
      for (final contract in contracts)
        if ((filters.status == null || contract.status == filters.status) &&
            (query.isEmpty ||
                contract.contractNumber.toLowerCase().contains(query) ||
                contract.quoteId.toLowerCase().contains(query)))
          contract,
    ];
  }
}
