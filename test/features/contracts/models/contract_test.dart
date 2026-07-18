import 'package:eventpro/features/contracts/models/contract.dart';
import 'package:eventpro/features/contracts/models/contract_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Contract', () {
    final createdAt = DateTime(2026, 7, 17, 10);
    final updatedAt = DateTime(2026, 7, 17, 11);

    Contract buildContract({
      String id = 'ctr-1',
      String quoteId = 'quote-1',
      String? templateId = 'tpl-1',
      String contractNumber = 'CTR-2026-0001',
      ContractStatus status = ContractStatus.draft,
      String notes = 'Observação',
    }) {
      return Contract(
        id: id,
        quoteId: quoteId,
        templateId: templateId,
        contractNumber: contractNumber,
        status: status,
        notes: notes,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    }

    test('notes defaults to empty and optional timestamps to null', () {
      final contract = Contract(
        id: 'ctr-1',
        quoteId: 'quote-1',
        contractNumber: 'CTR-1',
        status: ContractStatus.draft,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(contract.notes, '');
      expect(contract.templateId, isNull);
      expect(contract.generatedAt, isNull);
      expect(contract.filePath, isNull);
      expect(contract.isDraft, isTrue);
    });

    test('equality compares all fields', () {
      final a = buildContract();
      final b = buildContract();
      final different = buildContract(status: ContractStatus.signed);

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(equals(different)));
    });

    test('copyWith preserves and can clear nullable fields', () {
      final original = buildContract();
      final copy = original.copyWith(
        status: ContractStatus.generated,
        generatedAt: DateTime(2026, 7, 18),
        clearTemplateId: true,
      );

      expect(copy.status, ContractStatus.generated);
      expect(copy.generatedAt, DateTime(2026, 7, 18));
      expect(copy.templateId, isNull);
      expect(copy.quoteId, original.quoteId);
      expect(copy.createdAt, original.createdAt);
    });

    test('status helpers reflect ContractStatus', () {
      expect(buildContract(status: ContractStatus.signed).isSigned, isTrue);
      expect(buildContract(status: ContractStatus.cancelled).isCancelled, isTrue);
      expect(buildContract(status: ContractStatus.expired).isExpired, isTrue);
    });
  });
}
