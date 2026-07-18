import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/contract_repository.dart';
import '../models/contract.dart';
import '../models/contract_operation_result.dart';
import '../utils/contract_service.dart';
import '../utils/contract_workflow_service.dart';
import 'contract_repository_provider.dart';
import 'contract_service_provider.dart';
import 'contract_workflow_service_provider.dart';

class ContractNotifier extends AsyncNotifier<List<Contract>> {
  ContractRepository get _repository => ref.read(contractRepositoryProvider);
  ContractService get _service => ref.read(contractServiceProvider);
  ContractWorkflowService get _workflow =>
      ref.read(contractWorkflowServiceProvider);

  @override
  Future<List<Contract>> build() async => _repository.listAll();

  Contract? findById(String id) {
    final current = state.value;
    if (current == null) return null;
    for (final contract in current) {
      if (contract.id == id) return contract;
    }
    return null;
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.listAll);
  }

  Future<ContractOperationResult> generateForQuote({
    required String quoteId,
    String? templateId,
    String notes = '',
  }) async {
    final created = await _service.create(
      quoteId: quoteId,
      templateId: templateId,
      notes: notes,
    );
    if (!created.isSuccess || created.contract == null) {
      return created;
    }
    final generated = await _workflow.generate(created.contract!.id);
    if (generated.isSuccess && generated.contract != null) {
      await _upsert(generated.contract!);
    }
    return generated;
  }

  Future<ContractOperationResult> cancelContract(String id) async {
    final result = await _workflow.cancel(id);
    if (result.isSuccess && result.contract != null) {
      await _upsert(result.contract!);
    }
    return result;
  }

  Future<ContractOperationResult> markSent(String id) async {
    final result = await _workflow.markSent(id);
    if (result.isSuccess && result.contract != null) {
      await _upsert(result.contract!);
    }
    return result;
  }

  Future<void> _upsert(Contract contract) async {
    final current = state.value ?? const <Contract>[];
    final exists = current.any((item) => item.id == contract.id);
    final next = exists
        ? [
            for (final item in current)
              if (item.id == contract.id) contract else item,
          ]
        : [contract, ...current];
    next.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = AsyncValue.data(List.unmodifiable(next));
  }
}

final contractProvider =
    AsyncNotifierProvider<ContractNotifier, List<Contract>>(
      ContractNotifier.new,
    );
