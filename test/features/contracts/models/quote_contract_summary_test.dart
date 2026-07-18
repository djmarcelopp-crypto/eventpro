import 'package:eventpro/features/contracts/models/contract.dart';
import 'package:eventpro/features/contracts/models/contract_status.dart';
import 'package:eventpro/features/contracts/models/quote_contract_summary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuoteContractSummary', () {
    final now = DateTime(2026, 7, 17);

    Contract build({
      required String id,
      ContractStatus status = ContractStatus.draft,
    }) {
      return Contract(
        id: id,
        quoteId: 'quote-1',
        contractNumber: 'CTR-$id',
        status: status,
        createdAt: now,
        updatedAt: now,
      );
    }

    test('aggregates latest status and signed/cancellable flags', () {
      final summary = QuoteContractSummary(
        quoteId: 'quote-1',
        contracts: [
          build(id: 'newer', status: ContractStatus.sent),
          build(id: 'older', status: ContractStatus.signed),
        ],
      );

      expect(summary.contractCount, 2);
      expect(summary.latestContract?.id, 'newer');
      expect(summary.latestStatus, ContractStatus.sent);
      expect(summary.hasSigned, isTrue);
      expect(summary.hasCancellable, isTrue);
    });
  });
}
