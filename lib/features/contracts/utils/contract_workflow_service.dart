import '../data/repositories/contract_repository.dart';
import '../models/contract.dart';
import '../models/contract_operation_result.dart';
import '../models/contract_status.dart';
import '../models/contract_workflow_summary.dart';
import 'contract_service.dart';

/// Internal contractual workflow (status machine).
///
/// **Single source of truth** for the complete [ContractStatus] transition
/// matrix (`forwardTransitions`, cancel/expire sets, regression checks).
///
/// No PDF generation, digital signature providers, or external integrations.
/// Persistence of authorized transitions is delegated to [ContractService]
/// (`apply*`) — which must not re-encode this matrix.
class ContractWorkflowService {
  ContractWorkflowService({
    required ContractService contractService,
    required ContractRepository contractRepository,
  })  : _contractService = contractService,
        _contractRepository = contractRepository;

  final ContractService _contractService;
  final ContractRepository _contractRepository;

  /// Happy-path forward edges only (no cancel / expire).
  static const Map<ContractStatus, Set<ContractStatus>> forwardTransitions = {
    ContractStatus.draft: {ContractStatus.generated},
    ContractStatus.generated: {ContractStatus.sent},
    ContractStatus.sent: {ContractStatus.signed},
    ContractStatus.signed: {},
    ContractStatus.cancelled: {},
    ContractStatus.expired: {},
  };

  static const Set<ContractStatus> cancellableStatuses = {
    ContractStatus.draft,
    ContractStatus.generated,
    ContractStatus.sent,
  };

  static const Set<ContractStatus> expirableStatuses = {
    ContractStatus.generated,
    ContractStatus.sent,
  };

  bool canTransition(ContractStatus from, ContractStatus to) {
    if (from == to) return false;
    if (to == ContractStatus.cancelled) {
      return cancellableStatuses.contains(from);
    }
    if (to == ContractStatus.expired) {
      return expirableStatuses.contains(from);
    }
    if (from == ContractStatus.cancelled ||
        from == ContractStatus.signed ||
        from == ContractStatus.expired) {
      return false;
    }
    if (to == ContractStatus.signed && from == ContractStatus.cancelled) {
      return false;
    }
    return forwardTransitions[from]?.contains(to) ?? false;
  }

  bool wouldRegress(ContractStatus from, ContractStatus to) {
    const order = <ContractStatus, int>{
      ContractStatus.draft: 0,
      ContractStatus.generated: 1,
      ContractStatus.sent: 2,
      ContractStatus.signed: 3,
    };
    final fromOrder = order[from];
    final toOrder = order[to];
    if (fromOrder == null || toOrder == null) return false;
    return toOrder < fromOrder;
  }

  ContractWorkflowSummary summarize(Contract contract) {
    final allowed = <ContractStatus>{
      for (final candidate in ContractStatus.values)
        if (canTransition(contract.status, candidate)) candidate,
    };
    return ContractWorkflowSummary(
      contract: contract,
      allowedNextStatuses: Set.unmodifiable(allowed),
      canGenerate: allowed.contains(ContractStatus.generated),
      canMarkSent: allowed.contains(ContractStatus.sent),
      canSign: allowed.contains(ContractStatus.signed),
      canCancel: allowed.contains(ContractStatus.cancelled),
      canExpire: allowed.contains(ContractStatus.expired),
    );
  }

  Future<ContractWorkflowSummary?> summarizeById(String id) async {
    final contract = await _contractRepository.findById(id);
    if (contract == null) return null;
    return summarize(contract);
  }

  Future<ContractOperationResult> advance(String id, ContractStatus to) async {
    final existing = await _contractRepository.findById(id);
    if (existing == null) {
      return ContractOperationResult.notFound();
    }

    if (wouldRegress(existing.status, to)) {
      return ContractOperationResult.invalidTransition();
    }

    if (!canTransition(existing.status, to)) {
      if (to == ContractStatus.signed &&
          existing.status == ContractStatus.cancelled) {
        return ContractOperationResult.cannotSignCancelled();
      }
      if (to == ContractStatus.cancelled &&
          existing.status == ContractStatus.signed) {
        return ContractOperationResult.cannotCancelSigned();
      }
      if (to == ContractStatus.expired &&
          existing.status == ContractStatus.signed) {
        return ContractOperationResult.invalidTransition();
      }
      return ContractOperationResult.invalidTransition();
    }

    return switch (to) {
      ContractStatus.generated => _contractService.applyGenerated(id),
      ContractStatus.sent => _contractService.applySent(id),
      ContractStatus.signed => _contractService.applySigned(id),
      ContractStatus.cancelled => _contractService.applyCancelled(id),
      ContractStatus.expired => _contractService.applyExpired(id),
      ContractStatus.draft => ContractOperationResult.invalidTransition(),
    };
  }

  Future<ContractOperationResult> generate(String id) =>
      advance(id, ContractStatus.generated);

  Future<ContractOperationResult> markSent(String id) =>
      advance(id, ContractStatus.sent);

  Future<ContractOperationResult> markSigned(String id) =>
      advance(id, ContractStatus.signed);

  Future<ContractOperationResult> cancel(String id) =>
      advance(id, ContractStatus.cancelled);

  Future<ContractOperationResult> markExpired(String id) =>
      advance(id, ContractStatus.expired);
}
