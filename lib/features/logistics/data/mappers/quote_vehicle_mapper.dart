import 'package:drift/drift.dart';
import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/core/database/converters/timestamp_converter.dart';
import 'package:eventpro/features/logistics/models/quote_vehicle.dart';

abstract class QuoteVehicleMapper {
  static QuoteVehicle toDomain(QuoteVehicleRow row) {
    return QuoteVehicle(
      id: row.id,
      quoteId: row.quoteId,
      vehicleId: row.vehicleId,
      driverTeamMemberId: row.driverTeamMemberId,
      plannedDepartureAt: row.plannedDepartureAt == null
          ? null
          : TimestampConverter.fromUtcMillis(row.plannedDepartureAt!),
      plannedReturnAt: row.plannedReturnAt == null
          ? null
          : TimestampConverter.fromUtcMillis(row.plannedReturnAt!),
      freightCostCents: row.freightCostCents,
      notes: row.notes,
      createdAt: TimestampConverter.fromUtcMillis(row.createdAt),
      updatedAt: TimestampConverter.fromUtcMillis(row.updatedAt),
    );
  }

  static QuoteVehiclesCompanion toInsertCompanion(QuoteVehicle item) {
    return _toCompanion(item);
  }

  static QuoteVehiclesCompanion toUpdateCompanion(QuoteVehicle item) {
    return _toCompanion(item);
  }

  static QuoteVehiclesCompanion _toCompanion(QuoteVehicle item) {
    return QuoteVehiclesCompanion.insert(
      id: item.id,
      quoteId: item.quoteId,
      vehicleId: item.vehicleId,
      driverTeamMemberId: Value(item.driverTeamMemberId),
      plannedDepartureAt: Value(
        item.plannedDepartureAt == null
            ? null
            : TimestampConverter.toUtcMillis(item.plannedDepartureAt!),
      ),
      plannedReturnAt: Value(
        item.plannedReturnAt == null
            ? null
            : TimestampConverter.toUtcMillis(item.plannedReturnAt!),
      ),
      freightCostCents: item.freightCostCents,
      notes: Value(item.notes),
      createdAt: TimestampConverter.toUtcMillis(item.createdAt),
      updatedAt: TimestampConverter.toUtcMillis(item.updatedAt),
    );
  }
}
