import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quote_equipment.dart';
import '../models/quote_equipment_delete_result.dart';
import '../models/quote_equipment_summary.dart';
import '../models/quote_equipment_write_result.dart';
import '../utils/quote_equipment_service.dart';
import 'quote_equipment_service_provider.dart';

/// QuoteEquipmentProvider — orchestrates [QuoteEquipmentService] per quote.
///
/// Riverpod 3 family: the quote id is injected via the notifier constructor.
class QuoteEquipmentNotifier extends AsyncNotifier<List<QuoteEquipment>> {
  QuoteEquipmentNotifier(this.quoteId);

  final String quoteId;

  QuoteEquipmentService get _service =>
      ref.read(quoteEquipmentServiceProvider);

  @override
  Future<List<QuoteEquipment>> build() async {
    return _service.listForQuote(quoteId);
  }

  void hydrate(List<QuoteEquipment> items) {
    state = AsyncValue.data(List<QuoteEquipment>.unmodifiable(items));
  }

  QuoteEquipmentSummary get summary {
    final items = state.value ?? const <QuoteEquipment>[];
    return QuoteEquipmentSummary(quoteId: quoteId, items: items);
  }

  Future<QuoteEquipmentWriteResult> add({
    required String equipmentId,
    required int quantity,
  }) async {
    final result = await _service.add(
      quoteId: quoteId,
      equipmentId: equipmentId,
      quantity: quantity,
    );
    if (result.isSuccess && result.item != null) {
      final current = state.value ?? const <QuoteEquipment>[];
      state = AsyncValue.data(
        List<QuoteEquipment>.unmodifiable([...current, result.item!]),
      );
    }
    return result;
  }

  Future<QuoteEquipmentWriteResult> updateQuantity({
    required String id,
    required int quantity,
  }) async {
    final result = await _service.updateQuantity(id: id, quantity: quantity);
    if (result.isSuccess && result.item != null) {
      final current = state.value ?? const <QuoteEquipment>[];
      state = AsyncValue.data(
        List<QuoteEquipment>.unmodifiable([
          for (final item in current)
            if (item.id == result.item!.id) result.item! else item,
        ]),
      );
    }
    return result;
  }

  Future<QuoteEquipmentDeleteResult> remove(String id) async {
    final result = await _service.remove(id);
    if (result.isDeleted) {
      final current = state.value ?? const <QuoteEquipment>[];
      state = AsyncValue.data(
        List<QuoteEquipment>.unmodifiable([
          for (final item in current)
            if (item.id != id) item,
        ]),
      );
    }
    return result;
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _service.listForQuote(quoteId));
  }
}

final quoteEquipmentProvider = AsyncNotifierProvider.family<
  QuoteEquipmentNotifier,
  List<QuoteEquipment>,
  String
>(QuoteEquipmentNotifier.new);

final quoteEquipmentSummaryProvider =
    Provider.family<AsyncValue<QuoteEquipmentSummary>, String>((ref, quoteId) {
      final itemsAsync = ref.watch(quoteEquipmentProvider(quoteId));
      return itemsAsync.whenData(
        (items) => QuoteEquipmentSummary(quoteId: quoteId, items: items),
      );
    });
