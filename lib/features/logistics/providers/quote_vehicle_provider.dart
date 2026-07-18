import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quote_vehicle.dart';
import '../models/quote_vehicle_summary.dart';
import '../models/quote_vehicle_write_result.dart';
import '../utils/quote_vehicle_service.dart';
import 'quote_vehicle_service_provider.dart';

class QuoteVehicleNotifier extends AsyncNotifier<List<QuoteVehicle>> {
  QuoteVehicleNotifier(this.quoteId);

  final String quoteId;

  QuoteVehicleService get _service => ref.read(quoteVehicleServiceProvider);

  @override
  Future<List<QuoteVehicle>> build() async {
    return _service.listForQuote(quoteId);
  }

  Future<QuoteVehicleWriteResult> add({
    required String vehicleId,
    String? driverTeamMemberId,
    DateTime? plannedDepartureAt,
    DateTime? plannedReturnAt,
    int freightCostCents = 0,
    String? notes,
  }) async {
    final result = await _service.add(
      quoteId: quoteId,
      vehicleId: vehicleId,
      driverTeamMemberId: driverTeamMemberId,
      plannedDepartureAt: plannedDepartureAt,
      plannedReturnAt: plannedReturnAt,
      freightCostCents: freightCostCents,
      notes: notes,
    );
    if (result.isSuccess && result.item != null) {
      final current = state.value ?? const <QuoteVehicle>[];
      state = AsyncValue.data(
        List.unmodifiable([...current, result.item!]),
      );
    }
    return result;
  }

  Future<QuoteVehicleWriteResult> updateItem(QuoteVehicle item) async {
    final result = await _service.update(item);
    if (result.isSuccess && result.item != null) {
      final current = state.value ?? const <QuoteVehicle>[];
      state = AsyncValue.data(
        List.unmodifiable([
          for (final row in current)
            if (row.id == result.item!.id) result.item! else row,
        ]),
      );
    }
    return result;
  }

  Future<QuoteVehicleDeleteResult> remove(String id) async {
    final result = await _service.remove(id);
    if (result.isDeleted) {
      final current = state.value ?? const <QuoteVehicle>[];
      state = AsyncValue.data(
        List.unmodifiable([
          for (final item in current)
            if (item.id != id) item,
        ]),
      );
    }
    return result;
  }
}

final quoteVehicleProvider = AsyncNotifierProvider.family<
  QuoteVehicleNotifier,
  List<QuoteVehicle>,
  String
>(QuoteVehicleNotifier.new);

final quoteVehicleSummaryProvider =
    Provider.family<AsyncValue<QuoteVehicleSummary>, String>((ref, quoteId) {
      return ref.watch(quoteVehicleProvider(quoteId)).whenData(
            (items) => QuoteVehicleSummary(quoteId: quoteId, items: items),
          );
    });
