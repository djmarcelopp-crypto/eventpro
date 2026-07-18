import 'package:eventpro/features/equipment/models/equipment.dart';
import 'package:eventpro/features/equipment/models/equipment_status.dart';
import 'package:eventpro/features/equipment/models/quote_equipment_delete_result.dart';
import 'package:eventpro/features/equipment/models/quote_equipment_write_result.dart';
import 'package:eventpro/features/equipment/utils/quote_equipment_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../quotes/fakes/fake_quote_repository.dart';
import '../../quotes/quotes_test_helpers.dart';
import '../fakes/fake_equipment_repository.dart';
import '../fakes/fake_quote_equipment_repository.dart';

void main() {
  group('QuoteEquipmentService', () {
    late FakeQuoteEquipmentRepository linkRepository;
    late FakeEquipmentRepository equipmentRepository;
    late FakeQuoteRepository quoteRepository;
    final fixedNow = DateTime(2030, 1, 1, 12);
    final earlier = DateTime(2020, 1, 1);

    QuoteEquipmentService buildService({DateTime? now}) {
      return QuoteEquipmentService(
        quoteEquipmentRepository: linkRepository,
        equipmentRepository: equipmentRepository,
        quoteRepository: quoteRepository,
        clock: () => now ?? fixedNow,
      );
    }

    setUp(() async {
      linkRepository = FakeQuoteEquipmentRepository();
      equipmentRepository = FakeEquipmentRepository();
      quoteRepository = FakeQuoteRepository(
        initialQuotes: [buildMinimalQuoteAddDraft(id: 'quote-1')],
      );
      await equipmentRepository.insert(
        Equipment(
          id: 'eq-1',
          name: 'Caixa',
          categoryId: 'cat-1',
          totalQuantity: 10,
          status: EquipmentStatus.available,
          createdAt: earlier,
          updatedAt: earlier,
        ),
      );
      await equipmentRepository.insert(
        Equipment(
          id: 'eq-2',
          name: 'Microfone',
          categoryId: 'cat-1',
          totalQuantity: 5,
          status: EquipmentStatus.available,
          createdAt: earlier,
          updatedAt: earlier,
        ),
      );
    });

    test('adds equipment to quote without changing EquipmentStatus', () async {
      final before = await equipmentRepository.findById('eq-1');
      final service = buildService();

      final result = await service.add(
        quoteId: 'quote-1',
        equipmentId: 'eq-1',
        quantity: 3,
      );

      expect(result.isSuccess, isTrue);
      expect(result.item!.quoteId, 'quote-1');
      expect(result.item!.equipmentId, 'eq-1');
      expect(result.item!.quantity, 3);
      expect(result.item!.createdAt, fixedNow);
      expect(result.item!.updatedAt, fixedNow);

      final after = await equipmentRepository.findById('eq-1');
      expect(after!.status, before!.status);
      expect(after.totalQuantity, before.totalQuantity);
    });

    test('allows multiple equipment lines on the same quote', () async {
      final service = buildService();
      await service.add(quoteId: 'quote-1', equipmentId: 'eq-1', quantity: 2);
      await service.add(quoteId: 'quote-1', equipmentId: 'eq-2', quantity: 1);

      final listed = await service.listForQuote('quote-1');
      expect(listed, hasLength(2));
    });

    test('rejects quantity <= 0', () async {
      final result = await buildService().add(
        quoteId: 'quote-1',
        equipmentId: 'eq-1',
        quantity: 0,
      );

      expect(result.status, QuoteEquipmentWriteStatus.validationFailed);
      expect(await linkRepository.listAll(), isEmpty);
    });

    test('rejects unknown quote', () async {
      final result = await buildService().add(
        quoteId: 'missing-quote',
        equipmentId: 'eq-1',
        quantity: 1,
      );

      expect(result.status, QuoteEquipmentWriteStatus.quoteNotFound);
    });

    test('rejects unknown equipment', () async {
      final result = await buildService().add(
        quoteId: 'quote-1',
        equipmentId: 'missing-eq',
        quantity: 1,
      );

      expect(result.status, QuoteEquipmentWriteStatus.equipmentNotFound);
    });

    test('updates quantity preserving createdAt', () async {
      final created = (await buildService(
        now: earlier,
      ).add(quoteId: 'quote-1', equipmentId: 'eq-1', quantity: 2)).item!;
      final later = DateTime(2031, 2, 1);

      final result = await buildService(now: later).updateQuantity(
        id: created.id,
        quantity: 7,
      );

      expect(result.isSuccess, isTrue);
      expect(result.item!.quantity, 7);
      expect(result.item!.createdAt, earlier);
      expect(result.item!.updatedAt, later);
    });

    test('removes a line', () async {
      final created = (await buildService().add(
        quoteId: 'quote-1',
        equipmentId: 'eq-1',
        quantity: 2,
      )).item!;

      final result = await buildService().remove(created.id);

      expect(result.status, QuoteEquipmentDeleteStatus.deleted);
      expect(await linkRepository.findById(created.id), isNull);
    });

    test('builds QuoteEquipmentSummary for a quote', () async {
      final service = buildService();
      await service.add(quoteId: 'quote-1', equipmentId: 'eq-1', quantity: 2);
      await service.add(quoteId: 'quote-1', equipmentId: 'eq-2', quantity: 5);

      final summary = await service.summaryForQuote('quote-1');

      expect(summary.quoteId, 'quote-1');
      expect(summary.lineCount, 2);
      expect(summary.totalQuantity, 7);
      expect(summary.hasItems, isTrue);
    });
  });
}
