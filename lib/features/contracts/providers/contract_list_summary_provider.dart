import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/contract_list_summary.dart';
import 'contract_provider.dart';

final contractListSummaryProvider = Provider<AsyncValue<ContractListSummary>>((
  ref,
) {
  return ref.watch(contractProvider).whenData(ContractListSummary.fromContracts);
});
