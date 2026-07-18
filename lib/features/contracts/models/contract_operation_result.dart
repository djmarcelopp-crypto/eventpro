import 'contract.dart';

enum ContractOperationStatus {
  success,
  validationFailed,
  quoteNotFound,
  templateNotFound,
  templateInactive,
  duplicateNumber,
  notFound,
  invalidTransition,
  cannotSignCancelled,
  cannotCancelSigned,
  deleted,
  failure,
}

class ContractOperationResult {
  const ContractOperationResult._({
    required this.status,
    this.contract,
    this.errors = const [],
  });

  factory ContractOperationResult.success(Contract contract) {
    return ContractOperationResult._(
      status: ContractOperationStatus.success,
      contract: contract,
    );
  }

  factory ContractOperationResult.validationFailed(List<String> errors) {
    return ContractOperationResult._(
      status: ContractOperationStatus.validationFailed,
      errors: errors,
    );
  }

  factory ContractOperationResult.quoteNotFound() {
    return const ContractOperationResult._(
      status: ContractOperationStatus.quoteNotFound,
    );
  }

  factory ContractOperationResult.templateNotFound() {
    return const ContractOperationResult._(
      status: ContractOperationStatus.templateNotFound,
    );
  }

  factory ContractOperationResult.templateInactive() {
    return const ContractOperationResult._(
      status: ContractOperationStatus.templateInactive,
    );
  }

  factory ContractOperationResult.duplicateNumber() {
    return const ContractOperationResult._(
      status: ContractOperationStatus.duplicateNumber,
    );
  }

  factory ContractOperationResult.notFound() {
    return const ContractOperationResult._(
      status: ContractOperationStatus.notFound,
    );
  }

  factory ContractOperationResult.invalidTransition() {
    return const ContractOperationResult._(
      status: ContractOperationStatus.invalidTransition,
    );
  }

  factory ContractOperationResult.cannotSignCancelled() {
    return const ContractOperationResult._(
      status: ContractOperationStatus.cannotSignCancelled,
    );
  }

  factory ContractOperationResult.cannotCancelSigned() {
    return const ContractOperationResult._(
      status: ContractOperationStatus.cannotCancelSigned,
    );
  }

  factory ContractOperationResult.deleted() {
    return const ContractOperationResult._(
      status: ContractOperationStatus.deleted,
    );
  }

  factory ContractOperationResult.failure() {
    return const ContractOperationResult._(
      status: ContractOperationStatus.failure,
    );
  }

  final ContractOperationStatus status;
  final Contract? contract;
  final List<String> errors;

  bool get isSuccess => status == ContractOperationStatus.success;
  bool get isDeleted => status == ContractOperationStatus.deleted;
}
