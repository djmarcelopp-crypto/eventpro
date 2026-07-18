import 'package:eventpro/features/logistics/models/quote_vehicle.dart';

abstract class QuoteVehicleRepository {
  Future<List<QuoteVehicle>> listAll();

  Future<QuoteVehicle?> findById(String id);

  Future<List<QuoteVehicle>> listByQuoteId(String quoteId);

  Future<void> insert(QuoteVehicle item);

  Future<void> update(QuoteVehicle item);

  Future<void> delete(String id);
}
