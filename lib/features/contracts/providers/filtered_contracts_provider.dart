import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/contract.dart';
import '../utils/contract_list_filter.dart';
import 'contract_filters_provider.dart';
import 'contract_provider.dart';

final filteredContractsProvider = Provider<AsyncValue<List<Contract>>>((ref) {
  final filters = ref.watch(contractFiltersProvider);
  return ref.watch(contractProvider).whenData(
        (contracts) => ContractListFilter.apply(contracts, filters),
      );
});
