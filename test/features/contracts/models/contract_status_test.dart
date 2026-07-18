import 'package:eventpro/features/contracts/models/contract_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContractStatus', () {
    test('contains all lifecycle values', () {
      expect(ContractStatus.values, [
        ContractStatus.draft,
        ContractStatus.generated,
        ContractStatus.sent,
        ContractStatus.signed,
        ContractStatus.cancelled,
        ContractStatus.expired,
      ]);
    });

    test('labels are defined for every value', () {
      for (final status in ContractStatus.values) {
        expect(status.label, isNotEmpty);
      }
    });
  });
}
