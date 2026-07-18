import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/contract_filters.dart';
import '../models/contract_status.dart';

class ContractFiltersNotifier extends Notifier<ContractFilters> {
  @override
  ContractFilters build() => ContractFilters.empty;

  void setStatus(ContractStatus? status) {
    state = state.copyWith(status: status, clearStatus: status == null);
  }

  void setNumberQuery(String query) {
    state = state.copyWith(numberQuery: query);
  }

  void clear() {
    state = ContractFilters.empty;
  }
}

final contractFiltersProvider =
    NotifierProvider<ContractFiltersNotifier, ContractFilters>(
      ContractFiltersNotifier.new,
    );
