import 'package:eventpro/features/quotes/data/repositories/quote_repository.dart';
import 'package:eventpro/features/team/data/repositories/team_member_repository.dart';
import 'package:eventpro/features/team/models/team_member_status.dart';
import 'package:uuid/uuid.dart';

import '../data/repositories/quote_vehicle_repository.dart';
import '../data/repositories/vehicle_repository.dart';
import '../models/quote_vehicle.dart';
import '../models/quote_vehicle_summary.dart';
import '../models/quote_vehicle_write_result.dart';
import '../models/vehicle_status.dart';

/// Links vehicles to quotes for logistics planning.
///
/// Does **not** mutate [VehicleStatus] or compute schedule conflicts.
class QuoteVehicleService {
  QuoteVehicleService({
    required this._quoteVehicleRepository,
    required this._vehicleRepository,
    required this._quoteRepository,
    required this._teamMemberRepository,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  static const _uuid = Uuid();
  static const freightCostNonNegativeError =
      'Informe um custo de frete maior ou igual a zero';

  final QuoteVehicleRepository _quoteVehicleRepository;
  final VehicleRepository _vehicleRepository;
  final QuoteRepository _quoteRepository;
  final TeamMemberRepository _teamMemberRepository;
  final DateTime Function() _clock;

  Future<QuoteVehicleWriteResult> add({
    required String quoteId,
    required String vehicleId,
    String? driverTeamMemberId,
    DateTime? plannedDepartureAt,
    DateTime? plannedReturnAt,
    int freightCostCents = 0,
    String? notes,
  }) async {
    final scheduleError = _validateSchedule(
      plannedDepartureAt: plannedDepartureAt,
      plannedReturnAt: plannedReturnAt,
    );
    if (scheduleError != null) {
      return scheduleError;
    }
    if (freightCostCents < 0) {
      return QuoteVehicleWriteResult.validationFailed([
        freightCostNonNegativeError,
      ]);
    }

    final quote = await _quoteRepository.findById(quoteId);
    if (quote == null) {
      return QuoteVehicleWriteResult.quoteNotFound();
    }

    final vehicle = await _vehicleRepository.findById(vehicleId);
    if (vehicle == null) {
      return QuoteVehicleWriteResult.vehicleNotFound();
    }
    if (vehicle.status != VehicleStatus.available) {
      return QuoteVehicleWriteResult.vehicleUnavailable();
    }

    final driverError = await _checkDriver(driverTeamMemberId);
    if (driverError != null) {
      return driverError;
    }

    final existing = await _quoteVehicleRepository.listByQuoteId(quoteId);
    if (existing.any((line) => line.vehicleId == vehicleId)) {
      return QuoteVehicleWriteResult.duplicateVehicle();
    }

    final now = _clock();
    final trimmedNotes = notes?.trim();
    final item = QuoteVehicle(
      id: _uuid.v7(),
      quoteId: quoteId,
      vehicleId: vehicleId,
      driverTeamMemberId: driverTeamMemberId,
      plannedDepartureAt: plannedDepartureAt,
      plannedReturnAt: plannedReturnAt,
      freightCostCents: freightCostCents,
      notes: (trimmedNotes == null || trimmedNotes.isEmpty)
          ? null
          : trimmedNotes,
      createdAt: now,
      updatedAt: now,
    );

    try {
      await _quoteVehicleRepository.insert(item);
      return QuoteVehicleWriteResult.success(item);
    } catch (_) {
      return QuoteVehicleWriteResult.failure();
    }
  }

  Future<QuoteVehicleWriteResult> update(QuoteVehicle item) async {
    final existing = await _quoteVehicleRepository.findById(item.id);
    if (existing == null) {
      return QuoteVehicleWriteResult.notFound();
    }

    final scheduleError = _validateSchedule(
      plannedDepartureAt: item.plannedDepartureAt,
      plannedReturnAt: item.plannedReturnAt,
    );
    if (scheduleError != null) {
      return scheduleError;
    }
    if (item.freightCostCents < 0) {
      return QuoteVehicleWriteResult.validationFailed([
        freightCostNonNegativeError,
      ]);
    }

    final driverError = await _checkDriver(item.driverTeamMemberId);
    if (driverError != null) {
      return driverError;
    }

    final now = _clock();
    final trimmedNotes = item.notes?.trim();
    final normalized = QuoteVehicle(
      id: existing.id,
      quoteId: existing.quoteId,
      vehicleId: existing.vehicleId,
      driverTeamMemberId: item.driverTeamMemberId,
      plannedDepartureAt: item.plannedDepartureAt,
      plannedReturnAt: item.plannedReturnAt,
      freightCostCents: item.freightCostCents,
      notes: (trimmedNotes == null || trimmedNotes.isEmpty)
          ? null
          : trimmedNotes,
      createdAt: existing.createdAt,
      updatedAt: now,
    );

    try {
      await _quoteVehicleRepository.update(normalized);
      return QuoteVehicleWriteResult.success(normalized);
    } catch (_) {
      return QuoteVehicleWriteResult.failure();
    }
  }

  Future<QuoteVehicleDeleteResult> remove(String id) async {
    final existing = await _quoteVehicleRepository.findById(id);
    if (existing == null) {
      return const QuoteVehicleDeleteResult(
        status: QuoteVehicleDeleteStatus.notFound,
      );
    }

    try {
      await _quoteVehicleRepository.delete(id);
      return const QuoteVehicleDeleteResult(
        status: QuoteVehicleDeleteStatus.deleted,
      );
    } catch (_) {
      return const QuoteVehicleDeleteResult(
        status: QuoteVehicleDeleteStatus.failure,
      );
    }
  }

  Future<List<QuoteVehicle>> listForQuote(String quoteId) {
    return _quoteVehicleRepository.listByQuoteId(quoteId);
  }

  Future<QuoteVehicleSummary> summaryForQuote(String quoteId) async {
    final items = await _quoteVehicleRepository.listByQuoteId(quoteId);
    return QuoteVehicleSummary(quoteId: quoteId, items: items);
  }

  QuoteVehicleWriteResult? _validateSchedule({
    DateTime? plannedDepartureAt,
    DateTime? plannedReturnAt,
  }) {
    if (plannedDepartureAt != null &&
        plannedReturnAt != null &&
        plannedReturnAt.isBefore(plannedDepartureAt)) {
      return QuoteVehicleWriteResult.invalidSchedule();
    }
    return null;
  }

  Future<QuoteVehicleWriteResult?> _checkDriver(String? driverId) async {
    if (driverId == null || driverId.trim().isEmpty) {
      return null;
    }
    final driver = await _teamMemberRepository.findById(driverId);
    if (driver == null) {
      return QuoteVehicleWriteResult.driverNotFound();
    }
    if (driver.status != TeamMemberStatus.active) {
      return QuoteVehicleWriteResult.driverInactive();
    }
    return null;
  }
}
