import 'package:eventpro/features/quotes/data/repositories/quote_repository.dart';
import 'package:uuid/uuid.dart';

import '../data/repositories/equipment_repository.dart';
import '../data/repositories/quote_equipment_repository.dart';
import '../models/quote_equipment.dart';
import '../models/quote_equipment_delete_result.dart';
import '../models/quote_equipment_summary.dart';
import '../models/quote_equipment_write_result.dart';

/// Coordinates linking equipment quantities to quotes.
///
/// Does **not** compute availability, reserve stock, or mutate
/// [Equipment.status] — only validates existence and quantity, then persists.
class QuoteEquipmentService {
  QuoteEquipmentService({
    required QuoteEquipmentRepository quoteEquipmentRepository,
    required EquipmentRepository equipmentRepository,
    required QuoteRepository quoteRepository,
    DateTime Function()? clock,
  }) : _quoteEquipmentRepository = quoteEquipmentRepository,
       _equipmentRepository = equipmentRepository,
       _quoteRepository = quoteRepository,
       _clock = clock ?? DateTime.now;

  static const _uuid = Uuid();
  static const quantityGreaterThanZeroError =
      'Informe uma quantidade maior que zero';

  final QuoteEquipmentRepository _quoteEquipmentRepository;
  final EquipmentRepository _equipmentRepository;
  final QuoteRepository _quoteRepository;
  final DateTime Function() _clock;

  Future<QuoteEquipmentWriteResult> add({
    required String quoteId,
    required String equipmentId,
    required int quantity,
  }) async {
    if (quantity <= 0) {
      return QuoteEquipmentWriteResult.validationFailed(const [
        quantityGreaterThanZeroError,
      ]);
    }

    final quote = await _quoteRepository.findById(quoteId);
    if (quote == null) {
      return QuoteEquipmentWriteResult.quoteNotFound();
    }

    final equipment = await _equipmentRepository.findById(equipmentId);
    if (equipment == null) {
      return QuoteEquipmentWriteResult.equipmentNotFound();
    }

    final now = _clock();
    final item = QuoteEquipment(
      id: _uuid.v7(),
      quoteId: quoteId,
      equipmentId: equipmentId,
      quantity: quantity,
      createdAt: now,
      updatedAt: now,
    );

    try {
      await _quoteEquipmentRepository.insert(item);
      return QuoteEquipmentWriteResult.success(item);
    } catch (_) {
      return QuoteEquipmentWriteResult.failure();
    }
  }

  Future<QuoteEquipmentWriteResult> updateQuantity({
    required String id,
    required int quantity,
  }) async {
    if (quantity <= 0) {
      return QuoteEquipmentWriteResult.validationFailed(const [
        quantityGreaterThanZeroError,
      ]);
    }

    final existing = await _quoteEquipmentRepository.findById(id);
    if (existing == null) {
      return QuoteEquipmentWriteResult.notFound();
    }

    final now = _clock();
    final updated = existing.copyWith(quantity: quantity, updatedAt: now);

    try {
      await _quoteEquipmentRepository.update(updated);
      return QuoteEquipmentWriteResult.success(updated);
    } catch (_) {
      return QuoteEquipmentWriteResult.failure();
    }
  }

  Future<QuoteEquipmentDeleteResult> remove(String id) async {
    final existing = await _quoteEquipmentRepository.findById(id);
    if (existing == null) {
      return const QuoteEquipmentDeleteResult(
        status: QuoteEquipmentDeleteStatus.notFound,
      );
    }

    try {
      await _quoteEquipmentRepository.delete(id);
      return const QuoteEquipmentDeleteResult(
        status: QuoteEquipmentDeleteStatus.deleted,
      );
    } catch (_) {
      return const QuoteEquipmentDeleteResult(
        status: QuoteEquipmentDeleteStatus.failure,
      );
    }
  }

  Future<List<QuoteEquipment>> listForQuote(String quoteId) {
    return _quoteEquipmentRepository.listByQuoteId(quoteId);
  }

  Future<QuoteEquipmentSummary> summaryForQuote(String quoteId) async {
    final items = await _quoteEquipmentRepository.listByQuoteId(quoteId);
    return QuoteEquipmentSummary(quoteId: quoteId, items: items);
  }
}
