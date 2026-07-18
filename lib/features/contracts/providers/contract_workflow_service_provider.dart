import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/contract_workflow_service.dart';
import 'contract_repository_provider.dart';
import 'contract_service_provider.dart';

final contractWorkflowServiceProvider = Provider<ContractWorkflowService>((ref) {
  return ContractWorkflowService(
    contractService: ref.watch(contractServiceProvider),
    contractRepository: ref.watch(contractRepositoryProvider),
  );
});
