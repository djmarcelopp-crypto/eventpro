import 'package:eventpro/features/contracts/models/contract_list_summary.dart';
import 'package:eventpro/features/contracts/models/contract_status.dart';
import 'package:flutter_test/flutter_test.dart';

import '../contracts_test_helpers.dart';

void main() {
  test('aggregates contract statuses for dashboard cards', () {
    final summary = ContractListSummary.fromContracts([
      buildTestContract(id: '1', status: ContractStatus.draft),
      buildTestContract(id: '2', status: ContractStatus.sent),
      buildTestContract(id: '3', status: ContractStatus.signed),
      buildTestContract(id: '4', status: ContractStatus.expired),
      buildTestContract(id: '5', status: ContractStatus.generated),
    ]);

    expect(summary.total, 5);
    expect(summary.draft, 1);
    expect(summary.sent, 1);
    expect(summary.signed, 1);
    expect(summary.expired, 1);
    expect(summary.generated, 1);
  });
}
