import 'package:eventpro/features/contracts/models/contract_signature_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContractSignatureStatus', () {
    test('contains all signature values', () {
      expect(ContractSignatureStatus.values, [
        ContractSignatureStatus.pending,
        ContractSignatureStatus.signed,
        ContractSignatureStatus.rejected,
      ]);
    });

    test('labels are defined for every value', () {
      for (final status in ContractSignatureStatus.values) {
        expect(status.label, isNotEmpty);
      }
    });
  });
}
