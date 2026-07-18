import '../models/contract.dart';
import '../models/contract_status.dart';
import 'contract_validation_result.dart';

abstract class ContractValidator {
  static const quoteIdRequiredError = 'Informe o orçamento do contrato';
  static const contractNumberRequiredError = 'Informe o número do contrato';
  static const statusRequiredError = 'Informe o status do contrato';

  static ContractValidationResult validateFields({
    String? quoteId,
    String? contractNumber,
    ContractStatus? status,
  }) {
    final errors = <String>[];

    if (quoteId == null || quoteId.trim().isEmpty) {
      errors.add(quoteIdRequiredError);
    }
    if (contractNumber == null || contractNumber.trim().isEmpty) {
      errors.add(contractNumberRequiredError);
    }
    if (status == null) {
      errors.add(statusRequiredError);
    }

    return ContractValidationResult(errors: List.unmodifiable(errors));
  }

  static ContractValidationResult validate(Contract contract) {
    return validateFields(
      quoteId: contract.quoteId,
      contractNumber: contract.contractNumber,
      status: contract.status,
    );
  }
}
