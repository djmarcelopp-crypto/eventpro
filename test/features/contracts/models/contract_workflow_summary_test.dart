import 'package:eventpro/features/contracts/models/contract_status.dart';
import 'package:eventpro/features/contracts/models/contract_workflow_summary.dart';
import 'package:flutter_test/flutter_test.dart';

import '../contracts_test_helpers.dart';

void main() {
  test('exposes helpers for allowed and terminal states', () {
    final contract = buildTestContract(status: ContractStatus.sent);
    final summary = ContractWorkflowSummary(
      contract: contract,
      allowedNextStatuses: {
        ContractStatus.signed,
        ContractStatus.cancelled,
        ContractStatus.expired,
      },
      canGenerate: false,
      canMarkSent: false,
      canSign: true,
      canCancel: true,
      canExpire: true,
    );

    expect(summary.currentStatus, ContractStatus.sent);
    expect(summary.allows(ContractStatus.signed), isTrue);
    expect(summary.allows(ContractStatus.draft), isFalse);
    expect(summary.isTerminal, isFalse);
  });

  test('terminal when signed/cancelled/expired', () {
    for (final status in [
      ContractStatus.signed,
      ContractStatus.cancelled,
      ContractStatus.expired,
    ]) {
      final summary = ContractWorkflowSummary(
        contract: buildTestContract(status: status),
        allowedNextStatuses: const {},
        canGenerate: false,
        canMarkSent: false,
        canSign: false,
        canCancel: false,
        canExpire: false,
      );
      expect(summary.isTerminal, isTrue);
    }
  });
}
