import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/contract_workflow_summary.dart';
import 'contract_provider.dart';
import 'contract_workflow_service_provider.dart';

/// Workflow summary for a contract id, derived from [contractProvider] state.
final contractWorkflowSummaryProvider =
    Provider.family<AsyncValue<ContractWorkflowSummary?>, String>((ref, id) {
  final workflow = ref.watch(contractWorkflowServiceProvider);
  return ref.watch(contractProvider).whenData((contracts) {
    for (final contract in contracts) {
      if (contract.id == id) {
        return workflow.summarize(contract);
      }
    }
    return null;
  });
});
