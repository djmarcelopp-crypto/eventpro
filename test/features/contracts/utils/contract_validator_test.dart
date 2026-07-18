import 'package:eventpro/features/contracts/models/contract.dart';
import 'package:eventpro/features/contracts/models/contract_status.dart';
import 'package:eventpro/features/contracts/utils/contract_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContractValidator', () {
    final now = DateTime(2026, 7, 17);

    test('rejects missing quoteId, number and status', () {
      final result = ContractValidator.validateFields(
        quoteId: '',
        contractNumber: ' ',
      );
      expect(result.isValid, isFalse);
      expect(
        result.errors,
        [
          ContractValidator.quoteIdRequiredError,
          ContractValidator.contractNumberRequiredError,
          ContractValidator.statusRequiredError,
        ],
      );
    });

    test('accepts valid contract', () {
      final result = ContractValidator.validate(
        Contract(
          id: 'ctr-1',
          quoteId: 'quote-1',
          contractNumber: 'CTR-1',
          status: ContractStatus.draft,
          createdAt: now,
          updatedAt: now,
        ),
      );
      expect(result.isValid, isTrue);
    });
  });
}
