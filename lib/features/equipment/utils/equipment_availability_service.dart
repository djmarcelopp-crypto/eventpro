import '../../quotes/data/repositories/quote_repository.dart';
import '../../quotes/models/quote.dart';
import '../data/repositories/equipment_repository.dart';
import '../data/repositories/quote_equipment_repository.dart';
import '../models/equipment_availability.dart';
import '../models/equipment_availability_summary.dart';
import 'equipment_availability_calculator.dart';

/// Loads inventory and quote lines, then delegates to
/// [EquipmentAvailabilityCalculator].
///
/// Does **not** persist availability quantities or change [Equipment.status].
class EquipmentAvailabilityService {
  EquipmentAvailabilityService({
    required EquipmentRepository equipmentRepository,
    required QuoteEquipmentRepository quoteEquipmentRepository,
    required QuoteRepository quoteRepository,
  }) : _equipmentRepository = equipmentRepository,
       _quoteEquipmentRepository = quoteEquipmentRepository,
       _quoteRepository = quoteRepository;

  final EquipmentRepository _equipmentRepository;
  final QuoteEquipmentRepository _quoteEquipmentRepository;
  final QuoteRepository _quoteRepository;

  Future<List<EquipmentAvailability>> listAll() async {
    final equipment = await _equipmentRepository.listAll();
    final quoteEquipment = await _quoteEquipmentRepository.listAll();
    final quotes = await _quoteRepository.listAll();
    return EquipmentAvailabilityCalculator.calculateAll(
      equipment: equipment,
      quoteEquipment: quoteEquipment,
      quotes: quotes,
    );
  }

  Future<EquipmentAvailability?> forEquipment(String equipmentId) async {
    final equipment = await _equipmentRepository.findById(equipmentId);
    if (equipment == null) {
      return null;
    }
    final quoteEquipment = await _quoteEquipmentRepository.listAll();
    final quotes = await _quoteRepository.listAll();
    return EquipmentAvailabilityCalculator.calculateForEquipment(
      equipment: equipment,
      quoteEquipment: quoteEquipment,
      quotesById: <String, Quote>{
        for (final quote in quotes) quote.id: quote,
      },
    );
  }

  Future<EquipmentAvailabilitySummary> summary() async {
    final items = await listAll();
    return EquipmentAvailabilityCalculator.summarize(items);
  }
}
