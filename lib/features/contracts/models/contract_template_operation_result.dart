import 'contract_template.dart';

enum ContractTemplateOperationStatus {
  success,
  validationFailed,
  duplicateName,
  notFound,
  deleted,
  blockedByUsage,
  failure,
}

class ContractTemplateOperationResult {
  const ContractTemplateOperationResult._({
    required this.status,
    this.template,
    this.errors = const [],
    this.blockingContractCount = 0,
  });

  factory ContractTemplateOperationResult.success(ContractTemplate template) {
    return ContractTemplateOperationResult._(
      status: ContractTemplateOperationStatus.success,
      template: template,
    );
  }

  factory ContractTemplateOperationResult.validationFailed(List<String> errors) {
    return ContractTemplateOperationResult._(
      status: ContractTemplateOperationStatus.validationFailed,
      errors: errors,
    );
  }

  factory ContractTemplateOperationResult.duplicateName() {
    return const ContractTemplateOperationResult._(
      status: ContractTemplateOperationStatus.duplicateName,
    );
  }

  factory ContractTemplateOperationResult.notFound() {
    return const ContractTemplateOperationResult._(
      status: ContractTemplateOperationStatus.notFound,
    );
  }

  factory ContractTemplateOperationResult.deleted() {
    return const ContractTemplateOperationResult._(
      status: ContractTemplateOperationStatus.deleted,
    );
  }

  factory ContractTemplateOperationResult.blockedByUsage({
    required int blockingContractCount,
  }) {
    return ContractTemplateOperationResult._(
      status: ContractTemplateOperationStatus.blockedByUsage,
      blockingContractCount: blockingContractCount,
    );
  }

  factory ContractTemplateOperationResult.failure() {
    return const ContractTemplateOperationResult._(
      status: ContractTemplateOperationStatus.failure,
    );
  }

  final ContractTemplateOperationStatus status;
  final ContractTemplate? template;
  final List<String> errors;
  final int blockingContractCount;

  bool get isSuccess => status == ContractTemplateOperationStatus.success;
  bool get isDeleted => status == ContractTemplateOperationStatus.deleted;
  bool get isBlockedByUsage =>
      status == ContractTemplateOperationStatus.blockedByUsage;
}
