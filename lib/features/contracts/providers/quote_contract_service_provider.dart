import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/quote_contract_service.dart';
import 'contract_service_provider.dart';
import 'contract_workflow_service_provider.dart';

final quoteContractServiceProvider = Provider<QuoteContractService>((ref) {
  return QuoteContractService(
    contractService: ref.watch(contractServiceProvider),
    workflowService: ref.watch(contractWorkflowServiceProvider),
  );
});
