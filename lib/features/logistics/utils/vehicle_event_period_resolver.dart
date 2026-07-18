import '../../quotes/models/quote.dart';
import '../../quotes/models/quote_event_snapshot.dart';
import '../models/quote_vehicle.dart';
import '../models/vehicle_event_period.dart';

/// Resolves a logistics period for a [QuoteVehicle] link.
///
/// Priority:
/// 1. [QuoteVehicle.plannedDepartureAt] + [QuoteVehicle.plannedReturnAt]
///    when **both** are set and return is after departure;
/// 2. otherwise the quote event period (same civil-date rules as team/equipment);
/// 3. `null` when no valid period can be resolved — the link is ignored.
///
/// Does **not** invent a missing planned timestamp when only one side is set.
abstract class VehicleEventPeriodResolver {
  static const fallbackStartHour = 0;
  static const fallbackStartMinute = 0;
  static const fallbackEndHour = 23;
  static const fallbackEndMinute = 59;

  static VehicleEventPeriod? resolve({
    required QuoteVehicle link,
    required Quote quote,
  }) {
    final planned = resolvePlanned(link);
    if (planned != null) {
      return planned;
    }
    return resolveFromEvent(quote.eventSnapshot);
  }

  /// Planned logistics window when both timestamps exist and are ordered.
  static VehicleEventPeriod? resolvePlanned(QuoteVehicle link) {
    final departure = link.plannedDepartureAt;
    final returnAt = link.plannedReturnAt;
    if (departure == null || returnAt == null) {
      return null;
    }
    if (!returnAt.isAfter(departure)) {
      return null;
    }
    return VehicleEventPeriod(start: departure, end: returnAt);
  }

  /// Returns `null` when the snapshot has no date.
  static VehicleEventPeriod? resolveFromEvent(QuoteEventSnapshot snapshot) {
    final date = snapshot.date;
    if (date == null) {
      return null;
    }

    final start = _applyTime(
      date,
      snapshot.startTime,
      fallbackHour: fallbackStartHour,
      fallbackMinute: fallbackStartMinute,
    );
    var end = _applyTime(
      date,
      snapshot.endTime,
      fallbackHour: fallbackEndHour,
      fallbackMinute: fallbackEndMinute,
    );

    if (!end.isAfter(start)) {
      end = end.add(const Duration(days: 1));
    }

    return VehicleEventPeriod(start: start, end: end);
  }

  static DateTime _applyTime(
    DateTime civilDate,
    String? time, {
    required int fallbackHour,
    required int fallbackMinute,
  }) {
    final parsed = _parseTime(time);
    return DateTime(
      civilDate.year,
      civilDate.month,
      civilDate.day,
      parsed?.hour ?? fallbackHour,
      parsed?.minute ?? fallbackMinute,
    );
  }

  static ({int hour, int minute})? _parseTime(String? value) {
    if (value == null) {
      return null;
    }
    final match = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(value.trim());
    if (match == null) {
      return null;
    }

    final hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }

    return (hour: hour, minute: minute);
  }
}
