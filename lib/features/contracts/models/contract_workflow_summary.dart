import 'contract.dart';
import 'contract_status.dart';

/// Read-only view of allowed contractual transitions for a [Contract].
///
/// Pure DTO — no I/O. Built by [ContractWorkflowService].
class ContractWorkflowSummary {
  const ContractWorkflowSummary({
    required this.contract,
    required this.allowedNextStatuses,
    required this.canGenerate,
    required this.canMarkSent,
    required this.canSign,
    required this.canCancel,
    required this.canExpire,
  });

  final Contract contract;
  final Set<ContractStatus> allowedNextStatuses;
  final bool canGenerate;
  final bool canMarkSent;
  final bool canSign;
  final bool canCancel;
  final bool canExpire;

  ContractStatus get currentStatus => contract.status;

  bool get isTerminal =>
      currentStatus == ContractStatus.signed ||
      currentStatus == ContractStatus.cancelled ||
      currentStatus == ContractStatus.expired;

  bool allows(ContractStatus status) => allowedNextStatuses.contains(status);
}
